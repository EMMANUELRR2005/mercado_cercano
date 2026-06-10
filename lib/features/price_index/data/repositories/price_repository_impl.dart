import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../shared/domain/entities/price_entities.dart';
import '../../domain/repositories/price_repository.dart';
import '../datasources/price_remote_datasource.dart';

/// Implementación del repositorio del índice de precios.
///
/// Atrapa excepciones de la capa de datos y las convierte en [Failure]
/// con mensajes en español listos para la UI.
class PriceRepositoryImpl implements PriceRepository {
  PriceRepositoryImpl(this._remote);

  final PriceRemoteDatasource _remote;

  @override
  Future<(Failure?, List<PriceIndex>?)> getIndexByZone({String? zone}) {
    return _guard(() async {
      final models = await _remote.getIndexByZone(zone: zone);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<(Failure?, PriceHistory?)> getPriceHistory(String productName) {
    return _guard(() async {
      final model = await _remote.getPriceHistory(productName);
      return model.toEntity();
    });
  }

  @override
  Future<(Failure?, PriceAlert?)> createAlert({
    required String productName,
    required double targetPrice,
  }) {
    return _guard(() async {
      final model = await _remote.createAlert(
        productName: productName,
        targetPrice: targetPrice,
      );
      return model.toEntity();
    });
  }

  @override
  Future<(Failure?, List<PriceAlert>?)> getMyAlerts() {
    return _guard(() async {
      final models = await _remote.getMyAlerts();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<(Failure?, PriceAlert?)> toggleAlert(String alertId) {
    return _guard(() async {
      final model = await _remote.toggleAlert(alertId);
      return model.toEntity();
    });
  }

  @override
  Future<(Failure?, bool?)> deleteAlert(String alertId) {
    return _guard(() async {
      await _remote.deleteAlert(alertId);
      return true;
    });
  }

  /// Ejecuta [action] y mapea cualquier excepción conocida a un [Failure].
  Future<(Failure?, T?)> _guard<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return (null, result);
    } on DioException catch (e) {
      return (mapDioException(e), null);
    } on AppException catch (e) {
      return (mapAppException(e), null);
    } catch (_) {
      return (const ServerFailure(), null);
    }
  }
}
