import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/entities/vendor_entity.dart';

part 'search_filters.freezed.dart';

/// Orden de los resultados de búsqueda.
enum SortOrder { relevance, priceLow, priceHigh, distance, rating }

/// Etiquetas en español para los chips de orden.
extension SortOrderX on SortOrder {
  String get label {
    switch (this) {
      case SortOrder.relevance:
        return 'Relevancia';
      case SortOrder.priceLow:
        return 'Menor precio';
      case SortOrder.priceHigh:
        return 'Mayor precio';
      case SortOrder.distance:
        return 'Distancia';
      case SortOrder.rating:
        return 'Calificación';
    }
  }
}

/// Filtros de búsqueda del comprador.
@freezed
abstract class SearchFilters with _$SearchFilters {
  const factory SearchFilters({
    @Default(5.0) double radiusKm,
    double? maxPrice,
    @Default(0.0) double minRating,
    @Default(true) bool onlyAvailable,
    ProductCategory? category,
    @Default(SortOrder.relevance) SortOrder sortBy,
  }) = _SearchFilters;
}

/// Resultado de búsqueda: producto con su vendedor y la distancia.
@freezed
abstract class SearchResult with _$SearchResult {
  const factory SearchResult({
    required ProductEntity product,
    required VendorEntity vendor,
    required double distanceKm,
  }) = _SearchResult;
}

/// Vendedor cercano con su distancia (sección de la home del comprador).
@freezed
abstract class NearbyVendor with _$NearbyVendor {
  const factory NearbyVendor({
    required VendorEntity vendor,
    required double distanceKm,
  }) = _NearbyVendor;
}

/// Detalle de un vendedor: perfil + catálogo de productos vigentes.
@freezed
abstract class VendorDetail with _$VendorDetail {
  const factory VendorDetail({
    required VendorEntity vendor,
    required List<ProductEntity> products,
    double? distanceKm,
  }) = _VendorDetail;
}
