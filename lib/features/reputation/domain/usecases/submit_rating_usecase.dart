import '../../../../core/errors/failure.dart';
import '../entities/rating_entity.dart';
import '../repositories/reputation_repository.dart';

/// Envía la calificación de un comprador hacia un vendedor.
class SubmitRatingUsecase {
  const SubmitRatingUsecase(this._repository);

  final ReputationRepository _repository;

  Future<(Failure?, RatingEntity?)> call({
    required String vendorId,
    required double stars,
    String? comment,
  }) {
    // Regla de negocio: las estrellas válidas van de 1 a 5.
    if (stars < 1 || stars > 5) {
      return Future.value(
        (const ValidationFailure('Selecciona de 1 a 5 estrellas.'), null),
      );
    }
    return _repository.submitRating(
      vendorId: vendorId,
      stars: stars,
      comment: (comment != null && comment.trim().isNotEmpty)
          ? comment.trim()
          : null,
    );
  }
}
