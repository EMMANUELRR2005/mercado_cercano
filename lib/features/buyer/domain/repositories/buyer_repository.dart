import '../../../../core/errors/failure.dart';
import '../entities/search_filters.dart';

/// Contrato del repositorio del comprador.
///
/// Convención de retorno (sin dartz en el proyecto): record
/// `(Failure?, T?)` — exactamente uno de los dos es no nulo.
abstract class BuyerRepository {
  /// Busca productos cercanos aplicando [filters] y un texto opcional.
  Future<(Failure?, List<SearchResult>?)> searchProducts({
    String? query,
    required SearchFilters filters,
  });

  /// Detalle de un producto (incluye vendedor y distancia).
  ///
  /// También registra la vista del producto (analytics del vendedor).
  Future<(Failure?, SearchResult?)> getProductDetail(String productId);

  /// Perfil de un vendedor con su catálogo de productos.
  Future<(Failure?, VendorDetail?)> getVendorDetail(String vendorId);

  /// Reporta un precio observado (crowdsourcing del índice).
  /// Devuelve `true` si el reporte fue aceptado.
  Future<(Failure?, bool?)> reportPrice({
    required String productName,
    required double price,
    required String unit,
    required String zone,
  });
}
