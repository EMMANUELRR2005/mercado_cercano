import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_entity.freezed.dart';

/// Calificación que un comprador deja a un vendedor.
///
/// `stars` va de 1.0 a 5.0 (se permiten medias estrellas en display,
/// pero el input del usuario es en estrellas enteras).
@freezed
abstract class RatingEntity with _$RatingEntity {
  const factory RatingEntity({
    required String id,
    required String vendorId,
    required String buyerId,
    required double stars,
    required DateTime createdAt,
    String? comment,
  }) = _RatingEntity;
}
