import '../../../../core/errors/failure.dart';
import '../../../../shared/domain/entities/price_entities.dart';
import '../repositories/price_repository.dart';

/// Obtiene el índice de precios de la canasta básica en una zona.
class GetIndexByZoneUsecase {
  const GetIndexByZoneUsecase(this._repository);

  final PriceRepository _repository;

  Future<(Failure?, List<PriceIndex>?)> call({String? zone}) {
    return _repository.getIndexByZone(zone: zone);
  }
}
