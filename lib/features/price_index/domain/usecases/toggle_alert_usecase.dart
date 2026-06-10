import '../../../../core/errors/failure.dart';
import '../../../../shared/domain/entities/price_entities.dart';
import '../repositories/price_repository.dart';

/// Activa o desactiva una alerta de precio existente.
class ToggleAlertUsecase {
  const ToggleAlertUsecase(this._repository);

  final PriceRepository _repository;

  Future<(Failure?, PriceAlert?)> call(String alertId) {
    return _repository.toggleAlert(alertId);
  }
}

/// Elimina una alerta de precio (swipe para borrar en la UI).
class DeleteAlertUsecase {
  const DeleteAlertUsecase(this._repository);

  final PriceRepository _repository;

  Future<(Failure?, bool?)> call(String alertId) {
    return _repository.deleteAlert(alertId);
  }
}
