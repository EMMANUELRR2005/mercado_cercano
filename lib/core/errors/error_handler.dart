import 'package:dio/dio.dart';

import 'app_exception.dart';
import 'failure.dart';

/// Mapea una [DioException] a un [Failure] con mensaje en español.
Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure(
        'Sin conexión estable. Revisa tu señal e intenta de nuevo.',
      );
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.cancel:
      return const NetworkFailure('La solicitud fue cancelada.');
    case DioExceptionType.badCertificate:
      return const NetworkFailure('Conexión no segura. Intenta de nuevo.');
    case DioExceptionType.badResponse:
      return _mapStatusCode(e);
    case DioExceptionType.unknown:
      // Errores de socket / DNS suelen llegar como unknown.
      return const NetworkFailure();
  }
}

Failure _mapStatusCode(DioException e) {
  final statusCode = e.response?.statusCode ?? 0;

  if (statusCode == 401 || statusCode == 403) {
    return AuthFailure.withCode(
      statusCode == 401
          ? 'Tu sesión expiró. Inicia sesión de nuevo.'
          : 'No tienes permiso para realizar esta acción.',
      statusCode: statusCode,
    );
  }

  if (statusCode >= 500) {
    return ServerFailure.withCode(
      'Error del servidor. Intenta de nuevo más tarde.',
      statusCode: statusCode,
    );
  }

  if (statusCode >= 400) {
    // Si el body trae un mensaje, lo usamos; si no, mensaje genérico.
    final bodyMessage = _extractBodyMessage(e.response?.data);
    return ServerFailure.withCode(
      bodyMessage ?? 'No se pudo completar la solicitud. Intenta de nuevo.',
      statusCode: statusCode,
    );
  }

  return ServerFailure.withCode(
    'Error inesperado. Intenta de nuevo.',
    statusCode: statusCode,
  );
}

String? _extractBodyMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    final message = data['message'] ?? data['error'] ?? data['detail'];
    if (message is String && message.isNotEmpty) return message;
  }
  return null;
}

/// Mapea una [AppException] de la capa de datos a un [Failure] para la UI.
Failure mapAppException(AppException e) {
  return switch (e) {
    ServerException() => ServerFailure.withCode(
        'Error del servidor. Intenta de nuevo más tarde.',
        statusCode: e.statusCode,
      ),
    NetworkException() => const NetworkFailure(),
    CacheException() => const CacheFailure(),
    AuthException() => AuthFailure.withCode(
        'Tu sesión expiró. Inicia sesión de nuevo.',
        statusCode: e.statusCode,
      ),
    ValidationException() => ValidationFailure(e.message),
  };
}
