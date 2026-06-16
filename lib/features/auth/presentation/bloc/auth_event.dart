part of 'auth_bloc.dart';

/// Eventos del flujo de autenticación.
sealed class AuthEvent {
  const AuthEvent();
}

/// Disparado por el splash: restaura la sesión guardada.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Login con Google (método principal).
class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

/// Login con Apple (solo iOS).
class AppleSignInRequested extends AuthEvent {
  const AppleSignInRequested();
}

/// Registro con email y contraseña.
class EmailSignUpRequested extends AuthEvent {
  const EmailSignUpRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

/// Inicio de sesión con email y contraseña.
class EmailSignInRequested extends AuthEvent {
  const EmailSignInRequested({required this.email, required this.password});

  final String email;
  final String password;
}

/// "¿Olvidaste tu contraseña?": envía el correo de restablecimiento.
class PasswordResetRequested extends AuthEvent {
  const PasswordResetRequested(this.email);

  final String email;
}

/// El usuario nuevo eligió rol en el selector (post login).
class RoleSelected extends AuthEvent {
  const RoleSelected(this.role);

  final UserRole role;
}

/// Cierra la sesión.
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Borra la cuenta del usuario (datos + cuenta de Auth). Requisito de
/// App Store / Google Play. Al completarse, emite [Unauthenticated].
class AccountDeletionRequested extends AuthEvent {
  const AccountDeletionRequested();
}

/// `authStateChanges` reportó que la sesión ya no existe
/// (token revocado, usuario eliminado): cerrar la sesión local.
class SessionExpiredExternally extends AuthEvent {
  const SessionExpiredExternally();
}
