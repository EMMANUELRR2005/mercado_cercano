// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceAlertModel _$PriceAlertModelFromJson(Map<String, dynamic> json) =>
    _PriceAlertModel(
      id: json['id'] as String,
      productName: json['productName'] as String,
      targetPrice: (json['targetPrice'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PriceAlertModelToJson(_PriceAlertModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'targetPrice': instance.targetPrice,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };
