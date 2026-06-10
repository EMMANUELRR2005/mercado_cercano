// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => _ReportModel(
  id: json['id'] as String,
  vendorId: json['vendorId'] as String,
  reason: json['reason'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  description: json['description'] as String?,
);

Map<String, dynamic> _$ReportModelToJson(_ReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendorId': instance.vendorId,
      'reason': instance.reason,
      'createdAt': instance.createdAt.toIso8601String(),
      'description': instance.description,
    };
