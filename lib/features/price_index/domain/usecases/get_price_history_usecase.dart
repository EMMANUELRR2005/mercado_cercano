import '../../../../core/errors/failure.dart';
import '../../../../shared/domain/entities/price_entities.dart';
import '../repositories/price_repository.dart';

/// Obtiene el historial de precios de un producto.
class GetPriceHistoryUsecase {
  const GetPriceHistoryUsecase(this._repository);

  final PriceRepository _repository;

  Future<(Failure?, PriceHistory?)> call(String productName) {
    return _repository.getPriceHistory(productName);
  }
}
