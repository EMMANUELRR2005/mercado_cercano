import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/report_entity.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

/// Modelo de datos (JSON ↔ API) de un reporte de fraude.
@freezed
abstract class ReportModel with _$ReportModel {
  const ReportModel._();

  const factory ReportModel({
    required String id,
    required String vendorId,
    required String reason,
    required DateTime createdAt,
    String? description,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  /// Convierte el modelo de datos a la entidad de dominio.
  ReportEntity toEntity() => ReportEntity(
        id: id,
        vendorId: vendorId,
        reason: reason,
        createdAt: createdAt,
        description: description,
      );
}
