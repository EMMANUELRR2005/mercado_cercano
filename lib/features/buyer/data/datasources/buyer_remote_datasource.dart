import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/search_filters.dart';
import '../models/product_search_result_model.dart';

/// Contrato del datasource remoto del comprador.
abstract class BuyerRemoteDatasource {
  /// Busca productos cercanos aplicando los filtros.
  Future<List<ProductSearchResultModel>> searchProducts({
    String? query,
    required SearchFilters filters,
  });

  /// Detalle de un producto; el backend registra la vista.
  Future<ProductSearchResultModel> getProductDetail(String productId);

  /// Perfil + catálogo de un vendedor.
  Future<VendorDetailModel> getVendorDetail(String vendorId);

  /// Reporta un precio observado (crowdsourcing del índice).
  Future<void> reportPrice({
    required String productName,
    required double price,
    required String unit,
    required String zone,
  });
}

/// Implementación real contra la API de MercadoCercano.
class BuyerRemoteDatasourceImpl implements BuyerRemoteDatasource {
  BuyerRemoteDatasourceImpl(this._client);

  final DioClient _client;

  @override
  Future<List<ProductSearchResultModel>> searchProducts({
    String? query,
    required SearchFilters filters,
  }) async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.productsSearch,
      queryParameters: {
        'q': ?query,
        'radiusKm': filters.radiusKm,
        'maxPrice': ?filters.maxPrice,
        'minRating': filters.minRating,
        'onlyAvailable': filters.onlyAvailable,
        'category': ?filters.category?.name,
        'sortBy': filters.sortBy.name,
      },
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al buscar productos');
    }
    return data
        .map((e) => ProductSearchResultModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductSearchResultModel> getProductDetail(String productId) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.productById(productId),
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al obtener el producto');
    }
    return ProductSearchResultModel.fromJson(data);
  }

  @override
  Future<VendorDetailModel> getVendorDetail(String vendorId) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.vendorById(vendorId),
    );
    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al obtener el vendedor');
    }
    return VendorDetailModel.fromJson(data);
  }

  @override
  Future<void> reportPrice({
    required String productName,
    required double price,
    required String unit,
    required String zone,
  }) async {
    await _client.post<Map<String, dynamic>>(
      ApiEndpoints.pricesReport,
      data: {
        'productName': productName,
        'price': price,
        'unit': unit,
        'zone': zone,
      },
    );
  }
}
