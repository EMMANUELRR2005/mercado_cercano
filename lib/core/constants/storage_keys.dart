/// Claves usadas en el almacenamiento local.
///
/// REGLA DE SEGURIDAD: los tokens JWT (`accessToken`, `refreshToken`)
/// se guardan ÚNICAMENTE en FlutterSecureStorage, nunca en SharedPreferences.
class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String onboardingComplete = 'onboarding_complete';
}
