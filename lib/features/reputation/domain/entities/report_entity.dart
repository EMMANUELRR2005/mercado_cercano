import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_entity.freezed.dart';

/// Reporte de fraude o mala práctica contra un vendedor.
@freezed
abstract class ReportEntity with _$ReportEntity {
  const factory ReportEntity({
    required String id,
    required String vendorId,
    required String reason,
    required DateTime createdAt,
    String? description,
  }) = _ReportEntity;
}
