import '../../../../core/errors/app_exception.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementación de [AuthRepository].
///
/// El datasource inyectado decide mock vs API real (ver
/// `authRemoteDatasourceProvider`, que elige según
/// `AppConstants.useMockData`).
///
/// CONVENCIÓN DE ERRORES: los métodos lanzan excepciones
/// (`AppException` / `DioException` / `OtpExpiredException`);
/// el `AuthBloc` las mapea a `Failure` para la UI.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._datasource,
    required this._secureStorage,
    required AuthLocalDatasource localDatasource,
  }) : _local = localDatasource;

  final AuthRemoteDatasource _datasource;
  final SecureStorageService _secureStorage;
  final AuthLocalDatasource _local;

  /// Normaliza el teléfono a formato E.164 de Guatemala: `+502XXXXXXXX`.
  String _normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    // Si ya viene con el código de país (502XXXXXXXX), no duplicarlo.
    final local = digits.length == 11 && digits.startsWith('502')
        ? digits.substring(3)
        : digits;
    return '+502$local';
  }

  @override
  Future<void> sendOtp(String phone) {
    return _datasource.sendOtp(_normalizePhone(phone));
  }

  @override
  Future<VerifyOtpResult> verifyOtp({
    required String phone,
    required String otp,
    UserRole? role,
  }) async {
    final response = await _datasource.verifyOtp(
      phone: _normalizePhone(phone),
      otp: otp,
      role: role,
    );

    final user = response.user.toEntity();

    // Sesión verificada: persistir tokens e identidad.
    await _secureStorage.saveTokens(
      access: response.accessToken,
      refresh: response.refreshToken,
    );
    await _secureStorage.saveUserId(user.id);
    await _local.savePhone(phone.replaceAll(RegExp(r'\D'), ''));

    // Solo guardamos el rol si el usuario ya lo tiene definido
    // (usuario existente o rol pasado explícitamente). Si es nuevo,
    // el rol queda pendiente hasta que pase por el selector de rol.
    final isNewUser = response.isNewUser && role == null;
    if (!isNewUser) {
      await _secureStorage.saveUserRole(user.role.name);
    }

    return VerifyOtpResult(user: user, isNewUser: isNewUser);
  }

  @override
  Future<UserEntity> selectRole(UserRole role) async {
    final model = await _datasource.setRole(role);
    final user = model.toEntity();
    await _secureStorage.saveUserRole(user.role.name);
    return user;
  }

  @override
  Future<void> refreshToken() async {
    final stored = await _secureStorage.getRefreshToken();
    if (stored == null || stored.isEmpty) {
      throw const AuthException('No hay refresh token guardado',
          statusCode: 401);
    }

    final response = await _datasource.refreshToken(stored);
    await _secureStorage.saveTokens(
      access: response.accessToken,
      refresh: response.refreshToken,
    );
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
  Future<UserEntity?> checkAuthStatus() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null || token.isEmpty) return null;

    // Reconstruye la sesión desde el almacenamiento local. Si el usuario
    // nunca eligió rol (sesión incompleta), se trata como no autenticado.
    final roleName = await _secureStorage.getUserRole();
    if (roleName == null || roleName.isEmpty) return null;

    final userId = await _secureStorage.getUserId();
    final phone = await _local.getPhone();

    return UserEntity(
      id: userId ?? 'unknown',
      phone: phone != null ? '+502$phone' : '',
      role: UserRole.values.firstWhere(
        (r) => r.name == roleName,
        orElse: () => UserRole.buyer,
      ),
      // No persistimos la fecha de registro; placeholder local.
      createdAt: DateTime.now(),
    );
  }
}
