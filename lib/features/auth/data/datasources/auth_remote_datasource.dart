import '../../../../shared/domain/entities/user_entity.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Contrato del datasource de autenticación.
///
/// Métodos de acceso: Google Sign-In (principal), Apple Sign-In (iOS) y
/// Email/Password (respaldo). Lo implementa `AuthFirebaseDatasource`.
/// Los métodos lanzan `AppException` ante errores; el BLoC los mapea a
/// `Failure` con mensajes en español.
abstract class AuthRemoteDatasource {
  /// Login con Google (método principal).
  Future<AuthResponseModel> signInWithGoogle();

  /// Login con Apple (solo iOS).
  Future<AuthResponseModel> signInWithApple();

  /// Registro con email y contraseña (envía email de verificación).
  Future<AuthResponseModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  /// Inicio de sesión con email y contraseña.
  Future<AuthResponseModel> signInWithEmail({
    required String email,
    required String password,
  });

  /// Envía el correo de restablecimiento de contraseña.
  Future<void> sendPasswordReset(String email);

  /// Asigna el rol a un usuario que aún no lo eligió.
  Future<UserModel> setRole(UserRole role);

  /// Cierra la sesión (Firebase + proveedor social).
  Future<void> logout();

  /// Restaura la sesión persistida (silent refresh del ID token).
  /// `null` = no hay sesión restaurable por esta vía.
  Future<AuthResponseModel?> restoreSession();

  /// `true` mientras la sesión siga activa (`authStateChanges`).
  Stream<bool> watchSessionActive();
}
