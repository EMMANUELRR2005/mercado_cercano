import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/firebase/firebase_storage_service.dart';
import '../../../../core/firebase/firestore_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/product_draft.dart';
import '../models/product_model.dart';
import '../models/vendor_stats_model.dart';
import 'vendor_remote_datasource.dart';

/// Implementación REAL del panel del vendedor contra Cloud Firestore
/// (`AppConstants.useFirestore`).
///
/// Convenciones del esquema (reglas de seguridad ya desplegadas):
/// - `vendors/{uid}`: el id del documento ES el uid del usuario dueño.
/// - `products.vendorId` referencia ese uid.
class VendorFirestoreDatasource implements VendorRemoteDatasource {
  VendorFirestoreDatasource(
    this._firestore,
    this._secureStorage,
    this._storage,
  );

  final FirestoreService _firestore;
  final SecureStorageService _secureStorage;
  final FirebaseStorageService _storage;

  static const _products = 'products';
  static const _vendors = 'vendors';

  /// Guarda la foto si [photoUrl] es una ruta local del picker: sube a
  /// Storage o, sin bucket (plan Spark), la embebe en Firestore como
  /// data URI base64.
  ///
  /// Degradación: si ni eso es posible, la publicación NO se bloquea —
  /// el producto se guarda sin foto.
  Future<String> _resolvePhotoUrl(String photoUrl, String uid) async {
    if (photoUrl.isEmpty ||
        photoUrl.startsWith('http') ||
        photoUrl.startsWith('data:')) {
      return photoUrl;
    }
    try {
      return await _storage.uploadProductPhoto(File(photoUrl), uid);
    } on AppException {
      return '';
    }
  }

  Future<String> _uid() async {
    final id = await _secureStorage.getUserId();
    if (id == null || id.isEmpty) {
      throw const AuthException('La sesión expiró. Inicia sesión de nuevo.');
    }
    return id;
  }

  // -------------------------------------------------------------------
  // Catálogo
  // -------------------------------------------------------------------

  @override
  Future<List<ProductModel>> getMyProducts() async {
    final uid = await _uid();
    final docs = await _firestore.getCollection(
      _products,
      queryBuilder: (q) => q.where('vendorId', isEqualTo: uid),
    );
    return _sorted(docs.map(_fromDoc).toList());
  }

  @override
  Stream<List<ProductModel>> watchMyProducts() async* {
    final uid = await _uid();
    // El snapshot de Firestore ES el tiempo real: cada cambio en el
    // catálogo (propio u otro dispositivo) re-emite la lista.
    yield* _firestore
        .streamCollection(
          _products,
          queryBuilder: (q) => q.where('vendorId', isEqualTo: uid),
        )
        .map((docs) => _sorted(docs.map(_fromDoc).toList()));
  }

  @override
  Future<ProductModel> createProduct(ProductDraft draft) async {
    final uid = await _uid();

    // Asegurar el perfil público del vendedor (lo usa el mapa). Solo se
    // crea la primera vez que publica.
    final vendorDoc = await _firestore.getDocument(_vendors, uid);
    if (vendorDoc == null) {
      await _firestore.setDocument(
        _vendors,
        {
          'userId': uid,
          'businessName': 'Mi negocio',
          'zone': '',
          'neighborhood': '',
          'rating': 0,
          'totalRatings': 0,
          'isVerified': false,
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
        },
        id: uid,
      );
    }

    // Foto: si viene del picker (ruta local) se sube a Storage primero.
    final photoUrl = await _resolvePhotoUrl(draft.photoUrl, uid);

    final now = DateTime.now();
    final expiresAt =
        now.add(const Duration(hours: AppConstants.productExpiryHours));
    final id = await _firestore.setDocument(_products, {
      'vendorId': uid,
      'name': draft.name,
      'category': draft.category.name,
      'price': draft.price,
      'photoUrl': photoUrl,
      'isAvailable': true,
      'isFeatured': false,
      'expiresAt': Timestamp.fromDate(expiresAt),
      'createdAt': FieldValue.serverTimestamp(),
      'viewCount': 0,
      'clickCount': 0,
      'unit': ?draft.unit,
      'description': ?draft.description,
    });

    return ProductModel(
      id: id,
      vendorId: uid,
      name: draft.name,
      category: draft.category.name,
      price: draft.price,
      photoUrl: photoUrl,
      isAvailable: true,
      isFeatured: false,
      expiresAt: expiresAt,
      createdAt: now,
      viewCount: 0,
      clickCount: 0,
      unit: draft.unit,
      description: draft.description,
    );
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    // Si la edición trae una foto nueva del picker, subirla primero.
    final photoUrl =
        await _resolvePhotoUrl(product.photoUrl, product.vendorId);
    await _firestore.updateDocument(_products, product.id, {
      'name': product.name,
      'category': product.category,
      'price': product.price,
      'photoUrl': photoUrl,
      'isAvailable': product.isAvailable,
      'unit': product.unit,
      'description': product.description,
    });
    return product.copyWith(photoUrl: photoUrl);
  }

