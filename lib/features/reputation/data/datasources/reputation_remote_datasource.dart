import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/rating_model.dart';
import '../models/report_model.dart';

/// Contrato del datasource remoto de reputación.
abstract class ReputationRemoteDatasource {
  /// Calificaciones de un vendedor, más recientes primero.
  Future<List<RatingModel>> getVendorRatings(String vendorId);

  /// Envía una calificación; el backend asigna id y buyerId (del token).
  Future<RatingModel> submitRating({
    required String vendorId,
    required double stars,
    String? comment,
  });

  /// Envía un reporte de fraude.
  Future<ReportModel> reportFraud({
    required String vendorId,
    required String reason,
    String? description,
  });
}

/// Implementación real contra la API de MercadoCercano.
class ReputationRemoteDatasourceImpl implements ReputationRemoteDatasource {
  ReputationRemoteDatasourceImpl(this._client);

  final DioClient _client;

  @override
  Future<List<RatingModel>> getVendorRatings(String vendorId) async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.ratings,
      queryParameters: {'vendorId': vendorId},
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al obtener calificaciones');
    }
    return data
        .map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RatingModel> submitRating({
    required String vendorId,
    required double stars,
    String? comment,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.ratings,
      data: {
        'vendorId': vendorId,
        'stars': stars,
        'comment': ?comment,
      },
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al enviar calificación');
    }
    return RatingModel.fromJson(data);
  }

  @override
  Future<ReportModel> reportFraud({
    required String vendorId,
    required String reason,
    String? description,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.reportsFraud,
      data: {
        'vendorId': vendorId,
        'reason': reason,
        'description': ?description,
      },
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al enviar reporte');
    }
    return ReportModel.fromJson(data);
  }
}
