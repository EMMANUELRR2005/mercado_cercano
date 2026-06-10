import '../../../../core/errors/failure.dart';
import '../entities/search_filters.dart';
import '../repositories/buyer_repository.dart';

/// Obtiene el detalle de un producto (con vendedor y distancia).
class GetProductDetailUsecase {
  const GetProductDetailUsecase(this._repository);

  final BuyerRepository _repository;

  Future<(Failure?, SearchResult?)> call(String productId) {
    return _repository.getProductDetail(productId);
  }
}
