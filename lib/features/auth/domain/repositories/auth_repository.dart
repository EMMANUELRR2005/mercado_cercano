import '../../../../shared/domain/entities/user_entity.dart';

/// Resultado de verificar un OTP.
///
/// `isNewUser == true` significa que el usuario aún no tiene rol asignado
/// y la UI debe llevarlo al selector de rol antes de entrar al home.
class VerifyOtpResult {
  const VerifyOtpResult({required this.user, required this.isNewUser});

  final UserEntity user;
  final bool isNewUser;
}

/// Contrato del repositorio de autenticación.
///
/// CONVENCIÓN DE ERRORES (consistente en todo el feature):
/// los métodos devuelven `Future<T>` y LANZAN excepciones
/// (`AppException` del core, `DioException` u [OtpExpiredException]).
/// El [AuthBloc] es el único que las captura y las mapea a `Failure`
/// con `mapAppException` / `mapDioException` para mostrar mensajes
/// en español. No se usa `Either` ni paquetes externos.
abstract class AuthRepository {
  /// Envía un OTP por SMS al número dado (8 dígitos, sin prefijo).
  /// El repositorio agrega el prefijo `+502` antes de llamar a la API.
  Future<void> sendOtp(String phone);

  /// Verifica el OTP. Si es exitoso guarda tokens, userId y (si el usuario
  /// ya tiene rol o se pasó [role]) el rol en SecureStorage.
  Future<VerifyOtpResult> verifyOtp({
    required String phone,
    required String otp,
    UserRole? role,
  });

  /// Asigna el rol elegido a un usuario recién registrado y lo persiste.
  Future<UserEntity> selectRole(UserRole role);

  /// Refresca el par de tokens usando el refresh token guardado.
  Future<void> refreshToken();

  /// Cierra sesión: notifica al backend y limpia el almacenamiento local
  /// (conservando la marca de onboarding completado).
  Future<void> logout();

  /// Restaura la sesión guardada. Devuelve `null` si no hay token.
  Future<UserEntity?> checkAuthStatus();
}
