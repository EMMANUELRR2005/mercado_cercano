import '../repositories/auth_repository.dart';

/// Caso de uso: enviar el código OTP al teléfono del usuario.
class SendOtpUsecase {
  const SendOtpUsecase(this._repository);

  final AuthRepository _repository;

  /// [phone]: 8 dígitos sin prefijo (el repositorio agrega +502).
  Future<void> call(String phone) => _repository.sendOtp(phone);
}
