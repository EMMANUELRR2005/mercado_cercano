import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/firebase/firestore_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/entities/vendor_entity.dart';
import '../../domain/entities/search_filters.dart';
import '../models/product_search_result_model.dart';
import 'buyer_remote_datasource.dart';

/// Implementación REAL del comprador contra Cloud Firestore
/// (`AppConstants.useFirestore`).
///
/// Estrategia de filtros:
/// - En el SERVIDOR solo van los filtros baratos e indexables sin índice
///   compuesto: `isAvailable` (si el filtro lo pide) y `category`.
/// - El RESTO se aplica EN CLIENTE: texto (contains, sin distinguir
///   mayúsculas), precio máximo, rating mínimo del vendedor, radio y
///   ordenamiento. Con el volumen actual (decenas de productos por zona)
///   esto evita índices compuestos y queries imposibles en Firestore
///   (no soporta `contains` de texto).
///
/// DISTANCIA: mientras no pidamos la ubicación real del comprador, la
/// distancia se calcula con `Geolocator.distanceBetween` desde el centro
/// de Ciudad de Guatemala (`AppConstants.guatemalaCityLat/Lng`) hasta las
/// `coordinates` del vendedor. Cuando exista un servicio de ubicación,
/// se inyectará aquí y solo cambia el punto de origen (geolocator ya es
/// dependencia del proyecto).
class BuyerFirestoreDatasource implements BuyerRemoteDatasource {
  BuyerFirestoreDatasource(this._firestore, this._secureStorage);

  final FirestoreService _firestore;
  final SecureStorageService _secureStorage;

  static const _productsCollection = 'products';
  static const _vendorsCollection = 'vendors';
  static const _reportsCollection = 'price_reports';

  /// Distancia asignada cuando el vendedor no comparte coordenadas:
  /// queda fuera de cualquier radio razonable (igual que el mock).
  static const double _unknownDistanceKm = 99;

  /// Cache en memoria de vendedores por id para no releer el mismo doc
  /// en cada resultado de búsqueda. `isActive` no existe en la entidad
  /// compartida, así que se guarda junto al vendedor mapeado.
  final Map<String, ({VendorEntity vendor, bool isActive})> _vendorCache = {};

  // -------------------------------------------------------------------
  // Búsqueda
  // -------------------------------------------------------------------

  @override
  Future<List<ProductSearchResultModel>> searchProducts({
    String? query,
    required SearchFilters filters,
  }) async {
    // Filtros que sí van al servidor (solo igualdades: no requieren
    // índice compuesto en Firestore).
    final docs = await _firestore.getCollection(
      _productsCollection,
      queryBuilder: (q) {
        var built = q;
        if (filters.onlyAvailable) {
          built = built.where('isAvailable', isEqualTo: true);
        }
        if (filters.category != null) {
          built = built.where('category', isEqualTo: filters.category!.name);
        }
        return built;
      },
    );

    final products = docs.map(_productFromDoc).toList();

    // Cargar los vendedores referenciados (con cache en memoria).
    await _loadVendors(products.map((p) => p.vendorId).toSet());

    final q = query?.trim().toLowerCase();

    // Resto de los filtros EN CLIENTE (texto, precio, rating, radio).
    final results = <ProductSearchResultModel>[];
    for (final product in products) {
      final cached = _vendorCache[product.vendorId];
      // Sin vendedor (doc borrado) o vendedor inactivo → no se muestra.
      if (cached == null || !cached.isActive) continue;
      final vendor = cached.vendor;

      final distanceKm = _distanceKm(vendor);
      if (distanceKm > filters.radiusKm) continue;
      if (filters.maxPrice != null && product.price > filters.maxPrice!) {
        continue;
      }
      if (vendor.rating < filters.minRating) continue;
      if (q != null && q.isNotEmpty) {
        final haystack = '${product.name} ${vendor.name}'.toLowerCase();
        if (!haystack.contains(q)) continue;
      }

      results.add(ProductSearchResultModel(
        product: product,
        vendor: vendor,
        distanceKm: distanceKm,
      ));
    }

    _sortResults(results, filters.sortBy, q);
    return results;
  }

