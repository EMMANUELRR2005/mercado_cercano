import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// Rol del usuario en la app.
enum UserRole { buyer, vendor }

/// Plan de suscripción del usuario.
enum UserSubscription { free, pro, family }

/// Usuario autenticado de MercadoCercano.
@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String phone,
    required UserRole role,
    required DateTime createdAt,
    String? name,
    double? rating,
    int? totalRatings,
    bool? isVerified,
    UserSubscription? subscription,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
