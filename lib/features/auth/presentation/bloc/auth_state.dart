part of 'auth_bloc.dart';

/// Estados del flujo de autenticación.
sealed class AuthState {
  const AuthState();
}

/// Estado inicial, antes de verificar la sesión guardada.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Operación en curso (enviar/verificar OTP, logout, etc.).
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// El OTP fue enviado a [phone] (8 dígitos, sin prefijo).
class OtpSent extends AuthState {
  const OtpSent(this.phone);

  final String phone;
}

/// Sesión activa. Si [isNewUser] es `true`, el usuario aún debe
/// elegir rol en `/auth/role` antes de entrar al home.
class Authenticated extends AuthState {
  const Authenticated(this.user, {this.isNewUser = false});

  final UserEntity user;
  final bool isNewUser;
}

/// Error con mensaje en español listo para la UI. [attemptsLeft] viene
/// poblado cuando el error fue un OTP incorrecto.
class AuthError extends AuthState {
  const AuthError(this.message, {this.attemptsLeft});

  final String message;
  final int? attemptsLeft;
}

/// El código OTP expiró (5 minutos): hay que pedir uno nuevo.
class OtpExpired extends AuthState {
  const OtpExpired();
}

/// Se agotaron los 3 intentos de OTP: hay que solicitar un nuevo código.
class MaxAttemptsReached extends AuthState {
  const MaxAttemptsReached();
}

/// No hay sesión activa.
class Unauthenticated extends AuthState {
  const Unauthenticated();
}
