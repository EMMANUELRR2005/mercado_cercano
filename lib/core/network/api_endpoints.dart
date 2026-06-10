/// Endpoints de la API de MercadoCercano (relativos a `AppConstants.baseUrl`).
class ApiEndpoints {
  ApiEndpoints._();

  // --- Auth ---
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';

  // --- Productos (comprador) ---
  static const String products = '/products';
  static const String productsSearch = '/products/search';

  /// `/products/:id`
  static String productById(String id) => '/products/$id';

  // --- Vendedores ---
  /// `/vendors/:id`
  static String vendorById(String id) => '/vendors/$id';
  static const String vendorsNearby = '/vendors/nearby';

  // --- Panel del vendedor ---
  static const String vendorProducts = '/vendor/products';
  static const String vendorStats = '/vendor/stats';

  // --- Precios ---
  static const String pricesIndex = '/prices/index';

  /// `/prices/history/:product`
  static String pricesHistory(String product) => '/prices/history/$product';
  static const String pricesAlerts = '/prices/alerts';
  static const String pricesReport = '/prices/report';

  // --- Calificaciones y reportes ---
  static const String ratings = '/ratings';
  static const String reportsFraud = '/reports/fraud';
}
