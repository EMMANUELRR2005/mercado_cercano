import '../../../../shared/domain/entities/product_entity.dart';
import '../repositories/vendor_repository.dart';

/// Obtiene los productos publicados por el vendedor autenticado.
class GetMyProductsUsecase {
  const GetMyProductsUsecase(this._repository);

  final VendorRepository _repository;

  Future<List<ProductEntity>> call() {
    return _repository.getMyProducts();
  }
}
