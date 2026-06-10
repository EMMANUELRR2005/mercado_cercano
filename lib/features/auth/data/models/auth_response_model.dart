import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

/// Respuesta de `POST /auth/verify-otp` y `POST /auth/refresh`.
///
/// `isNewUser` indica si el usuario acaba de registrarse y todavía no
/// eligió rol (la UI debe llevarlo al selector de rol).
@freezed
abstract class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required String accessToken,
    required String refreshToken,
    required UserModel user,
    @Default(false) bool isNewUser,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
}
