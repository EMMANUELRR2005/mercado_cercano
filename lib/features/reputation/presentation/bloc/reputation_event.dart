part of 'reputation_bloc.dart';

/// Eventos del flujo de reputación.
sealed class ReputationEvent {
  const ReputationEvent();
}

/// Solicita las calificaciones de un vendedor.
class VendorRatingsRequested extends ReputationEvent {
  const VendorRatingsRequested(this.vendorId);

  final String vendorId;
}

/// El comprador envía su calificación.
class RatingSubmitted extends ReputationEvent {
  const RatingSubmitted({
    required this.vendorId,
    required this.stars,
    this.comment,
  });

  final String vendorId;
  final double stars;
  final String? comment;
}

/// El comprador reporta un posible fraude.
class FraudReported extends ReputationEvent {
  const FraudReported({
    required this.vendorId,
    required this.reason,
    this.description,
  });

  final String vendorId;
  final String reason;
  final String? description;
}
