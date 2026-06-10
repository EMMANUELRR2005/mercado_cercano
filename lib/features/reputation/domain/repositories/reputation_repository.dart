import '../../../../core/errors/failure.dart';
import '../entities/rating_entity.dart';
import '../entities/report_entity.dart';

/// Contrato del repositorio de reputación.
///
/// Convención de retorno (sin dartz en el proyecto): record
/// `(Failure?, T?)` — exactamente uno de los dos es no nulo.
abstract class ReputationRepository {
  /// Obtiene las calificaciones de un vendedor (más recientes primero).
  Future<(Failure?, List<RatingEntity>?)> getVendorRatings(String vendorId);

  /// Envía una calificación de 1 a 5 estrellas con comentario opcional.
  Future<(Failure?, RatingEntity?)> submitRating({
    required String vendorId,
    required double stars,
    String? comment,
  });

  /// Reporta un posible fraude de un vendedor.
  Future<(Failure?, ReportEntity?)> reportFraud({
    required String vendorId,
    required String reason,
    String? description,
  });
}
