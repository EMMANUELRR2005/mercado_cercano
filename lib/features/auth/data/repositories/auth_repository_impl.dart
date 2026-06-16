import '../../../../core/storage/secure_storage.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_response_model.dart';

/// Implementación del repositorio de autenticación (Firebase).
///
/// Tras cualquier login exitoso guarda en secure storage:
/// `auth_token` (ID token), `user_id` (uid) y `user_role` (si el usuario
/// ya eligió rol). El rol de un usuario nuevo se persiste hasta que pasa
/// por el selector ([selectRole]).
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._datasource,
    required this._secureStorage,
    required this._local,
  });

  final AuthRemoteDatasource _datasource;
  final SecureStorageService _secureStorage;
  final AuthLocalDatasource _local;

  // -------------------------------------------------------------------
  // Métodos de acceso
  // -------------------------------------------------------------------

  @override
  Future<SignInResult> signInWithGoogle() async {
    return _persistSession(await _datasource.signInWithGoogle());
  }

  @override
  Future<SignInResult> signInWithApple() async {
    return _persistSession(await _datasource.signInWithApple());
  }

  @override
  Future<SignInResult> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    return _persistSession(
      await _datasource.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<SignInResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _persistSession(
      await _datasource.signInWithEmail(email: email, password: password),
    );
  }

  @override
  Future<void> sendPasswordReset(String email) {
    return _datasource.sendPasswordReset(email);
  }

  // -------------------------------------------------------------------
  // Rol / sesión
  // -------------------------------------------------------------------

  @override
  Future<UserEntity> selectRole(UserRole role) async {
    final model = await _datasource.setRole(role);
    final user = model.toEntity();
    await _secureStorage.saveUserRole(user.role.name);
    return user;
  }

  @override
  Future<void> logout() async {
    // `clearAll` borra TODO el secure storage, incluida la marca de
    // onboarding: la leemos antes y la restauramos para que el usuario
    // no vuelva a ver el onboarding tras cerrar sesión.
    final onboardingDone = await _local.isOnboardingComplete();

    try {
      await _datasource.logout();
    } catch (_) {
      // El logout local debe completarse aunque el backend falle.
    }

    await _secureStorage.clearAll();
    if (onboardingDone) {
      await _local.setOnboardingComplete();
    }
  }

  @override
  Future<void> deleteAccount() async {
    // Conservar la marca de onboarding como en [logout]: borrar la cuenta
    // no debe re-mostrar el onboarding en el dispositivo.
    final onboardingDone = await _local.isOnboardingComplete();

    // Si el datasource lanza (p. ej. reautenticación cancelada), NO se
    // limpia la sesión local: el usuario sigue dentro y puede reintentar.
    await _datasource.deleteAccount();

    await _secureStorage.clearAll();
    if (onboardingDone) {
      await _local.setOnboardingComplete();
    }
  }

  @override
  Future<UserEntity?> checkAuthStatus() async {
    // 1) Restauración por Firebase (currentUser + silent refresh).
    try {
      final restored = await _datasource.restoreSession();
      if (restored != null) {
        final result = await _persistSession(restored);
        return result.isNewUser ? null : result.user;
      }
    } catch (_) {
      // Silent refresh fallido (p. ej. sin red): caer a los datos
      // guardados localmente en vez de cerrar la sesión.
    }

    // 2) Fallback: reconstruye la sesión desde el almacenamiento local.
    final token = await _secureStorage.getAccessToken();
    if (token == null || token.isEmpty) return null;

    final roleName = await _secureStorage.getUserRole();
    if (roleName == null || roleName.isEmpty) return null;

    final userId = await _secureStorage.getUserId();
    return UserEntity(
      id: userId ?? 'unknown',
      phone: '',
      role: UserRole.values.firstWhere(
        (r) => r.name == roleName,
        orElse: () => UserRole.buyer,
      ),
      // No persistimos la fecha de registro; placeholder local.
      createdAt: DateTime.now(),
    );
  }

  @override
  Stream<bool> watchSessionActive() => _datasource.watchSessionActive();

  // -------------------------------------------------------------------
  // Internos
  // -------------------------------------------------------------------

  /// Persiste tokens/uid/rol en secure storage y arma el resultado.
  Future<SignInResult> _persistSession(AuthResponseModel response) async {
    await _secureStorage.saveTokens(
      access: response.accessToken,
      refresh: response.refreshToken,
    );
    final user = response.user.toEntity();
    await _secureStorage.saveUserId(user.id);
    if (!response.isNewUser) {
      await _secureStorage.saveUserRole(user.role.name);
    }
    return SignInResult(user: user, isNewUser: response.isNewUser);
  }
}
