/// Constantes globales de MercadoCercano.
///
/// La app corre contra Firebase REAL (Auth, Firestore, Storage).
class AppConstants {
  AppConstants._();

  /// Versión de la app (mantener en sync con pubspec.yaml).
  static const String appVersion = '0.1.0';

  // --- API ---
  static const String baseUrl = 'https://api.mercadocercano.gt/v1';
  static const String wsUrl = 'ws://api.mercadocercano.gt/ws/map';

  /// Backend de autenticación: `true` → Firebase Auth;
  /// `false` → API REST propia (DioClient).
  static const bool useFirebaseAuth = true;

  /// Backend de datos:
  /// `true` → Cloud Firestore (colecciones users/vendors/products/
  /// price_reports/ratings/price_alerts);
  /// `false` → API REST propia (DioClient).
  ///
  /// Las reglas de Firestore exigen usuario autenticado (Google, Apple
  /// o Email/Password habilitados en la consola).
  static const bool useFirestore = true;

  // --- Google Maps ---
  /// API key de Google Maps para usos desde Dart (Static Maps, Places…).
  ///
  /// Los SDKs nativos NO la leen de aquí: Android la toma de
  /// `android/secrets.properties` (manifest placeholder) e iOS de
  /// `ios/Flutter/Secrets.xcconfig`. Para usos Dart, inyéctala en build
  /// con `--dart-define=MAPS_API_KEY=...`. Sin valor queda vacía (no se
  /// hardcodea ninguna key en el repo).
  static const String googleMapsApiKey = String.fromEnvironment(
    'MAPS_API_KEY',
  );

  // --- Legal (App Store / Google Play exigen acceso desde la app) ---
  /// URLs de Política de Privacidad y Términos. PLACEHOLDERS: reemplázalas
  /// por las reales antes de publicar (en build con
  /// `--dart-define=PRIVACY_URL=...` / `--dart-define=TERMS_URL=...` o
  /// editando el dominio aquí). Ver MIGRATION.md.
  static const String privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_URL',
    defaultValue: 'https://mercadocercano.gt/privacidad',
  );
  static const String termsOfServiceUrl = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: 'https://mercadocercano.gt/terminos',
  );

  /// Correo de soporte/contacto (para borrado de datos y dudas legales).
  static const String supportEmail = 'soporte@mercadocercano.gt';

  // --- Timeouts ---
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  // --- Paginación ---
  static const int pageSize = 20;

  // --- OTP ---
  static const int otpLength = 6;
  static const int otpResendSeconds = 60;
  static const int otpExpiryMinutes = 5;
  static const int maxOtpAttempts = 3;

  // --- Geolocalización / búsqueda ---
  static const double defaultSearchRadiusKm = 5.0;

  /// Horas de vigencia de un producto publicado antes de vencer.
  static const int productExpiryHours = 24;

  /// Centro por defecto: Ciudad de Guatemala.
  static const double guatemalaCityLat = 14.6349;
  static const double guatemalaCityLng = -90.5069;
}
