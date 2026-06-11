import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/phone_input_screen.dart';
import '../../features/auth/presentation/screens/role_selector_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/buyer/presentation/screens/buyer_home_screen.dart';
import '../../features/buyer/presentation/screens/category_search_screen.dart';
import '../../features/buyer/presentation/screens/product_detail_screen.dart';
import '../../features/buyer/presentation/screens/report_price_screen.dart';
import '../../features/buyer/presentation/screens/vendor_profile_screen.dart';
import '../../features/map/presentation/screens/map_screen.dart';
import '../../features/price_index/presentation/screens/price_alerts_screen.dart';
import '../../features/price_index/presentation/screens/price_history_screen.dart';
import '../../features/price_index/presentation/screens/price_index_screen.dart';
import '../../features/reputation/presentation/screens/rating_screen.dart';
import '../../features/vendor/presentation/screens/edit_product_screen.dart';
import '../../features/vendor/presentation/screens/my_catalog_screen.dart';
import '../../features/vendor/presentation/screens/publish_product_screen.dart';
import '../../features/vendor/presentation/screens/vendor_setup_screen.dart';
import '../../features/vendor/presentation/screens/vendor_home_screen.dart';
import '../../features/vendor/presentation/screens/vendor_stats_screen.dart';
import '../../shared/domain/entities/product_entity.dart';
import '../../shared/screens/settings_screen.dart';
import '../constants/route_names.dart';

/// Construye el GoRouter de la app con todas las pantallas reales.
///
/// Lógica de redirect:
/// - Sin token y la ruta NO es auth/onboarding/splash → `/auth/phone`.
/// - Con token pero SIN rol (usuario nuevo) → `/auth/role`.
/// - Con token y rol, en una ruta de auth → home según rol
///   (buyer → `/buyer/home`, vendor → `/vendor/home`).
GoRouter buildRouter({
  required Listenable refreshListenable,
  required String? Function() getToken,
  required String? Function() getRole,
  required bool Function() isOnboardingComplete,
}) {
  return GoRouter(
    initialLocation: RouteNames.splashPath,
    refreshListenable: refreshListenable,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final token = getToken();
      final hasToken = token != null && token.isNotEmpty;
      final location = state.matchedLocation;

      final isSplash = location == RouteNames.splashPath;
      final isOnboarding = location == RouteNames.onboardingPath;
      final isAuthRoute = location.startsWith('/auth');

      if (!hasToken) {
        // Sin sesión: solo se permiten splash, onboarding y auth.
        if (isSplash || isOnboarding || isAuthRoute) return null;
        return RouteNames.authPhonePath;
      }

      final role = getRole();

      // Usuario nuevo autenticado pero sin rol: debe elegirlo primero.
      if (role == null) {
        return location == RouteNames.authRolePath
            ? null
            : RouteNames.authRolePath;
      }

      // Con sesión y rol: no tiene sentido volver al flujo de auth.
      if (isAuthRoute || isSplash) {
        return role == 'vendor'
            ? RouteNames.vendorHomePath
            : RouteNames.buyerHomePath;
      }

      // Cada rol vive en su área (las rutas /shared/* quedan fuera del
      // guard). Si el rol cambia en caliente, el refreshListenable
      // reevalúa esto y reubica al usuario.
      if (role == 'buyer' && location.startsWith('/vendor')) {
        return RouteNames.buyerHomePath;
      }
      if (role == 'vendor' && location.startsWith('/buyer')) {
        return RouteNames.vendorHomePath;
      }

      return null;
    },
    routes: [
      // --- Splash / Onboarding / Auth (top-level) ---
      GoRoute(
        path: RouteNames.splashPath,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboardingPath,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.authPhonePath,
        name: RouteNames.authPhone,
        builder: (context, state) => const PhoneInputScreen(),
      ),
      GoRoute(
        path: RouteNames.authOtpPath,
        name: RouteNames.authOtp,
        builder: (context, state) => OtpVerificationScreen(
          phone: state.uri.queryParameters['phone'] ?? '',
        ),
      ),
      GoRoute(
        path: RouteNames.authRolePath,
        name: RouteNames.authRole,
        builder: (context, state) => const RoleSelectorScreen(),
      ),

      // --- Shell del comprador (bottom nav) ---
      ShellRoute(
        builder: (context, state, child) => _BuyerShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.buyerHomePath,
            name: RouteNames.buyerHome,
            builder: (context, state) => const BuyerHomeScreen(),
          ),
          GoRoute(
            path: RouteNames.buyerMapPath,
            name: RouteNames.buyerMap,
            builder: (context, state) => const MapScreen(),
          ),
          GoRoute(
            path: RouteNames.buyerSearchPath,
            name: RouteNames.buyerSearch,
            builder: (context, state) {
              final categoryName = state.uri.queryParameters['category'];
              final category = ProductCategory.values
                  .where((c) => c.name == categoryName)
                  .firstOrNull;
              return CategorySearchScreen(
                query: state.uri.queryParameters['q'],
                category: category,
              );
            },
          ),
          GoRoute(
            path: RouteNames.buyerProductDetailPath,
            name: RouteNames.buyerProductDetail,
            builder: (context, state) => ProductDetailScreen(
              productId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: RouteNames.buyerVendorProfilePath,
            name: RouteNames.buyerVendorProfile,
            builder: (context, state) => VendorProfileScreen(
              vendorId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: RouteNames.buyerPriceIndexPath,
            name: RouteNames.buyerPriceIndex,
            builder: (context, state) => const PriceIndexScreen(),
          ),
          GoRoute(
            path: RouteNames.buyerPriceHistoryPath,
            name: RouteNames.buyerPriceHistory,
            builder: (context, state) => PriceHistoryScreen(
              productName: state.pathParameters['product'] ?? '',
            ),
          ),
          GoRoute(
            path: RouteNames.buyerAlertsPath,
            name: RouteNames.buyerAlerts,
            builder: (context, state) => const PriceAlertsScreen(),
          ),
        ],
      ),

      // --- Shell del vendedor (bottom nav) ---
      ShellRoute(
        builder: (context, state, child) => _VendorShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.vendorHomePath,
            name: RouteNames.vendorHome,
            builder: (context, state) => const VendorHomeScreen(),
          ),
          GoRoute(
            path: RouteNames.vendorSetupPath,
            name: RouteNames.vendorSetup,
            builder: (context, state) => const VendorSetupScreen(),
          ),
          GoRoute(
            path: RouteNames.vendorPublishPath,
            name: RouteNames.vendorPublish,
            builder: (context, state) => const PublishProductScreen(),
          ),
          GoRoute(
            path: RouteNames.vendorCatalogPath,
            name: RouteNames.vendorCatalog,
            builder: (context, state) => const MyCatalogScreen(),
          ),
          GoRoute(
            path: RouteNames.vendorStatsPath,
            name: RouteNames.vendorStats,
            builder: (context, state) => const VendorStatsScreen(),
          ),
          GoRoute(
            path: RouteNames.vendorEditPath,
            name: RouteNames.vendorEdit,
            builder: (context, state) => EditProductScreen(
              productId: state.pathParameters['productId'] ?? '',
            ),
          ),
        ],
      ),

      // --- Rutas compartidas (top-level) ---
      GoRoute(
        path: RouteNames.reportPricePath,
        name: RouteNames.reportPrice,
        builder: (context, state) => ReportPriceScreen(
          initialProduct: state.uri.queryParameters['product'],
        ),
      ),
      GoRoute(
        path: RouteNames.ratingPath,
        name: RouteNames.rating,
        builder: (context, state) => RatingScreen(
          vendorId: state.pathParameters['vendorId'] ?? '',
        ),
      ),
      GoRoute(
        path: RouteNames.settingsPath,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}

