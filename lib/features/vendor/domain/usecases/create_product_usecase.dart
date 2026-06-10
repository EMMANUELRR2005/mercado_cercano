import '../../../../core/errors/app_exception.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../entities/product_draft.dart';
import '../repositories/vendor_repository.dart';

/// Publica un producto nuevo.
///
/// Valida reglas de negocio ANTES de tocar la red:
/// - el nombre no puede estar vacío,
/// - el precio debe ser mayor que cero.
class CreateProductUsecase {
  const CreateProductUsecase(this._repository);

  final VendorRepository _repository;

  Future<ProductEntity> call(ProductDraft draft) {
    if (draft.name.trim().isEmpty) {
      throw const ValidationException('Ingresa el nombre del producto');
    }
    if (draft.price <= 0) {
      throw const ValidationException('El precio debe ser mayor que cero');
    }
    return _repository.createProduct(draft);
  }
}
