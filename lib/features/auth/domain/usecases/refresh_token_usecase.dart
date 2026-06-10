import '../repositories/auth_repository.dart';

/// Caso de uso: refrescar el par de tokens de sesión.
class RefreshTokenUsecase {
  const RefreshTokenUsecase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.refreshToken();
}
