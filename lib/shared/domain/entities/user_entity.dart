import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// Rol del usuario en la app.
enum UserRole { buyer, vendor }

/// Plan de suscripción del usuario.
enum UserSubscription { free, pro, family }

/// Usuario autenticado de MercadoCercano.
///
/// `phone` puede venir vacío: con Google/Apple/Email el teléfono ya no
/// es parte del registro. `loginMethod` es 'google' | 'apple' | 'email'.
@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String phone,
    required UserRole role,
    required DateTime createdAt,
    String? name,
    String? email,
    String? photoUrl,
    String? loginMethod,
    double? rating,
    int? totalRatings,
    bool? isVerified,
    UserSubscription? subscription,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
