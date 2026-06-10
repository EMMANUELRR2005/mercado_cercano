/// Excepciones internas de la capa de datos.
///
/// Estas excepciones se lanzan en datasources/repositorios y se mapean
/// a [Failure] antes de llegar a la UI.
sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  /// Mensaje técnico (para logs, no para mostrar al usuario).
  final String message;

  /// Código HTTP asociado, si aplica.
  final int? statusCode;

  @override
  String toString() => '$runtimeType(message: $message, statusCode: $statusCode)';
}

/// Error devuelto por el servidor (4xx/5xx no manejados específicamente).
class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

/// Sin conexión, timeout o fallo de red.
class NetworkException extends AppException {
  const NetworkException(super.message, {super.statusCode});
}

/// Error de lectura/escritura en caché local.
class CacheException extends AppException {
  const CacheException(super.message, {super.statusCode});
}

/// Error de autenticación (401/403, sesión expirada, OTP inválido).
class AuthException extends AppException {
  const AuthException(super.message, {super.statusCode});
}

/// Datos inválidos (422 o validación local).
class ValidationException extends AppException {
  const ValidationException(super.message, {super.statusCode});
}
