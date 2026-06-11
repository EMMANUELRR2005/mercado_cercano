import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/core_providers.dart';
import '../../data/datasources/price_firestore_datasource.dart';
import '../../data/datasources/price_remote_datasource.dart';
import '../../data/repositories/price_repository_impl.dart';
import '../../domain/repositories/price_repository.dart';
import '../../domain/usecases/create_price_alert_usecase.dart';
import '../../domain/usecases/get_index_by_zone_usecase.dart';
import '../../domain/usecases/get_my_alerts_usecase.dart';
import '../../domain/usecases/get_price_history_usecase.dart';
import '../../domain/usecases/toggle_alert_usecase.dart';
import '../bloc/price_bloc.dart';

/// DI manual con Riverpod 3 (`Provider<T>`, sin codegen) para price_index.

/// Datasource remoto: mock o real según `AppConstants.useMockData`.
///
/// El mock vive aquí (provider sin autoDispose) para que las alertas
/// en memoria persistan entre pantallas durante la sesión.
final priceRemoteDatasourceProvider = Provider<PriceRemoteDatasource>((ref) {
  if (AppConstants.useFirestore) {
    return PriceFirestoreDatasource(
      ref.watch(firestoreServiceProvider),
      ref.watch(secureStorageProvider),
    );
  }
  return PriceRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

/// Repositorio del índice de precios (con caché offline de 1 h).
final priceRepositoryProvider = Provider<PriceRepository>((ref) {
  return PriceRepositoryImpl(
    ref.watch(priceRemoteDatasourceProvider),
    cache: ref.watch(offlineCacheServiceProvider),
  );
});

/// Caso de uso: índice de la canasta básica por zona.
final getIndexByZoneUsecaseProvider = Provider<GetIndexByZoneUsecase>(
  (ref) => GetIndexByZoneUsecase(ref.watch(priceRepositoryProvider)),
);

/// Caso de uso: historial de precios de un producto.
final getPriceHistoryUsecaseProvider = Provider<GetPriceHistoryUsecase>(
  (ref) => GetPriceHistoryUsecase(ref.watch(priceRepositoryProvider)),
);

/// Caso de uso: crear alerta de precio.
final createPriceAlertUsecaseProvider = Provider<CreatePriceAlertUsecase>(
  (ref) => CreatePriceAlertUsecase(ref.watch(priceRepositoryProvider)),
);

/// Caso de uso: alertas del comprador.
final getMyAlertsUsecaseProvider = Provider<GetMyAlertsUsecase>(
  (ref) => GetMyAlertsUsecase(ref.watch(priceRepositoryProvider)),
);

/// Caso de uso: activar/desactivar alerta.
final toggleAlertUsecaseProvider = Provider<ToggleAlertUsecase>(
  (ref) => ToggleAlertUsecase(ref.watch(priceRepositoryProvider)),
);

/// Caso de uso: eliminar alerta.
final deleteAlertUsecaseProvider = Provider<DeleteAlertUsecase>(
  (ref) => DeleteAlertUsecase(ref.watch(priceRepositoryProvider)),
);

/// Fábrica del BLoC de precios.
///
/// Es `autoDispose` para cerrar el bloc cuando ya nadie lo escucha.
/// Pantallas que conviven en el stack (índice → historial) deben crear
/// su propia instancia con [createPriceBloc] para no pisarse el estado.
final priceBlocProvider = Provider.autoDispose<PriceBloc>((ref) {
  final bloc = PriceBloc(
    getIndexByZone: ref.watch(getIndexByZoneUsecaseProvider),
    getPriceHistory: ref.watch(getPriceHistoryUsecaseProvider),
    createPriceAlert: ref.watch(createPriceAlertUsecaseProvider),
    getMyAlerts: ref.watch(getMyAlertsUsecaseProvider),
    toggleAlert: ref.watch(toggleAlertUsecaseProvider),
    deleteAlert: ref.watch(deleteAlertUsecaseProvider),
  );
  ref.onDispose(bloc.close);
  return bloc;
});

/// Crea una instancia NUEVA de [PriceBloc] para una pantalla concreta.
///
/// El caller es responsable de cerrarla (`bloc.close()` en `dispose`).
PriceBloc createPriceBloc(WidgetRef ref) {
  return PriceBloc(
    getIndexByZone: ref.read(getIndexByZoneUsecaseProvider),
    getPriceHistory: ref.read(getPriceHistoryUsecaseProvider),
    createPriceAlert: ref.read(createPriceAlertUsecaseProvider),
    getMyAlerts: ref.read(getMyAlertsUsecaseProvider),
    toggleAlert: ref.read(toggleAlertUsecaseProvider),
    deleteAlert: ref.read(deleteAlertUsecaseProvider),
  );
}
