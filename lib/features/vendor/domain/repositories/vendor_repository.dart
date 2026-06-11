import '../../../../shared/domain/entities/product_entity.dart';
import '../entities/product_draft.dart';
import '../entities/vendor_stats_entity.dart';

/// Contrato del repositorio del panel del vendedor.
///
/// Convención de errores (igual que auth): los métodos LANZAN
/// `AppException` / `DioException`; el BLoC los captura y mapea a
/// `Failure` con `mapAppException` / `mapDioException`.
abstract class VendorRepository {
  /// Productos publicados por el vendedor autenticado.
  Future<List<ProductEntity>> getMyProducts();

  /// Catálogo en TIEMPO REAL (Firestore re-emite con cada cambio;
  /// el mock re-emite tras cada mutación).
  Stream<List<ProductEntity>> watchMyProducts();

  /// Publica un producto nuevo a partir de un borrador.
  Future<ProductEntity> createProduct(ProductDraft draft);

  /// Actualiza un producto existente (precio, nombre, disponibilidad…).
  Future<ProductEntity> updateProduct(ProductEntity product);

  /// Marca un producto como agotado (`isAvailable = false`).
  Future<ProductEntity> markSoldOut(String productId);

  /// Extiende la vigencia (+24 h) de todos los productos activos.
  /// Devuelve la lista actualizada.
  Future<List<ProductEntity>> renewAllProducts();

  /// Métricas agregadas del negocio.
  Future<VendorStatsEntity> getVendorStats();
}
