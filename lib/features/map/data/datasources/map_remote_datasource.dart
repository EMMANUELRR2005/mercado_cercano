import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/vendor_location_model.dart';

/// Contrato del datasource remoto del mapa.
abstract class MapRemoteDatasource {
  /// Vendedores activos cerca de una coordenada, dentro de `radiusKm`.
  ///
  /// Backend: `GET /vendors/nearby?lat={lat}&lng={lng}&radiusKm={radiusKm}`.
  Future<List<VendorLocationModel>> getVendorsNearby({
    required double lat,
    required double lng,
    required double radiusKm,
  });
}

/// Implementación real contra la API de MercadoCercano.
class MapRemoteDatasourceImpl implements MapRemoteDatasource {
  MapRemoteDatasourceImpl(this._client);

  final DioClient _client;

  @override
  Future<List<VendorLocationModel>> getVendorsNearby({
    required double lat,
    required double lng,
    required double radiusKm,
  }) async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.vendorsNearby,
      queryParameters: {
        'lat': lat,
        'lng': lng,
        'radiusKm': radiusKm,
      },
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException(
        'Respuesta vacía al obtener vendedores cercanos',
      );
    }
    return data
        .map((e) => VendorLocationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
