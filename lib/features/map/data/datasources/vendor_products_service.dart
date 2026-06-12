import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firebase/firestore_service.dart';
import '../../../../shared/domain/entities/product_entity.dart';

/// Catálogo EN VIVO de un vendedor para el bottom sheet del mapa:
/// snapshots de `products` del vendedor, solo disponibles y vigentes,
/// ordenados por más recientes.
///
/// Los filtros de expiración/orden van en cliente para no exigir un
/// índice compuesto (igual que el resto de queries por `vendorId`).
class VendorProductsService {
  VendorProductsService(this._firestore);

  final FirestoreService _firestore;

  static const _products = 'products';

  /// Cuántos productos del preview cuentan como "vistos" por emisión.
  static const _visiblePreviewCount = 3;

  /// Ids ya contados como vista en ESTA sesión de la app: el scroll o
  /// re-abrir el sheet del mismo vendedor no infla las vistas.
  final Set<String> _viewedThisSession = {};

  /// Catálogo en vivo. Con [countViews] cada producto visible del
  /// preview suma 1 a su `viewCount` (una sola vez por sesión).
  Stream<List<ProductEntity>> watch(
    String vendorId, {
    bool countViews = false,
  }) {
    return _firestore
        .streamCollection(
          _products,
          queryBuilder: (q) => q.where('vendorId', isEqualTo: vendorId),
        )
        .map((docs) {
      final now = DateTime.now();
      final products = docs
          .map(_fromDoc)
          .where((p) => p.isAvailable && p.expiresAt.isAfter(now))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (countViews) {
        _registerViews(products.take(_visiblePreviewCount));
      }
      return products;
    });
  }

  /// Incrementa `viewCount` de los productos aún no contados en esta
  /// sesión. Best-effort y sin await: las vistas son analytics del
  /// vendedor y nunca deben bloquear ni romper la UI del comprador.
  void _registerViews(Iterable<ProductEntity> products) {
    for (final product in products) {
      if (!_viewedThisSession.add(product.id)) continue;
      _firestore.updateDocument(_products, product.id, {
        'viewCount': FieldValue.increment(1),
      }).catchError((_) {});
    }
  }

  ProductEntity _fromDoc(Map<String, dynamic> doc) {
    return ProductEntity(
      id: doc['id'] as String,
      vendorId: (doc['vendorId'] as String?) ?? '',
      name: (doc['name'] as String?) ?? '',
      category: _categoryFromName(doc['category'] as String?),
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

  DateTime _toDate(Object? value) =>
      value is Timestamp ? value.toDate() : DateTime.now();

  ProductCategory _categoryFromName(String? name) {
    return ProductCategory.values.firstWhere(
      (c) => c.name == name,
      orElse: () => ProductCategory.other,
    );
  }
}
