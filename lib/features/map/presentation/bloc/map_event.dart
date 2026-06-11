part of 'map_bloc.dart';

/// Eventos del mapa de vendedores cercanos.
sealed class MapEvent {
  const MapEvent();
}

/// Arranque: obtiene ubicación, carga vendedores y abre el canal realtime.
final class MapStarted extends MapEvent {
  const MapStarted();
}

/// El usuario movió la cámara (onCameraIdle): lazy load con debounce.
final class MapMoved extends MapEvent {
  const MapMoved({required this.center, this.bounds});

  final LatLng center;
  final MapBoundsModel? bounds;
}

/// Cambió el radio de búsqueda (slider 1-20 km).
final class RadiusChanged extends MapEvent {
  const RadiusChanged(this.radiusKm);

  final double radiusKm;
}

/// Cambió el filtro de categoría (null = todas).
final class CategoryFilterChanged extends MapEvent {
  const CategoryFilterChanged(this.category);

  final ProductCategory? category;
}

/// Cambió el filtro "solo verificados".
final class VerifiedFilterChanged extends MapEvent {
  const VerifiedFilterChanged(this.onlyVerified);

  final bool onlyVerified;
}

/// Cambió el texto de búsqueda (filtro local, sin recargar).
final class SearchQueryChanged extends MapEvent {
  const SearchQueryChanged(this.query);

  final String query;
}

/// El usuario tocó el pin de un vendedor.
final class VendorSelected extends MapEvent {
  const VendorSelected(this.vendorId);

  final String vendorId;
}

/// Se cerró el bottom sheet del vendedor.
final class VendorDeselected extends MapEvent {
  const VendorDeselected();
}

/// Llegó un evento del canal en tiempo real (WebSocket).
final class RealtimeEventReceived extends MapEvent {
  const RealtimeEventReceived(this.event);

  final VendorRealtimeEvent event;
}

/// La ubicación REAL del comprador cambió (stream de geolocator).
/// Solo memoria: actualiza distancias, orden y el círculo de radio.
final class UserLocationChanged extends MapEvent {
  const UserLocationChanged(this.location);

  final LatLng location;
}
