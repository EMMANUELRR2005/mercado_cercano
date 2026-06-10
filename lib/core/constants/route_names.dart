/// Nombres y paths de todas las rutas de la app.
///
/// Convención: `RouteNames.x` es el nombre (para `context.goNamed`)
/// y `RouteNames.xPath` es el path registrado en GoRouter.
class RouteNames {
  RouteNames._();

  // --- Splash / Onboarding ---
  static const String splash = 'splash';
  static const String splashPath = '/';

  static const String onboarding = 'onboarding';
  static const String onboardingPath = '/onboarding';

  // --- Auth ---
  static const String authPhone = 'authPhone';
  static const String authPhonePath = '/auth/phone';

  static const String authOtp = 'authOtp';
  static const String authOtpPath = '/auth/otp';

  static const String authRole = 'authRole';
  static const String authRolePath = '/auth/role';

  // --- Buyer ---
  static const String buyerHome = 'buyerHome';
  static const String buyerHomePath = '/buyer/home';

  static const String buyerMap = 'buyerMap';
  static const String buyerMapPath = '/buyer/map';

  static const String buyerSearch = 'buyerSearch';
  static const String buyerSearchPath = '/buyer/search';

  static const String buyerProductDetail = 'buyerProductDetail';
  static const String buyerProductDetailPath = '/buyer/product/:id';

  static const String buyerVendorProfile = 'buyerVendorProfile';
  static const String buyerVendorProfilePath = '/buyer/vendor/:id';

  static const String buyerPriceIndex = 'buyerPriceIndex';
  static const String buyerPriceIndexPath = '/buyer/price-index';

  static const String buyerPriceHistory = 'buyerPriceHistory';
  static const String buyerPriceHistoryPath = '/buyer/price-history/:product';

  static const String buyerAlerts = 'buyerAlerts';
  static const String buyerAlertsPath = '/buyer/alerts';

  // --- Vendor ---
  static const String vendorHome = 'vendorHome';
  static const String vendorHomePath = '/vendor/home';

  static const String vendorPublish = 'vendorPublish';
  static const String vendorPublishPath = '/vendor/publish';

  static const String vendorCatalog = 'vendorCatalog';
  static const String vendorCatalogPath = '/vendor/catalog';

  static const String vendorStats = 'vendorStats';
  static const String vendorStatsPath = '/vendor/stats';

  static const String vendorEdit = 'vendorEdit';
  static const String vendorEditPath = '/vendor/edit/:productId';

  // --- Shared ---
  static const String reportPrice = 'reportPrice';
  static const String reportPricePath = '/shared/report-price';

  static const String rating = 'rating';
  static const String ratingPath = '/shared/rating/:vendorId';

  static const String settings = 'settings';
  static const String settingsPath = '/shared/settings';
}
