import '../../../../shared/domain/entities/product_entity.dart';
import '../repositories/vendor_repository.dart';

/// Marca un producto como agotado (`isAvailable = false`).
class MarkSoldOutUsecase {
  const MarkSoldOutUsecase(this._repository);

  final VendorRepository _repository;

  Future<ProductEntity> call(String productId) {
    return _repository.markSoldOut(productId);
  }
}
