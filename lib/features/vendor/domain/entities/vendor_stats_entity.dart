import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/product_entity.dart';

part 'vendor_stats_entity.freezed.dart';
part 'vendor_stats_entity.g.dart';

/// Punto de la serie "vistas por día" del panel del vendedor.
@freezed
abstract class DailyViewsEntity with _$DailyViewsEntity {
  const factory DailyViewsEntity({
    required DateTime date,
    required int views,
  }) = _DailyViewsEntity;

  factory DailyViewsEntity.fromJson(Map<String, dynamic> json) =>
      _$DailyViewsEntityFromJson(json);
}

/// Métricas agregadas del negocio del vendedor.
///
/// `viewsByDay` cubre los últimos 7 días (orden cronológico ascendente)
/// y `topProducts` son los productos más vistos.
@freezed
abstract class VendorStatsEntity with _$VendorStatsEntity {
  const factory VendorStatsEntity({
    required int totalViews,
    required int totalClicks,
    required int activeProducts,
    required int soldOutProducts,
    required List<DailyViewsEntity> viewsByDay,
    required List<ProductEntity> topProducts,
    required double averageRating,
  }) = _VendorStatsEntity;

  factory VendorStatsEntity.fromJson(Map<String, dynamic> json) =>
      _$VendorStatsEntityFromJson(json);
}
