// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_bounds_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MapBoundsModel _$MapBoundsModelFromJson(Map<String, dynamic> json) =>
    _MapBoundsModel(
      southWestLat: (json['southWestLat'] as num).toDouble(),
      southWestLng: (json['southWestLng'] as num).toDouble(),
      northEastLat: (json['northEastLat'] as num).toDouble(),
      northEastLng: (json['northEastLng'] as num).toDouble(),
    );

Map<String, dynamic> _$MapBoundsModelToJson(_MapBoundsModel instance) =>
    <String, dynamic>{
      'southWestLat': instance.southWestLat,
      'southWestLng': instance.southWestLng,
      'northEastLat': instance.northEastLat,
      'northEastLng': instance.northEastLng,
    };
