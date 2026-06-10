import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Modelo de usuario de la capa de datos (espejo del JSON de la API).
///
/// `role` y `subscription` viajan como String para tolerar valores
/// desconocidos del backend; [toEntity] los mapea a los enums del dominio.
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String phone,
    required String role,
    required DateTime createdAt,
    String? name,
    double? rating,
    int? totalRatings,
    bool? isVerified,
    String? subscription,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convierte el modelo de datos a la entidad de dominio compartida.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      phone: phone,
      role: UserRole.values.firstWhere(
        (r) => r.name == role,
        orElse: () => UserRole.buyer,
      ),
      createdAt: createdAt,
      name: name,
      rating: rating,
      totalRatings: totalRatings,
      isVerified: isVerified,
      subscription: subscription == null
          ? null
          : UserSubscription.values.firstWhere(
              (s) => s.name == subscription,
              orElse: () => UserSubscription.free,
            ),
    );
  }
}