  /// Ordenamiento en cliente, mismo criterio que el mock.
  void _sortResults(
    List<ProductSearchResultModel> results,
    SortOrder sortBy,
    String? q,
  ) {
    switch (sortBy) {
      case SortOrder.relevance:
        if (q != null && q.isNotEmpty) {
          // Coincidencia más temprana en el nombre = más relevante.
          results.sort((a, b) {
            final ia = a.product.name.toLowerCase().indexOf(q);
            final ib = b.product.name.toLowerCase().indexOf(q);
            final ra = ia < 0 ? 999 : ia;
            final rb = ib < 0 ? 999 : ib;
            if (ra != rb) return ra.compareTo(rb);
            return a.distanceKm.compareTo(b.distanceKm);
          });
        }
      case SortOrder.priceLow:
        results.sort((a, b) => a.product.price.compareTo(b.product.price));
      case SortOrder.priceHigh:
        results.sort((a, b) => b.product.price.compareTo(a.product.price));
      case SortOrder.distance:
        results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      case SortOrder.rating:
        results.sort((a, b) => b.vendor.rating.compareTo(a.vendor.rating));
    }
  }

  // -------------------------------------------------------------------
  // Detalle de producto
  // -------------------------------------------------------------------

  @override
  Future<ProductSearchResultModel> getProductDetail(String productId) async {
    final doc = await _firestore.getDocument(_productsCollection, productId);
    if (doc == null) {
      throw const ValidationException('El producto no existe',
          statusCode: 404);
    }
    final product = _productFromDoc(doc);

    // Registrar la vista (analytics del vendedor). Es best-effort: si
    // las reglas lo rechazan, no debe romper la pantalla del comprador.
    try {
      await _firestore.updateDocument(_productsCollection, productId, {
        'viewCount': FieldValue.increment(1),
      });
    } on AppException {
      // La vista no se registró; el detalle se muestra igual.
    }

    await _loadVendors({product.vendorId});
    final cached = _vendorCache[product.vendorId];
    if (cached == null) {
      throw const ValidationException('El vendedor no existe',
          statusCode: 404);
    }

    return ProductSearchResultModel(
      // Reflejar localmente la vista recién registrada.
      product: product.copyWith(viewCount: product.viewCount + 1),
      vendor: cached.vendor,
      distanceKm: _distanceKm(cached.vendor),
    );
  }

  // -------------------------------------------------------------------
  // Detalle de vendedor
  // -------------------------------------------------------------------

  @override
  Future<VendorDetailModel> getVendorDetail(String vendorId) async {
    final doc = await _firestore.getDocument(_vendorsCollection, vendorId);
    if (doc == null) {
      throw const ValidationException('El vendedor no existe',
          statusCode: 404);
    }
    final vendor = _vendorFromDoc(doc);
    _vendorCache[vendorId] =
        (vendor: vendor, isActive: (doc['isActive'] as bool?) ?? true);

    // Catálogo vigente: el filtro de expiración va en cliente porque
    // igualdad (vendorId) + rango (expiresAt) exigiría índice compuesto.
    final now = DateTime.now();
    final productDocs = await _firestore.getCollection(
      _productsCollection,
      queryBuilder: (q) => q.where('vendorId', isEqualTo: vendorId),
    );
    final products = productDocs
        .map(_productFromDoc)
        .where((p) => p.expiresAt.isAfter(now))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return VendorDetailModel(
      vendor: vendor,
      products: products,
      distanceKm: _distanceKm(vendor),
    );
  }

  // -------------------------------------------------------------------
  // Reporte ciudadano de precio
  // -------------------------------------------------------------------

