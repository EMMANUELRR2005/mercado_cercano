import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/storage_keys.dart';

/// Almacenamiento local propio del feature de auth.
///
/// El `SecureStorageService` del core (solo lectura para este feature)
/// no expone métodos genéricos, así que este datasource maneja las claves
/// adicionales del flujo de auth: la marca de onboarding completado y el
/// teléfono del usuario (para reconstruir la sesión en el splash).
class AuthLocalDatasource {
  AuthLocalDatasource({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const String _phoneKey = 'user_phone';

  /// `true` si el usuario ya vio el onboarding.
  Future<bool> isOnboardingComplete() async {
    final value = await _storage.read(key: StorageKeys.onboardingComplete);
    return value == 'true';
  }

  /// Marca el onboarding como completado.
  Future<void> setOnboardingComplete() =>
      _storage.write(key: StorageKeys.onboardingComplete, value: 'true');

  /// Guarda el teléfono (8 dígitos) del usuario autenticado.
  Future<void> savePhone(String phone) =>
      _storage.write(key: _phoneKey, value: phone);

  /// Teléfono guardado, o `null` si no hay sesión previa.
  Future<String?> getPhone() => _storage.read(key: _phoneKey);

  static const String _hasBeenVendorKey = 'has_been_vendor';
  static const String _hasBeenBuyerKey = 'has_been_buyer';

  /// `true` si el usuario ya estuvo en modo vendedor alguna vez
  /// (para no repetir el onboarding de vendedor).
  Future<bool> hasBeenVendor() async =>
      await _storage.read(key: _hasBeenVendorKey) == 'true';

  Future<void> markHasBeenVendor() =>
      _storage.write(key: _hasBeenVendorKey, value: 'true');

  /// `true` si el usuario ya estuvo en modo comprador alguna vez.
  Future<bool> hasBeenBuyer() async =>
      await _storage.read(key: _hasBeenBuyerKey) == 'true';

  Future<void> markHasBeenBuyer() =>
      _storage.write(key: _hasBeenBuyerKey, value: 'true');
}
