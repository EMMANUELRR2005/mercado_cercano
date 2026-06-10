// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PricePointModel _$PricePointModelFromJson(Map<String, dynamic> json) =>
    _PricePointModel(
      date: DateTime.parse(json['date'] as String),
      price: (json['price'] as num).toDouble(),
      zoneAverage: (json['zoneAverage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PricePointModelToJson(_PricePointModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'price': instance.price,
      'zoneAverage': instance.zoneAverage,
    };

_PriceHistoryModel _$PriceHistoryModelFromJson(Map<String, dynamic> json) =>
    _PriceHistoryModel(
      productName: json['productName'] as String,
      unit: json['unit'] as String,
      points: (json['points'] as List<dynamic>)
          .map((e) => PricePointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PriceHistoryModelToJson(_PriceHistoryModel instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'unit': instance.unit,
      'points': instance.points,
    };
