import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/price_entities.dart';

part 'price_alert_model.freezed.dart';
part 'price_alert_model.g.dart';

/// Modelo de datos (JSON ↔ API) de una alerta de precio.
@freezed
abstract class PriceAlertModel with _$PriceAlertModel {
  const PriceAlertModel._();

  const factory PriceAlertModel({
    required String id,
    required String productName,
    required double targetPrice,
    required bool isActive,
    required DateTime createdAt,
  }) = _PriceAlertModel;

  factory PriceAlertModel.fromJson(Map<String, dynamic> json) =>
      _$PriceAlertModelFromJson(json);

  /// Convierte el modelo de datos a la entidad de dominio.
  PriceAlert toEntity() => PriceAlert(
        id: id,
        productName: productName,
        targetPrice: targetPrice,
        isActive: isActive,
        createdAt: createdAt,
      );
}
