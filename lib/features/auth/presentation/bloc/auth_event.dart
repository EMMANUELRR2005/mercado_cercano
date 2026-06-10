part of 'auth_bloc.dart';

/// Eventos del flujo de autenticación.
sealed class AuthEvent {
  const AuthEvent();
}

/// Disparado por el splash: restaura la sesión guardada (token en storage).
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Solicita el envío del OTP al [phone] (8 dígitos, sin prefijo).
class SendOtpRequested extends AuthEvent {
  const SendOtpRequested(this.phone);

  final String phone;
}

/// Verifica el [otp] recibido. [role] solo se pasa si el flujo ya
/// conoce el rol (normalmente es `null` y el rol se elige después).
class VerifyOtpRequested extends AuthEvent {
  const VerifyOtpRequested({
    required this.phone,
    required this.otp,
    this.role,
  });

  final String phone;
  final String otp;
  final UserRole? role;
}

/// Reenvía el OTP al último teléfono usado y reinicia los intentos.
class ResendOtpRequested extends AuthEvent {
  const ResendOtpRequested();
}

/// El usuario nuevo eligió rol en el selector (post verificación).
class RoleSelected extends AuthEvent {
  const RoleSelected(this.role);

  final UserRole role;
}

/// Cierra la sesión.
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
