import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../data/models/map_bounds_model.dart';
import '../bloc/map_bloc.dart';
import '../providers/map_provider.dart';
import 'widgets/map_search_bar.dart';
import 'widgets/radius_slider.dart';
import 'widgets/vendor_info_bottom_sheet.dart';
import 'widgets/vendor_pin_marker.dart';

/// Mapa de vendedores cercanos (tab "Mapa" del comprador).
///
/// Muestra pines por categoría, círculo del radio activo, búsqueda y
/// filtros flotantes, y se actualiza en vivo vía WebSocket.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;

  /// Pines custom por categoría (se cargan async y se cachean).
  final Map<ProductCategory, BitmapDescriptor> _pinIcons = {};

  /// La cámara se centra automáticamente SOLO en el primer fix real;
  /// después el usuario navega libre y recentra con el FAB.
  bool _centeredOnUser = false;

  /// El diálogo de permiso denegado se muestra una sola vez por sesión.
  bool _deniedDialogShown = false;

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(
      AppConstants.guatemalaCityLat,
      AppConstants.guatemalaCityLng,
    ),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _loadPinIcons();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  /// Pre-dibuja los pines de todas las categorías.
  Future<void> _loadPinIcons() async {
    for (final category in ProductCategory.values) {
      final pin = await VendorPinMarker.buildPin(category);
      if (!mounted) return;
      setState(() => _pinIcons[category] = pin);
    }
  }

  /// Recentra la cámara en la ubicación actual del comprador.
  void _centerOnUser(MapState state) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(state.userLocation, 15),
    );
  }

  /// Diálogo cuando el permiso de ubicación fue denegado o el GPS está
  /// apagado: explica el porqué y ofrece abrir la configuración o seguir
  /// con Ciudad de Guatemala como ubicación por defecto.
  Future<void> _showLocationDeniedDialog() async {
    if (_deniedDialogShown || !mounted) return;
    _deniedDialogShown = true;
    final openSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activa tu ubicación'),
        content: const Text(
          'MercadoCercano usa tu ubicación para mostrarte los vendedores '
          'más cercanos a ti y calcular distancias reales. Tu ubicación '
          'nunca se almacena.\n\nSin permiso, el mapa usará Ciudad de '
          'Guatemala como punto de referencia.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Usar ubicación por defecto'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Abrir configuración'),
          ),
        ],
      ),
    );
    if (openSettings == true) {
      // Abre los ajustes correctos (de la app o del sistema) según el
      // motivo de la denegación.
      await ref.read(getUserLocationUsecaseProvider).openSettings();
    }
  }

  /// Lazy load al detener la cámara: el debounce vive en el bloc.
  Future<void> _onCameraIdle(MapBloc bloc) async {
    final controller = _mapController;
    if (controller == null) return;
    try {
      final bounds = MapBoundsModel.fromLatLngBounds(
        await controller.getVisibleRegion(),
      );
      bloc.add(MapMoved(center: bounds.center, bounds: bounds));
    } catch (_) {
      // El controller puede estar desechado durante la navegación.
    }
  }

  /// Markers derivados del estado del bloc + caché de pines.
  Set<Marker> _buildMarkers(BuildContext context, MapState state) {
    final bloc = context.read<MapBloc>();
    return {
      for (final vendorLocation in state.visibleVendors)
        Marker(
          markerId: MarkerId(vendorLocation.vendor.id),
          position: LatLng(
            vendorLocation.latitude,
            vendorLocation.longitude,
          ),
          icon: _pinIcons[vendorLocation.vendor.category] ??
              BitmapDescriptor.defaultMarkerWithHue(
                HSVColor.fromColor(
                  vendorLocation.vendor.category.pinColor,
                ).hue,
              ),
          // Vendedores fuera de línea se ven atenuados.
          alpha: vendorLocation.isOnline ? 1.0 : 0.45,
          infoWindow: InfoWindow(title: vendorLocation.vendor.name),
          onTap: () async {
            bloc.add(VendorSelected(vendorLocation.vendor.id));
            await VendorInfoBottomSheet.show(context, vendorLocation);
            bloc.add(const VendorDeselected());
          },
        ),
    };
  }

  /// Círculo del radio de búsqueda centrado en el comprador.
  Set<Circle> _buildRadiusCircle(MapState state) {
    return {
      Circle(
        circleId: const CircleId('search_radius'),
        center: state.userLocation,
        radius: state.filters.radiusKm * 1000,
        fillColor: AppColors.primaryGreen.withValues(alpha: 0.1),
        strokeColor: AppColors.primaryGreen.withValues(alpha: 0.35),
        strokeWidth: 1,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(mapBlocProvider);

    return BlocProvider<MapBloc>.value(
      value: bloc,
      child: BlocConsumer<MapBloc, MapState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.userLocation != current.userLocation ||
            previous.locationDenied != current.locationDenied,
        listener: (context, state) {
          // Errores de recarga (con datos previos en pantalla): snackbar.
          if (state.errorMessage != null && state.status == MapStatus.ready) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
          // Permiso denegado: explicar y ofrecer abrir configuración.
          if (state.locationDenied) {
            _showLocationDeniedDialog();
          }
          // Primer fix real: centrar la cámara en el comprador (una vez;
          // después manda el usuario y el FAB "Mi ubicación").
          if (!state.locationDenied &&
              !_centeredOnUser &&
              state.status != MapStatus.initial) {
            _centeredOnUser = true;
            _centerOnUser(state);
          }
        },
        builder: (context, state) {
          final isLoading = state.status == MapStatus.loading ||
              state.status == MapStatus.initial;

          return Scaffold(
            // FAB "Mi ubicación": recentra la cámara en el comprador si
            // se alejó navegando el mapa. Oculto sin permiso (fallback).
            floatingActionButton: state.locationDenied
                ? null
                : Padding(
                    padding: const EdgeInsets.only(bottom: 64),
                    child: FloatingActionButton.small(
                      heroTag: 'map_my_location_fab',
                      backgroundColor: AppColors.surfaceWhite,
                      foregroundColor: AppColors.primaryGreen,
                      tooltip: 'Mi ubicación',
                      onPressed: () => _centerOnUser(state),
                      child: const Icon(Icons.my_location),
                    ),
                  ),
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialCamera,
                  // Con permiso denegado se ocultan el punto azul y el
                  // botón nativo de "mi ubicación" (usamos nuestro FAB).
                  myLocationEnabled: !state.locationDenied,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  markers: _buildMarkers(context, state),
                  circles: _buildRadiusCircle(state),
                  onMapCreated: (controller) => _mapController = controller,
                  onCameraIdle: () => _onCameraIdle(bloc),
                ),

                // --- Búsqueda + filtros flotantes ---
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MapSearchBar(
                          query: state.searchQuery,
                          selectedCategory: state.filters.category,
                          onQueryChanged: (query) =>
                              bloc.add(SearchQueryChanged(query)),
                          onCategoryChanged: (category) =>
                              bloc.add(CategoryFilterChanged(category)),
                        ),
                        if (state.locationDenied) ...[
                          const SizedBox(height: 8),
                          const _LocationDeniedChip(),
                        ],
                      ],
                    ),
                  ),
                ),

                // --- Slider de radio flotante ---
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 24,
                  child: Center(
                    child: RadiusSlider(
                      radiusKm: state.filters.radiusKm,
                      onRadiusChanged: (km) => bloc.add(RadiusChanged(km)),
                    ),
                  ),
                ),

                // --- Estados de carga y error ---
                if (isLoading)
                  const LoadingOverlay(message: 'Buscando vendedores cerca…'),
                if (state.status == MapStatus.error)
                  Container(
                    color: AppColors.backgroundLight.withValues(alpha: 0.92),
                    child: ErrorStateWidget(
                      message: state.errorMessage ??
                          'No se pudo cargar el mapa. Intenta de nuevo.',
                      onRetry: () => bloc.add(const MapStarted()),
                    ),
                  ),
                if (state.status == MapStatus.ready &&
                    state.visibleVendors.isEmpty)
                  IgnorePointer(
                    child: Center(
                      child: Material(
                        color: AppColors.surfaceWhite.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(16),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: EmptyStateWidget(
                            icon: Icons.storefront_outlined,
                            title: 'Sin vendedores cerca',
                            subtitle:
                                'Amplía el radio de búsqueda o cambia los '
                                'filtros para encontrar más puestos.',
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Chip informativo cuando no hay permiso de ubicación: el mapa usa
/// Ciudad de Guatemala como centro por defecto.
class _LocationDeniedChip extends StatelessWidget {
  const _LocationDeniedChip();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceWhite,
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off_outlined,
              size: 16,
              color: AppColors.accentAmber,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Sin permiso de ubicación: mostrando Ciudad de Guatemala',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
