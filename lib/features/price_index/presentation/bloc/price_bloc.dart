import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/domain/entities/price_entities.dart';
import '../../domain/usecases/create_price_alert_usecase.dart';
import '../../domain/usecases/get_index_by_zone_usecase.dart';
import '../../domain/usecases/get_my_alerts_usecase.dart';
import '../../domain/usecases/get_price_history_usecase.dart';
import '../../domain/usecases/toggle_alert_usecase.dart';

part 'price_event.dart';
part 'price_state.dart';

/// BLoC del índice de precios: canasta básica, historial y alertas.
class PriceBloc extends Bloc<PriceEvent, PriceState> {
  PriceBloc({
    required this._getIndexByZone,
    required this._getPriceHistory,
    required this._createPriceAlert,
    required this._getMyAlerts,
    required this._toggleAlert,
    required this._deleteAlert,
  }) : super(const PriceInitial()) {
    on<PriceIndexRequested>(_onIndexRequested);
    on<PriceHistoryRequested>(_onHistoryRequested);
    on<PriceAlertsRequested>(_onAlertsRequested);
    on<PriceAlertCreated>(_onAlertCreated);
    on<PriceAlertToggled>(_onAlertToggled);
    on<PriceAlertDeleted>(_onAlertDeleted);
  }

  final GetIndexByZoneUsecase _getIndexByZone;
  final GetPriceHistoryUsecase _getPriceHistory;
  final CreatePriceAlertUsecase _createPriceAlert;
  final GetMyAlertsUsecase _getMyAlerts;
  final ToggleAlertUsecase _toggleAlert;
  final DeleteAlertUsecase _deleteAlert;

  Future<void> _onIndexRequested(
    PriceIndexRequested event,
    Emitter<PriceState> emit,
  ) async {
    emit(const PriceLoading());
    final (failure, indices) = await _getIndexByZone(zone: event.zone);
    if (failure != null) {
      emit(PriceError(failure.message));
      return;
    }
    final list = indices ?? const <PriceIndex>[];
    emit(
      PriceIndexLoaded(
        indices: list,
        // La zona viene en cada entrada del índice.
        zone: list.isNotEmpty ? list.first.zone : (event.zone ?? 'Tu zona'),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> _onHistoryRequested(
    PriceHistoryRequested event,
    Emitter<PriceState> emit,
  ) async {
    emit(const PriceLoading());
    final (failure, history) = await _getPriceHistory(event.productName);
    if (failure != null) {
      emit(PriceError(failure.message));
      return;
    }
    emit(PriceHistoryLoaded(history!));
  }

  Future<void> _onAlertsRequested(
    PriceAlertsRequested event,
    Emitter<PriceState> emit,
  ) async {
    emit(const PriceLoading());
    await _emitAlerts(emit);
  }

  Future<void> _onAlertCreated(
    PriceAlertCreated event,
    Emitter<PriceState> emit,
  ) async {
    final (failure, _) = await _createPriceAlert(
      productName: event.productName,
      targetPrice: event.targetPrice,
    );
    if (failure != null) {
      emit(PriceError(failure.message));
      return;
    }
    await _emitAlerts(emit);
  }

  Future<void> _onAlertToggled(
    PriceAlertToggled event,
    Emitter<PriceState> emit,
  ) async {
    // Optimista: actualizamos la lista local de inmediato para que el
    // switch responda sin esperar al backend.
    final current = state;
    if (current is PriceAlertsLoaded) {
      emit(
        PriceAlertsLoaded([
          for (final a in current.alerts)
            a.id == event.alertId ? a.copyWith(isActive: !a.isActive) : a,
        ]),
      );
    }
    final (failure, _) = await _toggleAlert(event.alertId);
    if (failure != null) {
      emit(PriceError(failure.message));
      return;
    }
    await _emitAlerts(emit);
  }

  Future<void> _onAlertDeleted(
    PriceAlertDeleted event,
    Emitter<PriceState> emit,
  ) async {
    // Optimista: el Dismissible ya sacó la fila de la pantalla.
    final current = state;
    if (current is PriceAlertsLoaded) {
      emit(
        PriceAlertsLoaded(
          current.alerts.where((a) => a.id != event.alertId).toList(),
        ),
      );
    }
    final (failure, _) = await _deleteAlert(event.alertId);
    if (failure != null) {
      emit(PriceError(failure.message));
      return;
    }
    await _emitAlerts(emit);
  }

  /// Recarga las alertas desde el repositorio y emite el resultado.
  Future<void> _emitAlerts(Emitter<PriceState> emit) async {
    final (failure, alerts) = await _getMyAlerts();
    if (failure != null) {
      emit(PriceError(failure.message));
      return;
    }
    emit(PriceAlertsLoaded(alerts ?? const <PriceAlert>[]));
  }
}
