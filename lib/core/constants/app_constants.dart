/// Constantes globales de MercadoCercano.
///
/// `useMockData` es el flag global: cuando es `true`, toda la app
/// funciona con datos simulados (sin backend real).
class AppConstants {
  AppConstants._();

  // --- API ---
  static const String baseUrl = 'https://api.mercadocercano.gt/v1';
  static const String wsUrl = 'ws://api.mercadocercano.gt/ws/map';

  /// Flag global: si es true, toda la app usa mock data en vez del backend.
  static const bool useMockData = true;

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
