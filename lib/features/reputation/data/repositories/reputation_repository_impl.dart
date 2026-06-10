import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/rating_entity.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/reputation_repository.dart';
import '../datasources/reputation_remote_datasource.dart';

/// Implementación del repositorio de reputación.
///
/// Atrapa excepciones de la capa de datos y las convierte en [Failure]
/// con mensajes en español listos para la UI.
class ReputationRepositoryImpl implements ReputationRepository {
  ReputationRepositoryImpl(this._remote);

  final ReputationRemoteDatasource _remote;

  @override
  Future<(Failure?, List<RatingEntity>?)> getVendorRatings(
    String vendorId,
  ) async {
    return _guard(() async {
      final models = await _remote.getVendorRatings(vendorId);
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<(Failure?, RatingEntity?)> submitRating({
    required String vendorId,
    required double stars,
    String? comment,
  }) async {
    return _guard(() async {
      final model = await _remote.submitRating(
        vendorId: vendorId,
        stars: stars,
        comment: comment,
      );
      return model.toEntity();
    });
  }

  @override
  Future<(Failure?, ReportEntity?)> reportFraud({
    required String vendorId,
    required String reason,
    String? description,
  }) async {
    return _guard(() async {
      final model = await _remote.reportFraud(
        vendorId: vendorId,
        reason: reason,
        description: description,
      );
      return model.toEntity();
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
