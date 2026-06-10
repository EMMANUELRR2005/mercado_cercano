import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Contrato del datasource de autenticación.
///
/// Lo implementan [AuthRemoteDatasourceImpl] (API real) y
/// `AuthMockDatasource` (datos simulados, sin backend).
/// Los métodos lanzan `DioException` / `AppException` ante errores;
/// el BLoC los mapea a `Failure`.
abstract class AuthRemoteDatasource {
  /// `POST /auth/send-otp` con `{phone: "+502XXXXXXXX"}`.
  Future<void> sendOtp(String phone);

  /// `POST /auth/verify-otp` con `{phone, otp, role?}`.
  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String otp,
    UserRole? role,
  });

  /// `POST /auth/refresh` con `{refreshToken}`.
  Future<AuthResponseModel> refreshToken(String refreshToken);

  /// Asigna el rol a un usuario recién registrado.
  Future<UserModel> setRole(UserRole role);

  /// `POST /auth/logout` (con Bearer).
  Future<void> logout();
}

/// Implementación real contra la API de MercadoCercano.
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl({required this._client});

  final DioClient _client;

  @override
  Future<void> sendOtp(String phone) async {
    await _client.post<Map<String, dynamic>>(
      ApiEndpoints.sendOtp,
      data: {'phone': phone},
    );
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String otp,
    UserRole? role,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.verifyOtp,
      data: {
        'phone': phone,
        'otp': otp,
        if (role != null) 'role': role.name,
      },
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía en verify-otp');
    }
    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.refresh,
      data: {'refreshToken': refreshToken},
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía en refresh');
    }
    return AuthResponseModel.fromJson(data);
  }

  @override
  Future<UserModel> setRole(UserRole role) async {
    // Endpoint de asignación de rol post-registro. No está en ApiEndpoints
    // (el core es de solo lectura para este feature); cuando el backend
    // exista debe exponer este path o moverse a ApiEndpoints.
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/set-role',
      data: {'role': role.name},
    );

    final data = response.data;
    if (data == null) {
      throw const ServerException('Respuesta vacía en set-role');
    }
    return UserModel.fromJson(data);
  }

  @override
  Future<void> logout() async {
    await _client.post<Map<String, dynamic>>(ApiEndpoints.logout);
  }
}
