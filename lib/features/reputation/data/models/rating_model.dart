import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/rating_entity.dart';

part 'rating_model.freezed.dart';
part 'rating_model.g.dart';

/// Modelo de datos (JSON ↔ API) de una calificación.
@freezed
abstract class RatingModel with _$RatingModel {
  const RatingModel._();

  const factory RatingModel({
    required String id,
    required String vendorId,
    required String buyerId,
    required double stars,
    required DateTime createdAt,
    String? comment,
  }) = _RatingModel;

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  /// Convierte el modelo de datos a la entidad de dominio.
  RatingEntity toEntity() => RatingEntity(
        id: id,
        vendorId: vendorId,
        buyerId: buyerId,
        stars: stars,
        createdAt: createdAt,
        comment: comment,
      );
}
