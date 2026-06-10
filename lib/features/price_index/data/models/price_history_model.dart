import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/price_entities.dart';

part 'price_history_model.freezed.dart';
part 'price_history_model.g.dart';

/// Modelo de datos (JSON ↔ API) de un punto de la serie histórica.
@freezed
abstract class PricePointModel with _$PricePointModel {
  const PricePointModel._();

  const factory PricePointModel({
    required DateTime date,
    required double price,
    double? zoneAverage,
  }) = _PricePointModel;

  factory PricePointModel.fromJson(Map<String, dynamic> json) =>
      _$PricePointModelFromJson(json);

  /// Convierte el modelo de datos a la entidad de dominio.
  PricePoint toEntity() => PricePoint(
        date: date,
        price: price,
        zoneAverage: zoneAverage,
      );
}

/// Modelo de datos (JSON ↔ API) del historial de precios de un producto.
@freezed
abstract class PriceHistoryModel with _$PriceHistoryModel {
  const PriceHistoryModel._();

  const factory PriceHistoryModel({
    required String productName,
    required String unit,
    required List<PricePointModel> points,
  }) = _PriceHistoryModel;

  factory PriceHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$PriceHistoryModelFromJson(json);

  /// Convierte el modelo de datos a la entidad de dominio.
  PriceHistory toEntity() => PriceHistory(
        productName: productName,
        unit: unit,
        points: points.map((p) => p.toEntity()).toList(),
      );
}
