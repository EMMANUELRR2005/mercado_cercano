part of 'reputation_bloc.dart';

/// Estados del flujo de reputación.
sealed class ReputationState {
  const ReputationState();
}

/// Estado inicial, sin datos.
class ReputationInitial extends ReputationState {
  const ReputationInitial();
}

/// Cargando calificaciones de un vendedor.
class ReputationLoading extends ReputationState {
  const ReputationLoading();
}

/// Calificaciones cargadas con su promedio calculado.
class VendorRatingsLoaded extends ReputationState {
  const VendorRatingsLoaded({required this.ratings, required this.average});

  final List<RatingEntity> ratings;

  /// Promedio de estrellas (0 si no hay reseñas).
  final double average;
}

/// Enviando una calificación o reporte.
class ReputationSubmitting extends ReputationState {
  const ReputationSubmitting();
}

/// La calificación se envió con éxito.
class RatingSubmitSuccess extends ReputationState {
  const RatingSubmitSuccess(this.rating);

  final RatingEntity rating;
}

/// El reporte de fraude se envió con éxito.
class FraudReportSuccess extends ReputationState {
  const FraudReportSuccess(this.report);

  final ReportEntity report;
}

/// Error con mensaje listo para mostrar en UI (en español).
class ReputationError extends ReputationState {
  const ReputationError(this.message);

  final String message;
}
