import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';
import 'api_endpoints.dart';

/// Cliente HTTP central de la app.
///
/// Responsabilidades:
/// - Inyectar `Authorization: Bearer {token}` en cada request.
/// - Refrescar el access token automáticamente ante un 401 y reintentar.
/// - Reintentar con exponential backoff ante un 429 (1s, 2s, 4s, máx 3).
/// - Loguear requests solo en debug.
class DioClient {
  DioClient({
    required this._secureStorage,
    this.onSessionExpired,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {'Accept': 'application/json'},
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  final Dio _dio;
  final SecureStorageService _secureStorage;

  /// Se invoca cuando el refresh token falla: la sesión expiró y la app
  /// debe redirigir al login.
  final void Function()? onSessionExpired;

  /// Acceso directo a Dio para casos avanzados (descargas, cancel tokens).
  Dio get dio => _dio;

  static const int _maxRetries = 3;

  // Evita múltiples refresh simultáneos.
  Completer<bool>? _refreshCompleter;

  // ---------------------------------------------------------------------
  // Interceptores
  // ---------------------------------------------------------------------

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // No inyectar token en endpoints públicos de auth.
    final isAuthEndpoint = options.path == ApiEndpoints.sendOtp ||
        options.path == ApiEndpoints.verifyOtp ||
        options.path == ApiEndpoints.refresh;

    if (!isAuthEndpoint) {
      final token = await _secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    // --- 401: intentar refresh y reintentar el request original ---
    if (statusCode == 401 && err.requestOptions.path != ApiEndpoints.refresh) {
      final alreadyRetried = err.requestOptions.extra['__auth_retried'] == true;
      if (!alreadyRetried) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          try {
            err.requestOptions.extra['__auth_retried'] = true;
            final response = await _retryRequest(err.requestOptions);
            return handler.resolve(response);
          } on DioException catch (retryError) {
            return handler.next(retryError);
          }
        } else {
          // Refresh falló: limpiar sesión y notificar.
          await _secureStorage.clearAll();
          onSessionExpired?.call();
        }
      }
      return handler.next(err);
    }

    // --- 429: exponential backoff (1s, 2s, 4s; máx 3 reintentos) ---
    if (statusCode == 429) {
      final attempt = (err.requestOptions.extra['__retry_count'] as int?) ?? 0;
      if (attempt < _maxRetries) {
        final delay = Duration(seconds: math.pow(2, attempt).toInt());
        await Future<void>.delayed(delay);
        try {
          err.requestOptions.extra['__retry_count'] = attempt + 1;
          final response = await _retryRequest(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (retryError) {
          return handler.next(retryError);
        }
      }
      return handler.next(err);
    }

    handler.next(err);
  }

  // ---------------------------------------------------------------------
  // Refresh token
  // ---------------------------------------------------------------------

  Future<bool> _refreshToken() async {
    // Si ya hay un refresh en curso, esperar su resultado.
    final inFlight = _refreshCompleter;
    if (inFlight != null) return inFlight.future;

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        completer.complete(false);
        return completer.future;
      }

      // Dio limpio para no pasar por los interceptores de esta clase.
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl,
          connectTimeout: AppConstants.connectTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
        ),
      );

      final response = await refreshDio.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data;
      final newAccess = data?['accessToken'] as String?;
      final newRefresh = data?['refreshToken'] as String?;

      if (newAccess == null || newAccess.isEmpty) {
        completer.complete(false);
      } else {
        await _secureStorage.saveTokens(
          access: newAccess,
          refresh: (newRefresh != null && newRefresh.isNotEmpty)
              ? newRefresh
              : refreshToken,
        );
        completer.complete(true);
      }
    } catch (_) {
      completer.complete(false);
    } finally {
      _refreshCompleter = null;
    }

    return completer.future;
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    // Releer el token por si fue refrescado.
    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      requestOptions.headers['Authorization'] = 'Bearer $token';
    }
    return _dio.fetch<dynamic>(requestOptions);
  }

  // ---------------------------------------------------------------------
  // Métodos HTTP de conveniencia
  // ---------------------------------------------------------------------

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
