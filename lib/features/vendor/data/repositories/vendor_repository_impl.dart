import '../../../../shared/domain/entities/product_entity.dart';
import '../../domain/entities/product_draft.dart';
import '../../domain/entities/vendor_stats_entity.dart';
import '../../domain/repositories/vendor_repository.dart';
import '../datasources/vendor_remote_datasource.dart';
import '../models/product_model.dart';

/// Implementación del repositorio del vendedor.
///
/// Traduce modelos de datos ↔ entidades de dominio y deja que las
/// excepciones del datasource suban tal cual (el BLoC las mapea a
/// `Failure`).
class VendorRepositoryImpl implements VendorRepository {
  VendorRepositoryImpl({required this._datasource});

  final VendorRemoteDatasource _datasource;

  @override
  Future<List<ProductEntity>> getMyProducts() async {
    final models = await _datasource.getMyProducts();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ProductEntity> createProduct(ProductDraft draft) async {
    final model = await _datasource.createProduct(draft);
    return model.toEntity();
  }

  @override
  Future<ProductEntity> updateProduct(ProductEntity product) async {
    final model = await _datasource.updateProduct(
      ProductModel.fromEntity(product),
    );
    return model.toEntity();
  }

  @override
  Future<ProductEntity> markSoldOut(String productId) async {
    final model = await _datasource.markSoldOut(productId);
    return model.toEntity();
  }

  @override
  Future<List<ProductEntity>> renewAllProducts() async {
    final models = await _datasource.renewAllProducts();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<VendorStatsEntity> getVendorStats() async {
    final model = await _datasource.getVendorStats();
    return model.toEntity();
  }
}
