// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_entities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceIndex _$PriceIndexFromJson(Map<String, dynamic> json) => _PriceIndex(
  productName: json['productName'] as String,
  unit: json['unit'] as String,
  averagePrice: (json['averagePrice'] as num).toDouble(),
  minPrice: (json['minPrice'] as num).toDouble(),
  maxPrice: (json['maxPrice'] as num).toDouble(),
  reportCount: (json['reportCount'] as num).toInt(),
  changeVsYesterday: (json['changeVsYesterday'] as num).toDouble(),
  zone: json['zone'] as String,
);

Map<String, dynamic> _$PriceIndexToJson(_PriceIndex instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'unit': instance.unit,
      'averagePrice': instance.averagePrice,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'reportCount': instance.reportCount,
      'changeVsYesterday': instance.changeVsYesterday,
      'zone': instance.zone,
    };

_PricePoint _$PricePointFromJson(Map<String, dynamic> json) => _PricePoint(
  date: DateTime.parse(json['date'] as String),
  price: (json['price'] as num).toDouble(),
  zoneAverage: (json['zoneAverage'] as num?)?.toDouble(),
);

Map<String, dynamic> _$PricePointToJson(_PricePoint instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'price': instance.price,
      'zoneAverage': instance.zoneAverage,
    };

_PriceHistory _$PriceHistoryFromJson(Map<String, dynamic> json) =>
    _PriceHistory(
      productName: json['productName'] as String,
      unit: json['unit'] as String,
      points: (json['points'] as List<dynamic>)
          .map((e) => PricePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PriceHistoryToJson(_PriceHistory instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'unit': instance.unit,
      'points': instance.points,
    };

_PriceAlert _$PriceAlertFromJson(Map<String, dynamic> json) => _PriceAlert(
  id: json['id'] as String,
  productName: json['productName'] as String,
  targetPrice: (json['targetPrice'] as num).toDouble(),
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PriceAlertToJson(_PriceAlert instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'targetPrice': instance.targetPrice,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };
