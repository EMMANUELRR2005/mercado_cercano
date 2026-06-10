/// Failures que llegan a la capa de presentación.
///
/// `message` siempre es user-friendly y EN ESPAÑOL: se puede mostrar
/// directamente en la UI (snackbars, estados de error, etc.).
sealed class Failure {
  const Failure(this.message, {this.statusCode});

  /// Mensaje listo para mostrar al usuario (en español).
  final String message;

  /// Código HTTP asociado, si aplica.
  final int? statusCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          other.runtimeType == runtimeType &&
          other.message == message &&
          other.statusCode == statusCode;

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode);

  @override
  String toString() => '$runtimeType(message: $message, statusCode: $statusCode)';
}

/// Error del servidor.
class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Error del servidor. Intenta de nuevo más tarde.',
  ]);

  const ServerFailure.withCode(super.message, {super.statusCode});
}

/// Sin conexión a internet.
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Sin conexión a internet. Revisa tu señal e intenta de nuevo.',
  ]);
}

/// Error de caché local.
class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'No se pudieron cargar los datos guardados.',
  ]);
}

/// Error de autenticación / sesión.
class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Tu sesión expiró. Inicia sesión de nuevo.',
  ]);

  const AuthFailure.withCode(super.message, {super.statusCode});
}

/// Datos inválidos.
class ValidationFailure extends Failure {
  const ValidationFailure([
    super.message = 'Los datos ingresados no son válidos.',
  ]);
}
