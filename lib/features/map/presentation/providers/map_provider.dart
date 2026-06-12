import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/core_providers.dart';
import '../../data/datasources/map_firestore_datasource.dart';
import '../../data/datasources/map_remote_datasource.dart';
import '../../data/datasources/map_websocket_datasource.dart';
import '../../data/datasources/place_search_service.dart';
import '../../data/datasources/user_location_service.dart';
import '../../data/repositories/map_repository_impl.dart';
import '../../domain/repositories/map_repository.dart';
import '../../domain/usecases/get_user_location_usecase.dart';
import '../../domain/usecases/get_vendors_nearby_usecase.dart';
import '../../domain/usecases/watch_vendors_realtime_usecase.dart';
import '../bloc/map_bloc.dart';

/// DI manual con Riverpod 3 (`Provider<T>`, sin codegen) para el mapa.

/// Firestore cumple ambos contratos (carga + tiempo real con snapshots);
/// una sola instancia compartida entre los dos providers.
final _mapFirestoreDatasourceProvider =
    Provider<MapFirestoreDatasource>((ref) {
  final datasource =
      MapFirestoreDatasource(ref.watch(firestoreServiceProvider));
  ref.onDispose(datasource.dispose);
  return datasource;
});

/// Datasource REST: Firestore (producción) o API real.
final mapRemoteDatasourceProvider = Provider<MapRemoteDatasource>((ref) {
  if (AppConstants.useFirestore) {
    return ref.watch(_mapFirestoreDatasourceProvider);
  }
  return MapRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

/// Datasource de tiempo real: Firestore (snapshots) o WebSocket.
final mapWebsocketDatasourceProvider = Provider<MapWebsocketDatasource>((ref) {
  if (AppConstants.useFirestore) {
    return ref.watch(_mapFirestoreDatasourceProvider);
  }
  final datasource = MapWebsocketDatasourceImpl();
  ref.onDispose(datasource.dispose);
  return datasource;
});

/// Servicio de ubicación del comprador.
///
/// PRIVACIDAD: la ubicación del comprador nunca se persiste — solo en
/// memoria.
final userLocationServiceProvider = Provider<UserLocationService>((ref) {
  return UserLocationServiceImpl();
});

/// Búsqueda de direcciones/lugares (geocoder nativo, sin API key).
final placeSearchServiceProvider = Provider<PlaceSearchService>((ref) {
  return PlaceSearchService();
});

/// Repositorio del mapa.
final mapRepositoryProvider = Provider<MapRepository>((ref) {
  return MapRepositoryImpl(
    remote: ref.watch(mapRemoteDatasourceProvider),
    websocket: ref.watch(mapWebsocketDatasourceProvider),
  );
});

/// Caso de uso: vendedores cercanos con filtros.
final getVendorsNearbyUsecaseProvider = Provider<GetVendorsNearbyUsecase>(
  (ref) => GetVendorsNearbyUsecase(ref.watch(mapRepositoryProvider)),
);

/// Caso de uso: eventos en tiempo real del mapa.
final watchVendorsRealtimeUsecaseProvider =
    Provider<WatchVendorsRealtimeUsecase>(
  (ref) => WatchVendorsRealtimeUsecase(ref.watch(mapRepositoryProvider)),
);

/// Caso de uso: ubicación actual del comprador (solo memoria).
final getUserLocationUsecaseProvider = Provider<GetUserLocationUsecase>(
  (ref) => GetUserLocationUsecase(ref.watch(userLocationServiceProvider)),
);

/// Fábrica del BLoC del mapa.
///
/// `autoDispose`: el bloc se cierra (y cancela el WebSocket) cuando la
/// pantalla deja de escucharlo. Dispara [MapStarted] al crearse.
final mapBlocProvider = Provider.autoDispose<MapBloc>((ref) {
  final bloc = MapBloc(
    getVendorsNearby: ref.watch(getVendorsNearbyUsecaseProvider),
    watchVendorsRealtime: ref.watch(watchVendorsRealtimeUsecaseProvider),
    getUserLocation: ref.watch(getUserLocationUsecaseProvider),
  )..add(const MapStarted());
  ref.onDispose(bloc.close);
  return bloc;
});
