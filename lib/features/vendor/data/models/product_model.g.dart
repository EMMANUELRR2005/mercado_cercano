// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      photoUrl: json['photoUrl'] as String,
      isAvailable: json['isAvailable'] as bool,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      viewCount: (json['viewCount'] as num).toInt(),
      clickCount: (json['clickCount'] as num).toInt(),
      isFeatured: json['isFeatured'] as bool?,
      description: json['description'] as String?,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendorId': instance.vendorId,
      'name': instance.name,
      'category': instance.category,
      'price': instance.price,
      'photoUrl': instance.photoUrl,
      'isAvailable': instance.isAvailable,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'viewCount': instance.viewCount,
      'clickCount': instance.clickCount,
      'isFeatured': instance.isFeatured,
      'description': instance.description,
      'unit': instance.unit,
    };
