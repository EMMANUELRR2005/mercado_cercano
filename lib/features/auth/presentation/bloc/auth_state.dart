part of 'auth_bloc.dart';

/// Estados del flujo de autenticación.
sealed class AuthState {
  const AuthState();
}

/// Estado inicial, antes de verificar la sesión guardada.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Operación en curso (login, registro, logout, etc.).
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Sesión activa. Si [isNewUser] es `true`, el usuario aún debe
/// elegir rol en `/auth/role` antes de entrar al home.
class Authenticated extends AuthState {
  const Authenticated(this.user, {this.isNewUser = false});

  final UserEntity user;
  final bool isNewUser;
}

/// Error con mensaje en español listo para la UI.
class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;
}

/// El correo de restablecimiento de contraseña fue enviado a [email].
class PasswordResetSent extends AuthState {
  const PasswordResetSent(this.email);

  final String email;
}

/// No hay sesión activa.
class Unauthenticated extends AuthState {
  const Unauthenticated();
}
