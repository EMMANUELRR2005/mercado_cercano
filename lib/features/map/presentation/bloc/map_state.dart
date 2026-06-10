part of 'map_bloc.dart';

/// Fases del mapa.
enum MapStatus { initial, loading, ready, error }

/// Estado único e incremental del mapa.
///
/// PRIVACIDAD: `userLocation` vive solo en este estado (memoria); nunca
/// se persiste en storage ni se envía a servicios de terceros.
class MapState {
  const MapState({
    required this.status,
    required this.userLocation,
    required this.mapCenter,
    required this.locationDenied,
    required this.vendors,
    required this.filters,
    required this.searchQuery,
    this.selectedVendor,
    this.errorMessage,
  });

  /// Estado inicial: centrado en Ciudad de Guatemala.
  factory MapState.initial() => const MapState(
        status: MapStatus.initial,
        userLocation: LatLng(
          AppConstants.guatemalaCityLat,
          AppConstants.guatemalaCityLng,
        ),
        mapCenter: LatLng(
          AppConstants.guatemalaCityLat,
          AppConstants.guatemalaCityLng,
        ),
        locationDenied: false,
        vendors: [],
        filters: MapFiltersEntity(
          radiusKm: AppConstants.defaultSearchRadiusKm,
        ),
        searchQuery: '',
      );

  final MapStatus status;

  /// Ubicación del comprador (real o fallback a la capital). Solo memoria.
  final LatLng userLocation;

  /// Último centro de la cámara (para recargar al mover el mapa).
  final LatLng mapCenter;

  /// True si el permiso de ubicación fue denegado o el GPS está apagado.
  final bool locationDenied;

  final List<VendorLocationEntity> vendors;
  final MapFiltersEntity filters;

  /// Filtro de texto local (nombre del vendedor o producto destacado).
  final String searchQuery;

  final VendorLocationEntity? selectedVendor;

  /// Mensaje de error user-friendly (de un [Failure]); null si no hay.
  final String? errorMessage;

  /// Vendedores visibles tras aplicar el filtro de texto local.
  List<VendorLocationEntity> get visibleVendors {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return vendors;
    return vendors.where((v) {
      final name = v.vendor.name.toLowerCase();
      final product = v.lowestPriceProductName?.toLowerCase() ?? '';
      return name.contains(query) || product.contains(query);
    }).toList();
  }

  static const Object _unset = Object();

  MapState copyWith({
    MapStatus? status,
    LatLng? userLocation,
    LatLng? mapCenter,
    bool? locationDenied,
    List<VendorLocationEntity>? vendors,
    MapFiltersEntity? filters,
    String? searchQuery,
    Object? selectedVendor = _unset,
    Object? errorMessage = _unset,
  }) {
    return MapState(
      status: status ?? this.status,
      userLocation: userLocation ?? this.userLocation,
      mapCenter: mapCenter ?? this.mapCenter,
      locationDenied: locationDenied ?? this.locationDenied,
      vendors: vendors ?? this.vendors,
      filters: filters ?? this.filters,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedVendor: identical(selectedVendor, _unset)
          ? this.selectedVendor
          : selectedVendor as VendorLocationEntity?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
