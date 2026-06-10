import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/search_filters.dart';
import '../../domain/repositories/buyer_repository.dart';
import '../datasources/buyer_remote_datasource.dart';

/// Implementación del repositorio del comprador.
///
/// Atrapa excepciones de la capa de datos y las convierte en [Failure]
/// con mensajes en español listos para la UI.
class BuyerRepositoryImpl implements BuyerRepository {
  BuyerRepositoryImpl(this._remote);

  final BuyerRemoteDatasource _remote;

  @override
  Future<(Failure?, List<SearchResult>?)> searchProducts({
    String? query,
    required SearchFilters filters,
  }) {
    return _guard(() async {
      final models = await _remote.searchProducts(
        query: query,
        filters: filters,
      );
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<(Failure?, SearchResult?)> getProductDetail(String productId) {
    return _guard(() async {
      final model = await _remote.getProductDetail(productId);
      return model.toEntity();
    });
  }

  @override
  Future<(Failure?, VendorDetail?)> getVendorDetail(String vendorId) {
    return _guard(() async {
      final model = await _remote.getVendorDetail(vendorId);
      return model.toEntity();
    });
  }

  @override
  Future<(Failure?, bool?)> reportPrice({
    required String productName,
    required double price,
    required String unit,
    required String zone,
  }) {
    return _guard(() async {
      await _remote.reportPrice(
        productName: productName,
        price: price,
        unit: unit,
        zone: zone,
      );
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
