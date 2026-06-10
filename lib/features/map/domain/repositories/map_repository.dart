import '../entities/vendor_location_entity.dart';

/// Repositorio del mapa de vendedores cercanos.
///
/// Convención de errores: los métodos LANZAN (`DioException` /
/// `AppException`); el BLoC los atrapa y mapea a `Failure`.
abstract class MapRepository {
  /// Vendedores activos alrededor de una coordenada, dentro de `radiusKm`.
  Future<List<VendorLocationEntity>> getVendorsNearby({
    required double lat,
    required double lng,
    required double radiusKm,
  });

  /// Eventos en tiempo real (movimientos y cambios online/offline).
  Stream<VendorRealtimeEvent> watchVendorsRealtime();
}
