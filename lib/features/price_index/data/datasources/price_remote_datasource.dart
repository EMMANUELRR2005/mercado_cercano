import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/price_alert_model.dart';
import '../models/price_history_model.dart';
import '../models/price_index_model.dart';

/// Contrato del datasource remoto del índice de precios.
abstract class PriceRemoteDatasource {
  /// Índice de precios de la canasta básica en una zona.
  Future<List<PriceIndexModel>> getIndexByZone({String? zone});

  /// Historial diario de precios de un producto.
  Future<PriceHistoryModel> getPriceHistory(String productName);

  /// Crea una alerta de precio; el backend asigna el id.
  Future<PriceAlertModel> createAlert({
    required String productName,
    required double targetPrice,
  });

  /// Alertas del comprador autenticado.
  Future<List<PriceAlertModel>> getMyAlerts();

  /// Activa/desactiva una alerta y devuelve la versión actualizada.
  Future<PriceAlertModel> toggleAlert(String alertId);

  /// Elimina una alerta.
  Future<void> deleteAlert(String alertId);
}

/// Implementación real contra la API de MercadoCercano.
class PriceRemoteDatasourceImpl implements PriceRemoteDatasource {
  PriceRemoteDatasourceImpl(this._client);

  final DioClient _client;

  @override
  Future<List<PriceIndexModel>> getIndexByZone({String? zone}) async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.pricesIndex,
      queryParameters: {'zone': ?zone},
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al obtener el índice');
    }
    return data
        .map((e) => PriceIndexModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PriceHistoryModel> getPriceHistory(String productName) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.pricesHistory(productName),
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al obtener el historial');
    }
    return PriceHistoryModel.fromJson(data);
  }

  @override
  Future<PriceAlertModel> createAlert({
    required String productName,
    required double targetPrice,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.pricesAlerts,
      data: {'productName': productName, 'targetPrice': targetPrice},
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al crear la alerta');
    }
    return PriceAlertModel.fromJson(data);
  }

  @override
  Future<List<PriceAlertModel>> getMyAlerts() async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.pricesAlerts,
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al obtener alertas');
    }
    return data
        .map((e) => PriceAlertModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PriceAlertModel> toggleAlert(String alertId) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '${ApiEndpoints.pricesAlerts}/$alertId/toggle',
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al actualizar la alerta');
    }
    return PriceAlertModel.fromJson(data);
  }

  @override
  Future<void> deleteAlert(String alertId) async {
    await _client.delete<void>('${ApiEndpoints.pricesAlerts}/$alertId');
  }
}