  @override
  Future<void> reportPrice({
    required String productName,
    required double price,
    required String unit,
    required String zone,
  }) async {
    final name = productName.trim();
    if (name.isEmpty) {
      throw const ValidationException('El nombre del producto es requerido');
    }
    if (price <= 0) {
      throw const ValidationException('El precio debe ser mayor a 0');
    }

    // El reporte queda asociado al usuario actual; si aún no hay sesión
    // persistida, se registra como anónimo (los reportes son anónimos
    // de cara a la comunidad de todos modos).
    final userId = await _secureStorage.getUserId() ?? 'anonymous';

    await _firestore.setDocument(_reportsCollection, {
      'productName': name,
      // La categoría se infiere del nombre para que el índice de precios
      // pueda agrupar; si no se reconoce, queda como 'other'.
      'category': _inferCategory(name).name,
      'price': price,
      'unit': unit,
      'zone': zone.trim(),
      'reportedBy': userId,
      'reportedAt': FieldValue.serverTimestamp(),
      // businessName es opcional en el esquema; el reporte ciudadano no
      // está ligado a un negocio concreto, así que no se envía.
    });
  }

  /// Infiere la categoría a partir del nombre del producto reportado
  /// (palabras clave del mercado guatemalteco). Devuelve `other` si no
  /// reconoce ninguna.
  ProductCategory _inferCategory(String productName) {
    final name = productName.toLowerCase();

    const keywords = <ProductCategory, List<String>>{
      ProductCategory.fruitsVegetables: [
        'tomate', 'cebolla', 'papa', 'aguacate', 'plátano', 'platano',
        'banano', 'limón', 'limon', 'chile', 'zanahoria', 'repollo',
        'güisquil', 'guisquil', 'mango', 'piña', 'pina', 'naranja',
        'brócoli', 'brocoli', 'ejote', 'verdura', 'fruta', 'culantro',
        'cilantro', 'hierba', 'rábano', 'rabano', 'pepino', 'sandía',
        'sandia', 'papaya', 'melón', 'melon',
      ],
      ProductCategory.meats: [
        'pollo', 'carne', 'res', 'cerdo', 'marrano', 'costilla',
        'chicharrón', 'chicharron', 'pescado', 'camarón', 'camaron',
        'chorizo', 'longaniza', 'salchicha', 'posta', 'hueso', 'gallina',
      ],
      ProductCategory.dairy: [
        'queso', 'leche', 'crema', 'huevo', 'mantequilla', 'requesón',
        'requeson', 'yogur',
      ],
      ProductCategory.grains: [
        'frijol', 'arroz', 'maíz', 'maiz', 'azúcar', 'azucar', 'café',
        'cafe', 'avena', 'harina', 'lenteja', 'cereal', 'masa', 'trigo',
      ],
      ProductCategory.preparedFood: [
        'almuerzo', 'desayuno', 'tostada', 'comida', 'caldo', 'pepián',
        'pepian', 'hilachas', 'tamal', 'chuchito', 'atol', 'tortilla',
        'rellenito', 'shuco', 'pan',
      ],
      ProductCategory.clothing: [
        'camisa', 'pantalón', 'pantalon', 'ropa', 'zapato', 'güipil',
        'guipil', 'playera', 'chumpa', 'falda', 'corte',
      ],
      ProductCategory.services: [
        'servicio', 'reparación', 'reparacion', 'corte de pelo',
        'costura', 'sastrería', 'sastreria',
      ],
    };

    for (final entry in keywords.entries) {
      if (entry.value.any(name.contains)) return entry.key;
    }
    return ProductCategory.other;
  }

  // -------------------------------------------------------------------
  // Carga de vendedores + mapeo Firestore → entidades
  // -------------------------------------------------------------------

  /// Carga en cache los vendedores que aún no estén en memoria, en lotes
  /// de hasta 10 ids por query (`whereIn` sobre el id del documento).
  Future<void> _loadVendors(Set<String> vendorIds) async {
    final missing =
        vendorIds.where((id) => !_vendorCache.containsKey(id)).toList();
    if (missing.isEmpty) return;

    const chunkSize = 10;
    for (var i = 0; i < missing.length; i += chunkSize) {
      final chunk = missing.sublist(
        i,
        i + chunkSize > missing.length ? missing.length : i + chunkSize,
      );
      final docs = await _firestore.getCollection(
        _vendorsCollection,
        queryBuilder: (q) =>
            q.where(FieldPath.documentId, whereIn: chunk),
      );
      for (final doc in docs) {
        _vendorCache[doc['id'] as String] = (
          vendor: _vendorFromDoc(doc),
          isActive: (doc['isActive'] as bool?) ?? true,
        );
      }
    }
  }

