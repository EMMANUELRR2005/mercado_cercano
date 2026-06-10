import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/vendor_entity.dart';

part 'vendor_location_entity.freezed.dart';

/// Posición de un vendedor en el mapa, con su mejor precio del día.
///
/// `distanceMeters` se calcula respecto a la ubicación del comprador
/// (que NUNCA se persiste — ver `UserLocationService`).
@freezed
abstract class VendorLocationEntity with _$VendorLocationEntity {
  const factory VendorLocationEntity({
    required VendorEntity vendor,
    required double latitude,
    required double longitude,
    required bool isOnline,
    double? lowestPriceToday,
    String? lowestPriceProductName,
    double? distanceMeters,
  }) = _VendorLocationEntity;
}

/// Evento en tiempo real del mapa (canal WebSocket).
///
/// Los vendedores ambulantes se mueven y entran/salen de línea, por eso
/// el mapa se actualiza en vivo con estos eventos.
sealed class VendorRealtimeEvent {
  const VendorRealtimeEvent();
}

/// Un vendedor se movió o actualizó sus datos (incluye volver a estar online).
final class VendorLocationUpdated extends VendorRealtimeEvent {
  const VendorLocationUpdated(this.vendor);

  final VendorLocationEntity vendor;
}

/// Un vendedor dejó de estar disponible (cerró su puesto o perdió señal).
final class VendorWentOffline extends VendorRealtimeEvent {
  const VendorWentOffline(this.vendorId);

  final String vendorId;
}
