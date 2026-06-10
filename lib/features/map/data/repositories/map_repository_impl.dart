import '../../domain/entities/vendor_location_entity.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/map_remote_datasource.dart';
import '../datasources/map_websocket_datasource.dart';

/// Implementación del repositorio del mapa.
///
/// Mapea modelos → entidades y deja PASAR las excepciones de la capa de
/// datos (convención: el BLoC hace try/catch y las convierte en Failure).
class MapRepositoryImpl implements MapRepository {
  MapRepositoryImpl({
    required this._remote,
    required this._websocket,
  });

  final MapRemoteDatasource _remote;
  final MapWebsocketDatasource _websocket;

  @override
  Future<List<VendorLocationEntity>> getVendorsNearby({
    required double lat,
    required double lng,
    required double radiusKm,
  }) async {
    final models = await _remote.getVendorsNearby(
      lat: lat,
      lng: lng,
      radiusKm: radiusKm,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<VendorRealtimeEvent> watchVendorsRealtime() {
    return _websocket.watchVendors();
  }
}
