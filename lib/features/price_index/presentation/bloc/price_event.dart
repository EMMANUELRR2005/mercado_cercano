part of 'price_bloc.dart';

/// Eventos del índice de precios, historial y alertas.
sealed class PriceEvent {
  const PriceEvent();
}

/// Solicita el índice de precios de la zona.
class PriceIndexRequested extends PriceEvent {
  const PriceIndexRequested({this.zone});

  final String? zone;
}

/// Solicita el historial de precios de un producto.
class PriceHistoryRequested extends PriceEvent {
  const PriceHistoryRequested(this.productName);

  final String productName;
}

/// Solicita las alertas del comprador.
class PriceAlertsRequested extends PriceEvent {
  const PriceAlertsRequested();
}

/// El comprador crea una alerta de precio.
class PriceAlertCreated extends PriceEvent {
  const PriceAlertCreated({
    required this.productName,
    required this.targetPrice,
  });

  final String productName;
  final double targetPrice;
}

/// El comprador activa/desactiva una alerta.
class PriceAlertToggled extends PriceEvent {
  const PriceAlertToggled(this.alertId);

  final String alertId;
}

/// El comprador elimina una alerta (swipe).
class PriceAlertDeleted extends PriceEvent {
  const PriceAlertDeleted(this.alertId);

  final String alertId;
}
