import '../../../../core/errors/failure.dart';
import '../../../../shared/domain/entities/price_entities.dart';
import '../repositories/price_repository.dart';

/// Obtiene las alertas de precio del comprador autenticado.
class GetMyAlertsUsecase {
  const GetMyAlertsUsecase(this._repository);

  final PriceRepository _repository;

  Future<(Failure?, List<PriceAlert>?)> call() {
    return _repository.getMyAlerts();
  }
}
