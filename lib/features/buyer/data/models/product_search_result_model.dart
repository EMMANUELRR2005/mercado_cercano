import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/entities/vendor_entity.dart';
import '../../domain/entities/search_filters.dart';

part 'product_search_result_model.freezed.dart';
part 'product_search_result_model.g.dart';

/// Modelo de datos (JSON ↔ API) de un resultado de búsqueda:
/// producto + vendedor + distancia en kilómetros.
@freezed
abstract class ProductSearchResultModel with _$ProductSearchResultModel {
  const ProductSearchResultModel._();

  const factory ProductSearchResultModel({
    required ProductEntity product,
    required VendorEntity vendor,
    required double distanceKm,
  }) = _ProductSearchResultModel;

  factory ProductSearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSearchResultModelFromJson(json);

  /// Convierte el modelo de datos a la entidad de dominio.
  SearchResult toEntity() => SearchResult(
        product: product,
        vendor: vendor,
        distanceKm: distanceKm,
      );
}

/// Modelo de datos (JSON ↔ API) del detalle de un vendedor:
/// perfil + catálogo + distancia opcional.
@freezed
abstract class VendorDetailModel with _$VendorDetailModel {
  const VendorDetailModel._();

  const factory VendorDetailModel({
    required VendorEntity vendor,
    required List<ProductEntity> products,
    double? distanceKm,
  }) = _VendorDetailModel;

  factory VendorDetailModel.fromJson(Map<String, dynamic> json) =>
      _$VendorDetailModelFromJson(json);

  /// Convierte el modelo de datos a la entidad de dominio.
  VendorDetail toEntity() => VendorDetail(
        vendor: vendor,
        products: products,
        distanceKm: distanceKm,
      );
}
