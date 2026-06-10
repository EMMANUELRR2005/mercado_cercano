import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/vendor_stats_entity.dart';
import 'product_model.dart';

part 'vendor_stats_model.freezed.dart';
part 'vendor_stats_model.g.dart';

/// Punto día/valor de la serie de vistas (capa de datos).
@freezed
abstract class DailyViewsModel with _$DailyViewsModel {
  const DailyViewsModel._();

  const factory DailyViewsModel({
    required DateTime date,
    required int views,
  }) = _DailyViewsModel;

  factory DailyViewsModel.fromJson(Map<String, dynamic> json) =>
      _$DailyViewsModelFromJson(json);

  DailyViewsEntity toEntity() => DailyViewsEntity(date: date, views: views);
}

/// Modelo de métricas del vendedor (espejo del JSON de `/vendor/stats`).
@freezed
abstract class VendorStatsModel with _$VendorStatsModel {
  const VendorStatsModel._();

  const factory VendorStatsModel({
    required int totalViews,
    required int totalClicks,
    required int activeProducts,
    required int soldOutProducts,
    required List<DailyViewsModel> viewsByDay,
    required List<ProductModel> topProducts,
    required double averageRating,
  }) = _VendorStatsModel;

  factory VendorStatsModel.fromJson(Map<String, dynamic> json) =>
      _$VendorStatsModelFromJson(json);

  /// Convierte el modelo de datos a la entidad de dominio.
  VendorStatsEntity toEntity() {
    return VendorStatsEntity(
      totalViews: totalViews,
      totalClicks: totalClicks,
      activeProducts: activeProducts,
      soldOutProducts: soldOutProducts,
      viewsByDay: viewsByDay.map((d) => d.toEntity()).toList(),
      topProducts: topProducts.map((p) => p.toEntity()).toList(),
      averageRating: averageRating,
    );
  }
}
