import '../../../../shared/domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso: verificar el código OTP e iniciar sesión.
class VerifyOtpUsecase {
  const VerifyOtpUsecase(this._repository);

  final AuthRepository _repository;

  Future<VerifyOtpResult> call({
    required String phone,
    required String otp,
    UserRole? role,
  }) {
    return _repository.verifyOtp(phone: phone, otp: otp, role: role);
  }
}
