import '../../../../core/errors/failure.dart';
import '../../../../shared/domain/entities/price_entities.dart';

/// Contrato del repositorio del índice de precios.
///
/// Convención de retorno (sin dartz en el proyecto): record
/// `(Failure?, T?)` — exactamente uno de los dos es no nulo.
abstract class PriceRepository {
  /// Índice de precios de la canasta básica en una zona.
  Future<(Failure?, List<PriceIndex>?)> getIndexByZone({String? zone});

  /// Historial de precios de un producto (serie diaria).
  Future<(Failure?, PriceHistory?)> getPriceHistory(String productName);

  /// Crea una alerta de precio para el comprador.
  Future<(Failure?, PriceAlert?)> createAlert({
    required String productName,
    required double targetPrice,
  });

  /// Alertas del comprador autenticado.
  Future<(Failure?, List<PriceAlert>?)> getMyAlerts();

  /// Activa/desactiva una alerta y devuelve la versión actualizada.
  Future<(Failure?, PriceAlert?)> toggleAlert(String alertId);

  /// Elimina una alerta. Devuelve `true` si se eliminó.
  Future<(Failure?, bool?)> deleteAlert(String alertId);
}
