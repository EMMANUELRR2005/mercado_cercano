import '../../../../core/errors/app_exception.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/entities/vendor_entity.dart';
import '../../domain/entities/search_filters.dart';
import '../models/product_search_result_model.dart';
import 'buyer_remote_datasource.dart';

/// Implementación MOCK del comprador (AppConstants.useMockData).
///
/// - 5 vendedores ficticios alrededor de Ciudad de Guatemala con
///   distancias fijas de 0.3 a 4.8 km.
/// - ~20 productos con precios realistas de Guatemala (Q, 2026).
/// - La búsqueda aplica DE VERDAD los [SearchFilters]: radio, precio
///   máximo, rating mínimo, disponibilidad, categoría, texto y orden.
/// - Las vistas de producto se registran en memoria (`viewCount`).
class BuyerMockDatasource implements BuyerRemoteDatasource {
  BuyerMockDatasource() : _products = _seedProducts();

  static const _delay = Duration(milliseconds: 500);

  /// Distancia fija (km) del comprador a cada vendedor.
  static const Map<String, double> _distancesKm = {
    'vendor_001': 0.3,
    'vendor_002': 1.2,
    'vendor_003': 0.8,
    'vendor_004': 2.5,
    'vendor_005': 4.8,
  };

  /// Vendedores ficticios alrededor del centro de Ciudad de Guatemala
  /// (14.6349, -90.5069 ± 0.02). Dos verificados.
  static final List<VendorEntity> _vendors = [
    const VendorEntity(
      id: 'vendor_001',
      name: 'Doña María Tienda La Bendición',
      phone: '55123456',
      whatsapp: '55123456',
      category: ProductCategory.grains,
      rating: 4.6,
      totalRatings: 87,
      isVerified: false,
      photoUrl: 'https://picsum.photos/seed/101/400/300',
      description: 'Tienda de barrio con granos básicos, huevos y abarrotes. '
          'Atendemos con cariño desde 1998.',
      address: '4a calle 5-21, Zona 1, Ciudad de Guatemala',
      latitude: 14.6378,
      longitude: -90.5102,
    ),
    const VendorEntity(
      id: 'vendor_002',
      name: 'Carnicería El Buen Precio de Don Carlos',
      phone: '55234567',
      whatsapp: '55234567',
      category: ProductCategory.meats,
      rating: 4.9,
      totalRatings: 153,
      isVerified: true,
      photoUrl: 'https://picsum.photos/seed/102/400/300',
      description: 'Carne fresca todos los días. Res, cerdo y pollo de '
          'granja. Cortes al gusto del cliente.',
      address: 'Mercado Central, local 23, Zona 1, Ciudad de Guatemala',
      latitude: 14.6421,
      longitude: -90.4987,
    ),
    const VendorEntity(
      id: 'vendor_003',
      name: 'Frutas Doña Rosa',
      phone: '55345678',
      whatsapp: '55345678',
      category: ProductCategory.fruitsVegetables,
      rating: 4.8,
      totalRatings: 210,
      isVerified: true,
      photoUrl: 'https://picsum.photos/seed/103/400/300',
      description: 'Fruta y verdura fresca de Almolonga y Palín. '
          'Llegamos al mercado a las 5 de la mañana.',
      address: '9a avenida 8-44, Zona 1, Ciudad de Guatemala',
      latitude: 14.6302,
      longitude: -90.5134,
    ),
    const VendorEntity(
      id: 'vendor_004',
      name: 'Abarrotería San Judas',
      phone: '55456789',
      whatsapp: '55456789',
      category: ProductCategory.other,
      rating: 4.2,
      totalRatings: 64,
      isVerified: false,
      photoUrl: 'https://picsum.photos/seed/104/400/300',
      description: 'Abarrotes, café de Huehuetenango y queso fresco de '
          'Zacapa. Aceptamos encargos.',
      address: '12 calle 10-32, Zona 1, Ciudad de Guatemala',
      latitude: 14.6498,
      longitude: -90.5211,
    ),
    const VendorEntity(
      id: 'vendor_005',
      name: 'Comedor Doña Tere',
      phone: '55567890',
      whatsapp: '55567890',
      category: ProductCategory.preparedFood,
      rating: 3.8,
      totalRatings: 45,
      isVerified: false,
      photoUrl: 'https://picsum.photos/seed/105/400/300',
      description: 'Comida casera chapina: caldos, hilachas y pepián. '
          'Almuerzos para llevar.',
      address: '20 calle 2-15, Zona 1, Ciudad de Guatemala',
      latitude: 14.6189,
      longitude: -90.4912,
    ),
  ];