  @override
  Future<ProductModel> markSoldOut(String productId) async {
    await _firestore.updateDocument(_products, productId, {
      'isAvailable': false,
    });
    final doc = await _firestore.getDocument(_products, productId);
    if (doc == null) {
      throw const ServerException('El producto ya no existe.');
    }
    return _fromDoc(doc);
  }

  @override
  Future<List<ProductModel>> renewAllProducts() async {
    final current = await getMyProducts();
    final newExpiry = DateTime.now()
        .add(const Duration(hours: AppConstants.productExpiryHours));

    // Batch: una sola escritura atómica para todo el catálogo activo.
    final batch = _firestore.db.batch();
    for (final product in current.where((p) => p.isAvailable)) {
      batch.update(
        _firestore.collection(_products).doc(product.id),
        {'expiresAt': Timestamp.fromDate(newExpiry)},
      );
    }
    try {
      await batch.commit();
    } on FirebaseException {
      throw const ServerException(
        'No se pudieron renovar los productos. Intenta de nuevo.',
      );
    }
    // La relectura refleja el batch recién aplicado.
    return getMyProducts();
  }

  // -------------------------------------------------------------------
  // Estadísticas
  // -------------------------------------------------------------------

  @override
  Future<VendorStatsModel> getVendorStats() async {
    final uid = await _uid();
    final products = await getMyProducts();
    final vendorDoc = await _firestore.getDocument(_vendors, uid);

    final now = DateTime.now();
    final active = products
        .where((p) => p.isAvailable && p.expiresAt.isAfter(now))
        .length;
    final soldOut = products.where((p) => !p.isAvailable).length;
    final totalViews =
        products.fold<int>(0, (total, p) => total + p.viewCount);
    final totalClicks =
        products.fold<int>(0, (total, p) => total + p.clickCount);

    final top = [...products]
      ..sort((a, b) => b.viewCount.compareTo(a.viewCount));

    // Nota: el esquema actual no guarda series históricas de vistas;
    // se sintetiza una distribución determinista de 7 días a partir del
    // total para que la gráfica tenga sentido hasta que exista la
    // subcolección de analytics.
    const weights = [0.10, 0.12, 0.15, 0.13, 0.16, 0.18, 0.16];
    final viewsByDay = List.generate(7, (i) {
      return DailyViewsModel(
        date: DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: 6 - i)),
        views: (totalViews * weights[i]).round(),
      );
    });

    return VendorStatsModel(
      totalViews: totalViews,
      totalClicks: totalClicks,
      activeProducts: active,
      soldOutProducts: soldOut,
      viewsByDay: viewsByDay,
      topProducts: top.take(3).toList(),
      averageRating:
          ((vendorDoc?['rating'] as num?) ?? 0).toDouble(),
    );
  }

  // -------------------------------------------------------------------
  // Mapeo Firestore → ProductModel
  // -------------------------------------------------------------------

  List<ProductModel> _sorted(List<ProductModel> products) {
    products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return products;
  }

  ProductModel _fromDoc(Map<String, dynamic> doc) {
    return ProductModel(
      id: doc['id'] as String,
      vendorId: (doc['vendorId'] as String?) ?? '',
      name: (doc['name'] as String?) ?? '',
      category: (doc['category'] as String?) ?? 'other',
      price: ((doc['price'] as num?) ?? 0).toDouble(),
      photoUrl: (doc['photoUrl'] as String?) ?? '',
      isAvailable: (doc['isAvailable'] as bool?) ?? false,
      expiresAt: _toDate(doc['expiresAt']),
      createdAt: _toDate(doc['createdAt']),
      viewCount: ((doc['viewCount'] as num?) ?? 0).toInt(),
      clickCount: ((doc['clickCount'] as num?) ?? 0).toInt(),
      isFeatured: doc['isFeatured'] as bool?,
      description: doc['description'] as String?,
      unit: doc['unit'] as String?,
    );
  }

  DateTime _toDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
