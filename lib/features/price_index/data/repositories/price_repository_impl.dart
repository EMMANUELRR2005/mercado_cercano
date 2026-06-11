import 'package:dio/dio.dart';

import '../../../../core/cache/offline_cache_service.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../shared/domain/entities/price_entities.dart';
import '../../domain/repositories/price_repository.dart';
import '../datasources/price_remote_datasource.dart';
import '../models/price_index_model.dart';

/// Implementación del repositorio del índice de precios.
///
/// Atrapa excepciones de la capa de datos y las convierte en [Failure]
/// con mensajes en español listos para la UI. El índice usa caché
/// offline (Hive, TTL 1 h): sin conexión se muestran los últimos
/// precios conocidos.
class PriceRepositoryImpl implements PriceRepository {
  PriceRepositoryImpl(this._remote, {this._cache});

  final PriceRemoteDatasource _remote;
  final OfflineCacheService? _cache;

  static const _indexCacheKey = 'index';

  @override
  Future<(Failure?, List<PriceIndex>?)> getIndexByZone({String? zone}) {
    return _guard(() async {
      try {
        final models = await _remote.getIndexByZone(zone: zone);
        // Cache-aside: guardar el índice fresco para el modo offline.
        await _cache?.put(
          OfflineCacheService.priceIndexBox,
          _indexCacheKey,
          models.map((m) => m.toJson()).toList(),
        );
        return models.map((m) => m.toEntity()).toList();
      } on NetworkException {
        // Sin red: últimos precios conocidos (si el TTL sigue vigente).
        final cached = await _cache?.get<List<dynamic>>(
          OfflineCacheService.priceIndexBox,
          _indexCacheKey,
        );
        if (cached == null) rethrow;
        return cached
            .map((json) => PriceIndexModel.fromJson(
                  Map<String, dynamic>.from(json as Map),
                ).toEntity())
            .toList();
      }
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
