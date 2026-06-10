// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorLocationModel _$VendorLocationModelFromJson(Map<String, dynamic> json) =>
    _VendorLocationModel(
      vendor: VendorEntity.fromJson(json['vendor'] as Map<String, dynamic>),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isOnline: json['isOnline'] as bool? ?? true,
      lowestPriceToday: (json['lowestPriceToday'] as num?)?.toDouble(),
      lowestPriceProductName: json['lowestPriceProductName'] as String?,
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VendorLocationModelToJson(
  _VendorLocationModel instance,
) => <String, dynamic>{
  'vendor': instance.vendor,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'isOnline': instance.isOnline,
  'lowestPriceToday': instance.lowestPriceToday,
  'lowestPriceProductName': instance.lowestPriceProductName,
  'distanceMeters': instance.distanceMeters,
};
