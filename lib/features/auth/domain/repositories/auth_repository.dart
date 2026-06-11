import '../../../../shared/domain/entities/user_entity.dart';

/// Resultado de un inicio de sesión.
///
/// `isNewUser == true` significa que el usuario aún no tiene rol asignado
/// y la UI debe llevarlo al selector de rol antes de entrar al home.
class SignInResult {
  const SignInResult({required this.user, required this.isNewUser});

  final UserEntity user;
  final bool isNewUser;
}

/// Contrato del repositorio de autenticación.
///
/// Métodos de acceso: Google (principal), Apple (iOS) y Email/Password.
/// CONVENCIÓN DE ERRORES: los métodos devuelven `Future<T>` y LANZAN
/// `AppException`; el AuthBloc es el único que las captura y mapea a
/// `Failure` (mensajes en español).
///
/// Tras CUALQUIER login exitoso el repositorio persiste la sesión en
/// secure storage: `auth_token`, `user_id` y `user_role` (si ya eligió).
abstract class AuthRepository {
  Future<SignInResult> signInWithGoogle();

  Future<SignInResult> signInWithApple();

  Future<SignInResult> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<SignInResult> signInWithEmail({
    required String email,
    required String password,
  });

  /// Envía el correo de restablecimiento de contraseña.
  Future<void> sendPasswordReset(String email);

  /// Asigna el rol elegido y lo persiste (storage + Firestore).
  Future<UserEntity> selectRole(UserRole role);

  /// Cierra sesión: Firebase + proveedor social + storage local
  /// (conservando la marca de onboarding completado).
  Future<void> logout();

  /// Restaura la sesión guardada. Devuelve `null` si no hay sesión.
  Future<UserEntity?> checkAuthStatus();

  /// `true` mientras la sesión siga activa (`authStateChanges`).
  Stream<bool> watchSessionActive();
}