  /// Productos vigentes; lista mutable para registrar vistas.
  final List<ProductEntity> _products;

  /// Reportes de precio recibidos durante la sesión (solo se acumulan).
  final List<Map<String, Object>> _priceReports = [];

  static List<ProductEntity> _seedProducts() {
    var seed = 0;
    ProductEntity p(
      String vendorId,
      String name,
      ProductCategory category,
      double price,
      String unit, {
      bool available = true,
      bool featured = false,
      String? description,
    }) {
      seed++;
      final now = DateTime.now();
      return ProductEntity(
        id: 'prod_${seed.toString().padLeft(3, '0')}',
        vendorId: vendorId,
        name: name,
        category: category,
        price: price,
        photoUrl: 'https://picsum.photos/seed/$seed/400/300',
        isAvailable: available,
        // Publicado hace unas horas; vence dentro de la ventana de 24 h.
        expiresAt: now.add(Duration(hours: 24 - (seed % 8) - 2)),
        createdAt: now.subtract(Duration(hours: (seed % 8) + 2)),
        viewCount: 12 + seed * 7,
        clickCount: 3 + seed * 2,
        isFeatured: featured,
        description: description,
        unit: unit,
      );
    }

    return [
      // --- Frutas Doña Rosa (vendor_003) ---
      p('vendor_003', 'Tomate manzano', ProductCategory.fruitsVegetables,
          4.50, 'lb',
          featured: true,
          description: 'Tomate fresco de Almolonga, ideal para chirmol.'),
      p('vendor_003', 'Cebolla blanca', ProductCategory.fruitsVegetables,
          5.00, 'lb'),
      p('vendor_003', 'Papa grande', ProductCategory.fruitsVegetables,
          4.75, 'lb',
          description: 'Papa lavada de Patzicía.'),
      p('vendor_003', 'Aguacate Hass', ProductCategory.fruitsVegetables,
          6.00, 'unidad'),
      p('vendor_003', 'Plátano maduro', ProductCategory.fruitsVegetables,
          2.00, 'unidad'),
      p('vendor_003', 'Limón criollo', ProductCategory.fruitsVegetables,
          0.75, 'unidad'),
      p('vendor_003', 'Chile pimiento', ProductCategory.fruitsVegetables,
          4.00, 'unidad'),

      // --- Carnicería El Buen Precio (vendor_002) ---
      p('vendor_002', 'Pollo entero', ProductCategory.meats, 24.00, 'lb',
          featured: true,
          description: 'Pollo de granja, fresco del día.'),
      p('vendor_002', 'Carne molida de res', ProductCategory.meats,
          38.00, 'lb'),
      p('vendor_002', 'Costilla de res', ProductCategory.meats, 42.00, 'lb',
          available: false,
          description: 'Se terminó hoy, vuelve mañana temprano.'),
      p('vendor_002', 'Chicharrón con yuca', ProductCategory.meats,
          35.00, 'lb'),

      // --- Tienda La Bendición (vendor_001) ---
      p('vendor_001', 'Huevos de granja', ProductCategory.grains,
          58.00, 'cartón',
          description: 'Cartón de 30 unidades, huevo mediano.'),
      p('vendor_001', 'Azúcar blanca', ProductCategory.grains, 4.50, 'lb'),
      p('vendor_001', 'Arroz blanco', ProductCategory.grains, 6.00, 'lb'),
      p('vendor_001', 'Frijol negro', ProductCategory.grains, 7.00, 'lb',
          description: 'Frijol nuevo de cosecha, parejito.'),

      // --- Abarrotería San Judas (vendor_004) ---
      p('vendor_004', 'Maíz blanco', ProductCategory.grains, 4.00, 'lb'),
      p('vendor_004', 'Café tostado de Huehue', ProductCategory.other,
          48.00, 'lb',
          featured: true,
          description: 'Café de altura tostado medio, molido al momento.'),
      p('vendor_004', 'Queso fresco de Zacapa', ProductCategory.dairy,
          35.00, 'lb'),
      p('vendor_004', 'Aceite de cocina', ProductCategory.other,
          28.00, 'botella'),

      // --- Comedor Doña Tere (vendor_005) ---
      p('vendor_005', 'Almuerzo del día', ProductCategory.preparedFood,
          25.00, 'porción',
          description: 'Incluye tortillas y fresco. Menú cambia a diario.'),
      p('vendor_005', 'Desayuno chapín', ProductCategory.preparedFood,
          20.00, 'porción',
          description: 'Frijol, huevos, plátano, crema y café.'),
      p('vendor_005', 'Tostadas mixtas', ProductCategory.preparedFood,
          10.00, 'porción',
          available: false),
    ];
  }

