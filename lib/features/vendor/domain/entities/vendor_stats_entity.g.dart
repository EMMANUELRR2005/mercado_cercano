// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_stats_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyViewsEntity _$DailyViewsEntityFromJson(Map<String, dynamic> json) =>
    _DailyViewsEntity(
      date: DateTime.parse(json['date'] as String),
      views: (json['views'] as num).toInt(),
    );

Map<String, dynamic> _$DailyViewsEntityToJson(_DailyViewsEntity instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'views': instance.views,
    };

_VendorStatsEntity _$VendorStatsEntityFromJson(Map<String, dynamic> json) =>
    _VendorStatsEntity(
      totalViews: (json['totalViews'] as num).toInt(),
      totalClicks: (json['totalClicks'] as num).toInt(),
      activeProducts: (json['activeProducts'] as num).toInt(),
      soldOutProducts: (json['soldOutProducts'] as num).toInt(),
      viewsByDay: (json['viewsByDay'] as List<dynamic>)
          .map((e) => DailyViewsEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      topProducts: (json['topProducts'] as List<dynamic>)
          .map((e) => ProductEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageRating: (json['averageRating'] as num).toDouble(),
    );

Map<String, dynamic> _$VendorStatsEntityToJson(_VendorStatsEntity instance) =>
    <String, dynamic>{
      'totalViews': instance.totalViews,
      'totalClicks': instance.totalClicks,
      'activeProducts': instance.activeProducts,
      'soldOutProducts': instance.soldOutProducts,
      'viewsByDay': instance.viewsByDay,
      'topProducts': instance.topProducts,
      'averageRating': instance.averageRating,
    };
