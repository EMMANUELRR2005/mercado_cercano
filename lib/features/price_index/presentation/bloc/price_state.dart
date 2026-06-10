part of 'price_bloc.dart';

/// Estados del índice de precios, historial y alertas.
sealed class PriceState {
  const PriceState();
}

/// Estado inicial, sin datos.
class PriceInitial extends PriceState {
  const PriceInitial();
}

/// Cargando datos de precios.
class PriceLoading extends PriceState {
  const PriceLoading();
}

/// Índice de precios cargado.
class PriceIndexLoaded extends PriceState {
  const PriceIndexLoaded({
    required this.indices,
    required this.zone,
    required this.updatedAt,
  });

  final List<PriceIndex> indices;

  /// Zona del índice (ej. "Zona 1, Ciudad de Guatemala").
  final String zone;

  /// Momento de la última actualización.
  final DateTime updatedAt;
}

/// Historial de un producto cargado.
class PriceHistoryLoaded extends PriceState {
  const PriceHistoryLoaded(this.history);

  final PriceHistory history;
}

/// Alertas del comprador cargadas.
class PriceAlertsLoaded extends PriceState {
  const PriceAlertsLoaded(this.alerts);

  final List<PriceAlert> alerts;
}

/// Error con mensaje listo para mostrar en UI (en español).
class PriceError extends PriceState {
  const PriceError(this.message);

  final String message;
}