  VendorEntity _vendorById(String id) {
    return _vendors.firstWhere(
      (v) => v.id == id,
      orElse: () =>
          throw const ValidationException('El vendedor no existe',
              statusCode: 404),
    );
  }

  @override
  Future<List<ProductSearchResultModel>> searchProducts({
    String? query,
    required SearchFilters filters,
  }) async {
    await Future<void>.delayed(_delay);

    final q = query?.trim().toLowerCase();

    // Aplicar TODOS los filtros de verdad (radio, precio, rating,
    // disponibilidad, categoría y texto).
    final results = _products
        .map((product) {
          final vendor = _vendorById(product.vendorId);
          return ProductSearchResultModel(
            product: product,
            vendor: vendor,
            distanceKm: _distancesKm[product.vendorId] ?? 99,
          );
        })
        .where((r) {
          if (r.distanceKm > filters.radiusKm) return false;
          if (filters.maxPrice != null &&
              r.product.price > filters.maxPrice!) {
            return false;
          }
          if (r.vendor.rating < filters.minRating) return false;
          if (filters.onlyAvailable && !r.product.isAvailable) return false;
          if (filters.category != null &&
              r.product.category != filters.category) {
            return false;
          }
          if (q != null && q.isNotEmpty) {
            final haystack =
                '${r.product.name} ${r.vendor.name}'.toLowerCase();
            if (!haystack.contains(q)) return false;
          }
          return true;
        })
        .toList();

    // Ordenamiento real según el filtro elegido.
    switch (filters.sortBy) {
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

    return results;
  }

  @override
  Future<ProductSearchResultModel> getProductDetail(String productId) async {
    await Future<void>.delayed(_delay);
    final i = _products.indexWhere((p) => p.id == productId);
    if (i < 0) {
      throw const ValidationException('El producto no existe',
          statusCode: 404);
    }
    // Registrar la vista en memoria (analytics del vendedor en el mock).
    final viewed = _products[i].copyWith(
      viewCount: _products[i].viewCount + 1,
    );
    _products[i] = viewed;

    return ProductSearchResultModel(
      product: viewed,
      vendor: _vendorById(viewed.vendorId),
      distanceKm: _distancesKm[viewed.vendorId] ?? 99,
    );
  }

  @override
  Future<VendorDetailModel> getVendorDetail(String vendorId) async {
    await Future<void>.delayed(_delay);
    final vendor = _vendorById(vendorId);
    return VendorDetailModel(
      vendor: vendor,
      products: _products.where((p) => p.vendorId == vendorId).toList(),
      distanceKm: _distancesKm[vendorId],
    );
  }

  @override
  Future<void> reportPrice({
    required String productName,
    required double price,
    required String unit,
    required String zone,
  }) async {
    await Future<void>.delayed(_delay);
    if (productName.trim().isEmpty) {
      throw const ValidationException('El nombre del producto es requerido');
    }
    if (price <= 0) {
      throw const ValidationException('El precio debe ser mayor a 0');
    }
    // En el mock solo acumulamos el reporte (alimentaría el índice real).
    _priceReports.add({
      'productName': productName.trim(),
      'price': price,
      'unit': unit,
      'zone': zone,
      'reportedAt': DateTime.now(),
    });
  }
}
