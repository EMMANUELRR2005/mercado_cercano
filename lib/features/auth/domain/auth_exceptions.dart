/// Excepciones propias del flujo de autenticación.
///
/// `AppException` del core es `sealed`, por lo que este feature define
/// sus excepciones específicas aparte. El [AuthBloc] las captura
/// explícitamente para emitir estados dedicados (OtpExpired).
library;

/// El código OTP expiró (más de `AppConstants.otpExpiryMinutes` minutos).
class OtpExpiredException implements Exception {
  const OtpExpiredException([
    this.message = 'El código expiró. Solicita uno nuevo.',
  ]);

  final String message;

  @override
  String toString() => 'OtpExpiredException($message)';
}
