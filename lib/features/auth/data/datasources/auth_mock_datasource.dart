import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../domain/auth_exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Datasource simulado: permite usar toda la app SIN backend
/// (`AppConstants.useMockData == true`).
///
/// Reglas del mock:
/// - Acepta cualquier teléfono de 8 dígitos (con o sin prefijo +502).
/// - El único OTP válido es [validOtp] (`123456`).
/// - El OTP "expira" a los `AppConstants.otpExpiryMinutes` minutos.
/// - Los tokens devueltos son `mock_access_token` / `mock_refresh_token`.
/// - Cada llamada simula latencia de red de 800 ms.
class AuthMockDatasource implements AuthRemoteDatasource {
  /// Único código aceptado por el mock.
  static const String validOtp = '123456';

  static const Duration _networkDelay = Duration(milliseconds: 800);

  /// Momento en que se "envió" el OTP por teléfono (para simular expiración).
  final Map<String, DateTime> _otpSentAt = {};

  /// Teléfonos que ya eligieron rol (simula usuarios registrados
  /// durante la sesión de la app).
  final Map<String, UserRole> _registeredRoles = {};

  /// Último teléfono verificado con éxito (lo usa [setRole]).
  String? _lastVerifiedPhone;

  @override
  Future<void> sendOtp(String phone) async {
    await Future<void>.delayed(_networkDelay);

    final digits = _digitsOf(phone);
    if (digits.length != 8) {
      throw const ValidationException('El número debe tener 8 dígitos');
    }
    _otpSentAt[digits] = DateTime.now();
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String otp,
    UserRole? role,
  }) async {
    await Future<void>.delayed(_networkDelay);

    final digits = _digitsOf(phone);

    // Expiración simulada del código.
    final sentAt = _otpSentAt[digits];
    if (sentAt != null &&
        DateTime.now().difference(sentAt) >
            const Duration(minutes: AppConstants.otpExpiryMinutes)) {
      throw const OtpExpiredException();
    }

    if (otp != validOtp) {
      throw const ValidationException(
        'Código incorrecto. Verifica e intenta de nuevo.',
      );
    }

    _lastVerifiedPhone = digits;

    // Si se pasó un rol explícito, el usuario queda registrado con él.
    if (role != null) {
      _registeredRoles[digits] = role;
    }

    final knownRole = _registeredRoles[digits];
    // Usuario nuevo = aún no eligió rol en esta sesión del mock.
    final isNewUser = knownRole == null;

    return AuthResponseModel(
      accessToken: 'mock_access_token',
      refreshToken: 'mock_refresh_token',
      isNewUser: isNewUser,
      user: _buildMockUser(digits, knownRole ?? UserRole.buyer),
    );
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    await Future<void>.delayed(_networkDelay);

    if (refreshToken != 'mock_refresh_token') {
      throw const AuthException('Refresh token inválido', statusCode: 401);
    }

    final digits = _lastVerifiedPhone ?? '55555555';
    return AuthResponseModel(
      accessToken: 'mock_access_token',
      refreshToken: 'mock_refresh_token',
      user: _buildMockUser(digits, _registeredRoles[digits] ?? UserRole.buyer),
    );
  }

  @override
  Future<UserModel> setRole(UserRole role) async {
    await Future<void>.delayed(_networkDelay);

    final digits = _lastVerifiedPhone;
    if (digits == null) {
      throw const AuthException('No hay sesión activa', statusCode: 401);
    }
    // En el mock basta con actualizar el rol en memoria.
    _registeredRoles[digits] = role;
    return _buildMockUser(digits, role);
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(_networkDelay);
    _lastVerifiedPhone = null;
  }

  // -----------------------------------------------------------------------
  // Helpers
  // -----------------------------------------------------------------------

  /// Dígitos locales del número: descarta el código de país si viene
  /// incluido (`+502XXXXXXXX` → `XXXXXXXX`). Sin esto, un número ya
  /// normalizado contaba 11 dígitos y la validación de 8 fallaba.
  String _digitsOf(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length == 11 && digits.startsWith('502')
        ? digits.substring(3)
        : digits;
  }

  UserModel _buildMockUser(String digits, UserRole role) {
    return UserModel(
      id: 'mock_user_$digits',
      phone: '+502$digits',
      role: role.name,
      createdAt: DateTime.now(),
      name: role == UserRole.vendor ? 'Vendedor de prueba' : null,
      rating: role == UserRole.vendor ? 4.5 : null,
      totalRatings: role == UserRole.vendor ? 12 : null,
      isVerified: true,
      subscription: 'free',
    );
  }
}
