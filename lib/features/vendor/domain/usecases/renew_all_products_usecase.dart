import '../../../../shared/domain/entities/product_entity.dart';
import '../repositories/vendor_repository.dart';

/// Renueva todos los productos activos del vendedor: extiende su
/// `expiresAt` 24 horas para que no desaparezcan del mapa.
class RenewAllProductsUsecase {
  const RenewAllProductsUsecase(this._repository);

  final VendorRepository _repository;

  Future<List<ProductEntity>> call() {
    return _repository.renewAllProducts();
  }
}
