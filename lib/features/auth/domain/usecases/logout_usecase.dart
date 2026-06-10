import '../repositories/auth_repository.dart';

/// Caso de uso: cerrar la sesión del usuario.
class LogoutUsecase {
  const LogoutUsecase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.logout();
}