  /// Distancia (km) desde el centro de Ciudad de Guatemala al vendedor.
  /// Cuando exista la ubicación real del comprador, solo cambia el
  /// punto de origen.
  double _distanceKm(VendorEntity vendor) {
    final lat = vendor.latitude;
    final lng = vendor.longitude;
    if (lat == null || lng == null) return _unknownDistanceKm;
    final meters = Geolocator.distanceBetween(
      AppConstants.guatemalaCityLat,
      AppConstants.guatemalaCityLng,
      lat,
      lng,
    );
    return meters / 1000;
  }

  /// Mapea un doc de `products` a la entidad compartida.
  ProductEntity _productFromDoc(Map<String, dynamic> doc) {
    return ProductEntity(
      id: doc['id'] as String,
      vendorId: (doc['vendorId'] as String?) ?? '',
      name: (doc['name'] as String?) ?? '',
      category: _categoryFromName(doc['category'] as String?),
      price: _toDouble(doc['price']),
      photoUrl: (doc['photoUrl'] as String?) ?? '',
      isAvailable: (doc['isAvailable'] as bool?) ?? false,
      expiresAt: _toDate(doc['expiresAt']),
      createdAt: _toDate(doc['createdAt']),
      viewCount: _toInt(doc['viewCount']),
      // clickCount no existe (aún) en el esquema de Firestore.
      clickCount: _toInt(doc['clickCount']),
      isFeatured: doc['isFeatured'] as bool?,
      description: doc['description'] as String?,
      unit: doc['unit'] as String?,
    );
  }

  /// Mapea un doc de `vendors` a la entidad compartida.
  ///
  /// El esquema usa `businessName`, `zone`, `neighborhood` y
  /// `coordinates` (GeoPoint); la dirección visible se compone como
  /// "barrio, zona". `phone`/`whatsapp` se leen si el doc los trae
  /// (los agrega el flujo del vendedor).
  VendorEntity _vendorFromDoc(Map<String, dynamic> doc) {
    final coordinates = doc['coordinates'];
    final neighborhood = doc['neighborhood'] as String?;
    final zone = doc['zone'] as String?;
    final address = [
      if (neighborhood != null && neighborhood.isNotEmpty) neighborhood,
      if (zone != null && zone.isNotEmpty) zone,
    ].join(', ');

    return VendorEntity(
      id: doc['id'] as String,
      name: (doc['businessName'] as String?) ?? 'Vendedor',
      phone: (doc['phone'] as String?) ?? '',
      whatsapp: doc['whatsapp'] as String?,
      category: _categoryFromName(doc['category'] as String?),
      rating: _toDouble(doc['rating']),
      totalRatings: _toInt(doc['totalRatings']),
      isVerified: (doc['isVerified'] as bool?) ?? false,
      photoUrl: doc['photoUrl'] as String?,
      description: doc['description'] as String?,
      address: address.isEmpty ? null : address,
      latitude: coordinates is GeoPoint ? coordinates.latitude : null,
      longitude: coordinates is GeoPoint ? coordinates.longitude : null,
    );
  }

  /// `category` viaja como el `name` del enum; desconocido → `other`.
  ProductCategory _categoryFromName(String? name) {
    return ProductCategory.values.firstWhere(
      (c) => c.name == name,
      orElse: () => ProductCategory.other,
    );
  }

  double _toDouble(Object? value) => (value as num?)?.toDouble() ?? 0;

  int _toInt(Object? value) => (value as num?)?.toInt() ?? 0;

  /// Timestamps de Firestore → DateTime local.
  DateTime _toDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
