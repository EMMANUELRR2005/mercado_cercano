// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => _UserEntity(
  id: json['id'] as String,
  phone: json['phone'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  name: json['name'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  totalRatings: (json['totalRatings'] as num?)?.toInt(),
  isVerified: json['isVerified'] as bool?,
  subscription: $enumDecodeNullable(
    _$UserSubscriptionEnumMap,
    json['subscription'],
  ),
);

Map<String, dynamic> _$UserEntityToJson(_UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'role': _$UserRoleEnumMap[instance.role]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'rating': instance.rating,
      'totalRatings': instance.totalRatings,
      'isVerified': instance.isVerified,
      'subscription': _$UserSubscriptionEnumMap[instance.subscription],
    };

const _$UserRoleEnumMap = {UserRole.buyer: 'buyer', UserRole.vendor: 'vendor'};

const _$UserSubscriptionEnumMap = {
  UserSubscription.free: 'free',
  UserSubscription.pro: 'pro',
  UserSubscription.family: 'family',
};
