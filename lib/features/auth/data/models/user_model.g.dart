// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  phone: json['phone'] as String,
  role: json['role'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  name: json['name'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  totalRatings: (json['totalRatings'] as num?)?.toInt(),
  isVerified: json['isVerified'] as bool?,
  subscription: json['subscription'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'role': instance.role,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'rating': instance.rating,
      'totalRatings': instance.totalRatings,
      'isVerified': instance.isVerified,
      'subscription': instance.subscription,
    };
