import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_entities.freezed.dart';
part 'price_entities.g.dart';

/// Índice de precios de un producto en una zona (la "canasta básica" viva).
@freezed
abstract class PriceIndex with _$PriceIndex {
  const factory PriceIndex({
    required String productName,
    required String unit,
    required double averagePrice,
    required double minPrice,
    required double maxPrice,
    required int reportCount,

    /// Cambio porcentual vs. ayer (puede ser negativo).
    required double changeVsYesterday,
    required String zone,
  }) = _PriceIndex;

  factory PriceIndex.fromJson(Map<String, dynamic> json) =>
      _$PriceIndexFromJson(json);
}

/// Punto de la serie histórica de precios.
@freezed
abstract class PricePoint with _$PricePoint {
  const factory PricePoint({
    required DateTime date,
    required double price,
    double? zoneAverage,
  }) = _PricePoint;

  factory PricePoint.fromJson(Map<String, dynamic> json) =>
      _$PricePointFromJson(json);
}

/// Historial de precios de un producto.
@freezed
abstract class PriceHistory with _$PriceHistory {
  const factory PriceHistory({
    required String productName,
    required String unit,
    required List<PricePoint> points,
  }) = _PriceHistory;

  factory PriceHistory.fromJson(Map<String, dynamic> json) =>
      _$PriceHistoryFromJson(json);
}

/// Alerta de precio configurada por el comprador.
@freezed
abstract class PriceAlert with _$PriceAlert {
  const factory PriceAlert({
    required String id,
    required String productName,
    required double targetPrice,
    required bool isActive,
    required DateTime createdAt,
  }) = _PriceAlert;

  factory PriceAlert.fromJson(Map<String, dynamic> json) =>
      _$PriceAlertFromJson(json);
}
