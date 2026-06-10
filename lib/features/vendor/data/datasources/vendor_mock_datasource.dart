import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/product_draft.dart';
import '../mock/mock_vendor_data.dart';
import '../models/product_model.dart';
import '../models/vendor_stats_model.dart';
import 'vendor_remote_datasource.dart';

/// Datasource simulado del vendedor: permite usar todo el panel SIN
/// backend (`AppConstants.useMockData == true`).
///
/// Mantiene la lista de productos EN MEMORIA y aplica de verdad las
/// mutaciones (crear, editar, agotar, renovar) para que la demo sea
/// interactiva. Cada llamada simula latencia de red de 500 ms.
class VendorMockDatasource implements VendorRemoteDatasource {
  VendorMockDatasource() : _products = MockVendorData.seedProducts();

  static const Duration _networkDelay = Duration(milliseconds: 500);

  /// Estado vivo del catálogo del vendedor demo.
  final List<ProductModel> _products;

  /// Contador para generar ids únicos de productos nuevos.
  int _createdCount = 0;

  @override
  Future<List<ProductModel>> getMyProducts() async {
    await Future<void>.delayed(_networkDelay);
    // Copia defensiva para que la UI no mute el estado interno.
    return List<ProductModel>.unmodifiable(_products);
  }

  @override
  Future<ProductModel> createProduct(ProductDraft draft) async {
    await Future<void>.delayed(_networkDelay);

    final now = DateTime.now();
    _createdCount++;
    final product = ProductModel(
      id: 'mock_prod_new_$_createdCount',
      vendorId: MockVendorData.vendorId,
      name: draft.name.trim(),
      category: draft.category.name,
      price: draft.price,
      photoUrl: draft.photoUrl,
      isAvailable: true,
      // Todo producto nuevo vence a las 24 h (precios frescos).
      expiresAt: now.add(const Duration(hours: AppConstants.productExpiryHours)),
      createdAt: now,
      viewCount: 0,
      clickCount: 0,
      isFeatured: false,
      description: draft.description,
      unit: draft.unit,
    );

    // Lo insertamos de primero para que se vea de inmediato en la lista.
    _products.insert(0, product);
    return product;
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    await Future<void>.delayed(_networkDelay);

    final index = _products.indexWhere((p) => p.id == product.id);
    if (index == -1) {
      throw const ServerException('Producto no encontrado', statusCode: 404);
    }
    _products[index] = product;
    return product;
  }

  @override
  Future<ProductModel> markSoldOut(String productId) async {
    await Future<void>.delayed(_networkDelay);

    final index = _products.indexWhere((p) => p.id == productId);
    if (index == -1) {
      throw const ServerException('Producto no encontrado', statusCode: 404);
    }
    final updated = _products[index].copyWith(isAvailable: false);
    _products[index] = updated;
    return updated;
  }

  @override
  Future<List<ProductModel>> renewAllProducts() async {
    await Future<void>.delayed(_networkDelay);

    final now = DateTime.now();
    for (var i = 0; i < _products.length; i++) {
      final product = _products[i];
      // Solo se renuevan los productos disponibles (activos).
      if (!product.isAvailable) continue;

      // Extiende +24 h; si ya venció, la renovación parte de ahora para
      // que el producto vuelva a estar visible las 24 h completas.
      final base = product.expiresAt.isAfter(now) ? product.expiresAt : now;
      _products[i] = product.copyWith(
        expiresAt: base.add(
          const Duration(hours: AppConstants.productExpiryHours),
        ),
      );
    }
    return List<ProductModel>.unmodifiable(_products);
  }

  @override
  Future<VendorStatsModel> getVendorStats() async {
    await Future<void>.delayed(_networkDelay);
    // Las métricas se derivan de la lista viva: reflejan las acciones
    // hechas durante la demo (crear, agotar, renovar).
    return MockVendorData.buildStats(_products);
  }
}
