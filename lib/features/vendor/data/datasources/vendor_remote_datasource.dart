import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/product_draft.dart';
import '../models/product_model.dart';
import '../models/vendor_stats_model.dart';

/// Contrato del datasource del panel del vendedor.
///
/// Lo implementan [VendorRemoteDatasourceImpl] (API real) y
/// `VendorMockDatasource` (datos simulados en memoria).
/// Los métodos lanzan `DioException` / `AppException` ante errores;
/// el BLoC los mapea a `Failure`.
abstract class VendorRemoteDatasource {
  /// `GET /vendor/products`.
  Future<List<ProductModel>> getMyProducts();

  /// `POST /vendor/products`.
  Future<ProductModel> createProduct(ProductDraft draft);

  /// `PUT /vendor/products/:id`.
  Future<ProductModel> updateProduct(ProductModel product);

  /// `PATCH /vendor/products/:id` con `{isAvailable: false}`.
  Future<ProductModel> markSoldOut(String productId);

  /// `POST /vendor/products/renew-all`: extiende +24 h los activos.
  Future<List<ProductModel>> renewAllProducts();

  /// `GET /vendor/stats`.
  Future<VendorStatsModel> getVendorStats();
}

/// Implementación real contra la API de MercadoCercano.
class VendorRemoteDatasourceImpl implements VendorRemoteDatasource {
  VendorRemoteDatasourceImpl({required this._client});

  final DioClient _client;

  /// `/vendor/products/:id` (deriva de `ApiEndpoints.vendorProducts`).
  String _productPath(String id) => '${ApiEndpoints.vendorProducts}/$id';

  @override
  Future<List<ProductModel>> getMyProducts() async {
    final response = await _client.get<List<dynamic>>(
      ApiEndpoints.vendorProducts,
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía en vendor/products');
    }
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProductModel> createProduct(ProductDraft draft) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.vendorProducts,
      data: {
        'name': draft.name,
        'price': draft.price,
        'category': draft.category.name,
        'photoUrl': draft.photoUrl,
        if (draft.unit != null) 'unit': draft.unit,
        if (draft.description != null) 'description': draft.description,
      },
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al crear producto');
    }
    return ProductModel.fromJson(data);
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await _client.put<Map<String, dynamic>>(
      _productPath(product.id),
      data: product.toJson(),
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al actualizar producto');
    }
    return ProductModel.fromJson(data);
  }

  @override
  Future<ProductModel> markSoldOut(String productId) async {
    final response = await _client.patch<Map<String, dynamic>>(
      _productPath(productId),
      data: {'isAvailable': false},
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al marcar agotado');
    }
    return ProductModel.fromJson(data);
  }

  @override
  Future<List<ProductModel>> renewAllProducts() async {
    final response = await _client.post<List<dynamic>>(
      '${ApiEndpoints.vendorProducts}/renew-all',
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía al renovar productos');
    }
    return data
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<VendorStatsModel> getVendorStats() async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.vendorStats,
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía en vendor/stats');
    }
    return VendorStatsModel.fromJson(data);
  }
}