/// Shell del comprador con bottom navigation.
class _BuyerShell extends StatelessWidget {
  const _BuyerShell({required this.child});

  final Widget child;

  static const _tabs = [
    (path: RouteNames.buyerHomePath, icon: Icons.home_outlined, label: 'Inicio'),
    (path: RouteNames.buyerMapPath, icon: Icons.map_outlined, label: 'Mapa'),
    (path: RouteNames.buyerSearchPath, icon: Icons.search, label: 'Buscar'),
    (
      path: RouteNames.buyerPriceIndexPath,
      icon: Icons.trending_up,
      label: 'Precios',
    ),
    (
      path: RouteNames.buyerAlertsPath,
      icon: Icons.notifications_outlined,
      label: 'Alertas',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    var currentIndex = _tabs.indexWhere((t) => location.startsWith(t.path));
    if (currentIndex < 0) currentIndex = 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => context.go(_tabs[index].path),
        items: [
          for (final tab in _tabs)
            BottomNavigationBarItem(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}

/// Shell del vendedor con bottom navigation.
class _VendorShell extends StatelessWidget {
  const _VendorShell({required this.child});

  final Widget child;

  static const _tabs = [
    (
      path: RouteNames.vendorHomePath,
      icon: Icons.home_outlined,
      label: 'Inicio',
    ),
    (
      path: RouteNames.vendorPublishPath,
      icon: Icons.add_circle_outline,
      label: 'Publicar',
    ),
    (
      path: RouteNames.vendorCatalogPath,
      icon: Icons.inventory_2_outlined,
      label: 'Catálogo',
    ),
    (
      path: RouteNames.vendorStatsPath,
      icon: Icons.bar_chart,
      label: 'Estadísticas',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    var currentIndex = _tabs.indexWhere((t) => location.startsWith(t.path));
    if (currentIndex < 0) currentIndex = 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => context.go(_tabs[index].path),
        items: [
          for (final tab in _tabs)
            BottomNavigationBarItem(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}
