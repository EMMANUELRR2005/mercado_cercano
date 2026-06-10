import '../../../../core/errors/app_exception.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../repositories/vendor_repository.dart';

/// Actualiza un producto existente (precio, nombre, disponibilidad…).
///
/// Aplica las mismas validaciones de negocio que la creación.
class UpdateProductUsecase {
  const UpdateProductUsecase(this._repository);

  final VendorRepository _repository;

  Future<ProductEntity> call(ProductEntity product) {
    if (product.name.trim().isEmpty) {
      throw const ValidationException('Ingresa el nombre del producto');
    }
    if (product.price <= 0) {
      throw const ValidationException('El precio debe ser mayor que cero');
    }
    return _repository.updateProduct(product);
  }
}
