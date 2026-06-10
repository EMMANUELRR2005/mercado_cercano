import '../../../../core/errors/failure.dart';
import '../entities/rating_entity.dart';
import '../repositories/reputation_repository.dart';

/// Obtiene las calificaciones de un vendedor.
class GetVendorRatingsUsecase {
  const GetVendorRatingsUsecase(this._repository);

  final ReputationRepository _repository;

  Future<(Failure?, List<RatingEntity>?)> call(String vendorId) {
    return _repository.getVendorRatings(vendorId);
  }
}
