// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorModel _$VendorModelFromJson(Map<String, dynamic> json) => _VendorModel(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  category: json['category'] as String,
  rating: (json['rating'] as num).toDouble(),
  totalRatings: (json['totalRatings'] as num).toInt(),
  isVerified: json['isVerified'] as bool,
  photoUrl: json['photoUrl'] as String?,
  description: json['description'] as String?,
  address: json['address'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  whatsapp: json['whatsapp'] as String?,
);

Map<String, dynamic> _$VendorModelToJson(_VendorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'category': instance.category,
      'rating': instance.rating,
      'totalRatings': instance.totalRatings,
      'isVerified': instance.isVerified,
      'photoUrl': instance.photoUrl,
      'description': instance.description,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'whatsapp': instance.whatsapp,
    };
