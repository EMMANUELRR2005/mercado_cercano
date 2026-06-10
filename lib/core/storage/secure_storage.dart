import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

/// Envoltura sobre [FlutterSecureStorage].
///
/// REGLA DE SEGURIDAD: los JWT (access/refresh) se guardan ÚNICAMENTE aquí,
/// nunca en SharedPreferences ni otro almacenamiento sin cifrar.
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Guarda el par de tokens de sesión.
  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await Future.wait([
      _storage.write(key: StorageKeys.accessToken, value: access),
      _storage.write(key: StorageKeys.refreshToken, value: refresh),
    ]);
  }

  Future<String?> getAccessToken() =>
      _storage.read(key: StorageKeys.accessToken);

  Future<String?> getRefreshToken() =>
      _storage.read(key: StorageKeys.refreshToken);

  Future<void> saveUserRole(String role) =>
      _storage.write(key: StorageKeys.userRole, value: role);

  Future<String?> getUserRole() => _storage.read(key: StorageKeys.userRole);

  Future<void> saveUserId(String id) =>
      _storage.write(key: StorageKeys.userId, value: id);

  Future<String?> getUserId() => _storage.read(key: StorageKeys.userId);

  /// Borra todos los datos de sesión (logout / sesión expirada).
  Future<void> clearAll() => _storage.deleteAll();
}
