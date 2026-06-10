import '../entities/vendor_location_entity.dart';
import '../repositories/map_repository.dart';

/// Stream de eventos en tiempo real del mapa (update / offline).
class WatchVendorsRealtimeUsecase {
  const WatchVendorsRealtimeUsecase(this._repository);

  final MapRepository _repository;

  Stream<VendorRealtimeEvent> call() => _repository.watchVendorsRealtime();
}
