// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RatingModel _$RatingModelFromJson(Map<String, dynamic> json) => _RatingModel(
  id: json['id'] as String,
  vendorId: json['vendorId'] as String,
  buyerId: json['buyerId'] as String,
  stars: (json['stars'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$RatingModelToJson(_RatingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendorId': instance.vendorId,
      'buyerId': instance.buyerId,
      'stars': instance.stars,
      'createdAt': instance.createdAt.toIso8601String(),
      'comment': instance.comment,
    };
