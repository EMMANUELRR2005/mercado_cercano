import '../entities/vendor_stats_entity.dart';
import '../repositories/vendor_repository.dart';

/// Obtiene las métricas agregadas del negocio del vendedor.
class GetVendorStatsUsecase {
  const GetVendorStatsUsecase(this._repository);

  final VendorRepository _repository;

  Future<VendorStatsEntity> call() {
    return _repository.getVendorStats();
  }
}
