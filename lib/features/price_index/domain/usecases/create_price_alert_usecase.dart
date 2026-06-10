import '../../../../core/errors/failure.dart';
import '../../../../shared/domain/entities/price_entities.dart';
import '../repositories/price_repository.dart';

/// Crea una alerta de precio (función premium del comprador).
class CreatePriceAlertUsecase {
  const CreatePriceAlertUsecase(this._repository);

  final PriceRepository _repository;

  Future<(Failure?, PriceAlert?)> call({
    required String productName,
    required double targetPrice,
  }) {
    return _repository.createAlert(
      productName: productName,
      targetPrice: targetPrice,
    );
  }
}
