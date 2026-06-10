import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/product_entity.dart';

part 'map_filters_entity.freezed.dart';

/// Filtros activos del mapa de vendedores cercanos.
///
/// `radiusKm` controla el círculo de búsqueda (default
/// `AppConstants.defaultSearchRadiusKm` = 5 km).
@freezed
abstract class MapFiltersEntity with _$MapFiltersEntity {
  const factory MapFiltersEntity({
    @Default(5.0) double radiusKm,
    ProductCategory? category,
    @Default(false) bool onlyVerified,
  }) = _MapFiltersEntity;
}
