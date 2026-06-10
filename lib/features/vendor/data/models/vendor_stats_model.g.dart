// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyViewsModel _$DailyViewsModelFromJson(Map<String, dynamic> json) =>
    _DailyViewsModel(
      date: DateTime.parse(json['date'] as String),
      views: (json['views'] as num).toInt(),
    );

Map<String, dynamic> _$DailyViewsModelToJson(_DailyViewsModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'views': instance.views,
    };

_VendorStatsModel _$VendorStatsModelFromJson(Map<String, dynamic> json) =>
    _VendorStatsModel(
      totalViews: (json['totalViews'] as num).toInt(),
      totalClicks: (json['totalClicks'] as num).toInt(),
      activeProducts: (json['activeProducts'] as num).toInt(),
      soldOutProducts: (json['soldOutProducts'] as num).toInt(),
      viewsByDay: (json['viewsByDay'] as List<dynamic>)
          .map((e) => DailyViewsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      topProducts: (json['topProducts'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageRating: (json['averageRating'] as num).toDouble(),
    );

Map<String, dynamic> _$VendorStatsModelToJson(_VendorStatsModel instance) =>
    <String, dynamic>{
      'totalViews': instance.totalViews,
      'totalClicks': instance.totalClicks,
      'activeProducts': instance.activeProducts,
      'soldOutProducts': instance.soldOutProducts,
      'viewsByDay': instance.viewsByDay,
      'topProducts': instance.topProducts,
      'averageRating': instance.averageRating,
    };
