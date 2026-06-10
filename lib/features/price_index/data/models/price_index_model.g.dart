// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_index_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceIndexModel _$PriceIndexModelFromJson(Map<String, dynamic> json) =>
    _PriceIndexModel(
      productName: json['productName'] as String,
      unit: json['unit'] as String,
      averagePrice: (json['averagePrice'] as num).toDouble(),
      minPrice: (json['minPrice'] as num).toDouble(),
      maxPrice: (json['maxPrice'] as num).toDouble(),
      reportCount: (json['reportCount'] as num).toInt(),
      changeVsYesterday: (json['changeVsYesterday'] as num).toDouble(),
      zone: json['zone'] as String,
    );

Map<String, dynamic> _$PriceIndexModelToJson(_PriceIndexModel instance) =>
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
