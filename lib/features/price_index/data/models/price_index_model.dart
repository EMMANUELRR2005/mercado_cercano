import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/price_entities.dart';

part 'price_index_model.freezed.dart';
part 'price_index_model.g.dart';

/// Modelo de datos (JSON ↔ API) del índice de precios de un producto.
@freezed
abstract class PriceIndexModel with _$PriceIndexModel {
  const PriceIndexModel._();

  const factory PriceIndexModel({
    required String productName,
    required String unit,
    required double averagePrice,
    required double minPrice,
    required double maxPrice,
    required int reportCount,
    required double changeVsYesterday,
    required String zone,
  }) = _PriceIndexModel;

  factory PriceIndexModel.fromJson(Map<String, dynamic> json) =>
      _$PriceIndexModelFromJson(json);

  /// Convierte el modelo de datos a la entidad de dominio.
  PriceIndex toEntity() => PriceIndex(
        productName: productName,
        unit: unit,
        averagePrice: averagePrice,
        minPrice: minPrice,
        maxPrice: maxPrice,
        reportCount: reportCount,
        changeVsYesterday: changeVsYesterday,
        zone: zone,
      );
}
