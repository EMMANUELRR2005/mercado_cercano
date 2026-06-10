import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../data/models/map_bounds_model.dart';
import '../../domain/entities/map_filters_entity.dart';
import '../../domain/entities/vendor_location_entity.dart';
import '../../domain/usecases/get_user_location_usecase.dart';
import '../../domain/usecases/get_vendors_nearby_usecase.dart';
import '../../domain/usecases/watch_vendors_realtime_usecase.dart';

part 'map_event.dart';
part 'map_state.dart';

/// Debounce simple sin paquetes extra: solo procesa el último evento
/// recibido dentro de la ventana [duration].
EventTransformer<T> _debounce<T>(Duration duration) {
  return (events, mapper) {
    Timer? timer;
    final controller = StreamController<T>(sync: true);
    final subscription = events.listen(
      (event) {
        timer?.cancel();
        timer = Timer(duration, () {
          if (!controller.isClosed) controller.add(event);
        });
      },
      onError: controller.addError,
      onDone: controller.close,
    );
    controller.onCancel = () {
      timer?.cancel();
      subscription.cancel();
    };
    return controller.stream.asyncExpand(mapper);
  };
}

/// BLoC del mapa: ubicación del comprador, vendedores cercanos, filtros
/// y actualizaciones en tiempo real vía WebSocket.
class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({
    required this._getVendorsNearby,
    required this._watchVendorsRealtime,
    required this._getUserLocation,
  }) : super(MapState.initial()) {
    on<MapStarted>(_onMapStarted);
    on<MapMoved>(
      _onMapMoved,
      transformer: _debounce(const Duration(milliseconds: 500)),
    );
    on<RadiusChanged>(_onRadiusChanged);
    on<CategoryFilterChanged>(_onCategoryFilterChanged);
    on<VerifiedFilterChanged>(_onVerifiedFilterChanged);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<VendorSelected>(_onVendorSelected);
    on<VendorDeselected>(_onVendorDeselected);
    on<RealtimeEventReceived>(_onRealtimeEventReceived);
  }

  final GetVendorsNearbyUsecase _getVendorsNearby;
  final WatchVendorsRealtimeUsecase _watchVendorsRealtime;
  final GetUserLocationUsecase _getUserLocation;

  StreamSubscription<VendorRealtimeEvent>? _realtimeSub;

  // -----------------------------------------------------------------
  // Handlers
  // -----------------------------------------------------------------

  Future<void> _onMapStarted(MapStarted event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapStatus.loading, errorMessage: null));

    // PRIVACIDAD: la ubicación del comprador nunca se persiste — solo en
    // memoria (vive en este estado mientras la pantalla está abierta).
    final location = await _getUserLocation();
    emit(
      state.copyWith(
        userLocation: location.position,
        mapCenter: location.position,
        locationDenied: location.denied,
      ),
    );

    await _loadVendors(emit, center: location.position);

    // Suscripción al canal en tiempo real; se cancela en [close].
    await _realtimeSub?.cancel();
    _realtimeSub = _watchVendorsRealtime().listen(
      (e) => add(RealtimeEventReceived(e)),
      // El realtime es best-effort: si el socket falla, el mapa sigue
      // funcionando con las cargas por radio.
      onError: (_) {},
    );
  }

  Future<void> _onMapMoved(MapMoved event, Emitter<MapState> emit) async {
    emit(state.copyWith(mapCenter: event.center));
    // Lazy load: recarga alrededor del nuevo centro de la cámara.
    await _loadVendors(emit, center: event.center);
  }

  Future<void> _onRadiusChanged(
    RadiusChanged event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(filters: state.filters.copyWith(radiusKm: event.radiusKm)),
    );
    await _loadVendors(emit, center: state.mapCenter);
  }

  Future<void> _onCategoryFilterChanged(
    CategoryFilterChanged event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(filters: state.filters.copyWith(category: event.category)),
    );
    await _loadVendors(emit, center: state.mapCenter);
  }

  Future<void> _onVerifiedFilterChanged(
    VerifiedFilterChanged event,
    Emitter<MapState> emit,
  ) async {
    emit(
      state.copyWith(
        filters: state.filters.copyWith(onlyVerified: event.onlyVerified),
      ),
    );
    await _loadVendors(emit, center: state.mapCenter);
  }

  void _onSearchQueryChanged(SearchQueryChanged event, Emitter<MapState> emit) {
    // Filtro local: no requiere recargar del backend.
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onVendorSelected(VendorSelected event, Emitter<MapState> emit) {
    final selected = state.vendors
        .where((v) => v.vendor.id == event.vendorId)
        .firstOrNull;
    emit(state.copyWith(selectedVendor: selected));
  }

  void _onVendorDeselected(VendorDeselected event, Emitter<MapState> emit) {
    emit(state.copyWith(selectedVendor: null));
  }

  void _onRealtimeEventReceived(
    RealtimeEventReceived event,
    Emitter<MapState> emit,
  ) {
    switch (event.event) {
      case VendorLocationUpdated(:final vendor):
        _applyVendorUpdate(vendor, emit);
      case VendorWentOffline(:final vendorId):
        // El vendedor cerró su puesto: se mantiene en el mapa atenuado.
        final updated = [
          for (final v in state.vendors)
            if (v.vendor.id == vendorId) v.copyWith(isOnline: false) else v,
        ];
        emit(state.copyWith(vendors: updated));
    }
  }

  /// Aplica una actualización en vivo: recalcula distancia, respeta los
  /// filtros activos y actualiza (o agrega) el vendedor en la lista.
  void _applyVendorUpdate(
    VendorLocationEntity vendor,
    Emitter<MapState> emit,
  ) {
    final filters = state.filters;
    if (filters.category != null && vendor.vendor.category != filters.category) {
      return;
    }
    if (filters.onlyVerified && !vendor.vendor.isVerified) return;

    // Distancia desde la ubicación del comprador (solo memoria).
    final distance = Geolocator.distanceBetween(
      state.userLocation.latitude,
      state.userLocation.longitude,
      vendor.latitude,
      vendor.longitude,
    );
    final updated = vendor.copyWith(distanceMeters: distance);

    final list = [...state.vendors];
    final index = list.indexWhere((v) => v.vendor.id == updated.vendor.id);
    if (index >= 0) {
      list[index] = updated;
    } else if (distance <= filters.radiusKm * 1000) {
      // Vendedor nuevo que entró al radio activo.
      list.add(updated);
    } else {
      return;
    }

    // Si el vendedor actualizado está seleccionado, refrescar el sheet.
    final selected = state.selectedVendor?.vendor.id == updated.vendor.id
        ? updated
        : state.selectedVendor;

    emit(state.copyWith(vendors: list, selectedVendor: selected));
  }

  // -----------------------------------------------------------------
  // Carga de vendedores con mapeo de errores a Failure
  // -----------------------------------------------------------------

  Future<void> _loadVendors(
    Emitter<MapState> emit, {
    required LatLng center,
  }) async {
    try {
      final vendors = await _getVendorsNearby(
        center: center,
        filters: state.filters,
      );
      emit(
        state.copyWith(
          status: MapStatus.ready,
          vendors: vendors,
          errorMessage: null,
        ),
      );
    } on DioException catch (e) {
      _emitFailure(emit, mapDioException(e));
    } on AppException catch (e) {
      _emitFailure(emit, mapAppException(e));
    } catch (_) {
      _emitFailure(emit, const ServerFailure());
    }
  }

  void _emitFailure(Emitter<MapState> emit, Failure failure) {
    // Si ya hay vendedores en pantalla, no tumbamos el mapa: estado
    // ready + mensaje para snackbar. Sin datos previos: error completo.
    emit(
      state.copyWith(
        status: state.vendors.isEmpty ? MapStatus.error : MapStatus.ready,
        errorMessage: failure.message,
      ),
    );
  }

  @override
  Future<void> close() async {
    // Cancela la suscripción al WebSocket al cerrar el bloc.
    await _realtimeSub?.cancel();
    return super.close();
  }
}
