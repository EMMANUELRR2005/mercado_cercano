import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../router/app_router.dart';

// ---------------------------------------------------------------------------
// Contenedor de inyección de dependencias (Riverpod 3, providers manuales).
//
// Cada feature registra sus propios providers en su `*_provider.dart`:
//   - Core:        lib/core/di/core_providers.dart
//   - Auth:        lib/features/auth/presentation/providers/auth_provider.dart
//   - Vendedor:    lib/features/vendor/presentation/providers/vendor_provider.dart
//   - Comprador:   lib/features/buyer/presentation/providers/buyer_provider.dart
//   - Precios:     lib/features/price_index/presentation/providers/price_provider.dart
//   - Mapa:        lib/features/map/presentation/providers/map_provider.dart
//   - Reputación:  lib/features/reputation/presentation/providers/reputation_provider.dart
//
// Aquí solo vive el cableado transversal: el router con su guard de auth.
// ---------------------------------------------------------------------------

/// Router de la app, conectado al estado de autenticación.
///
/// El redirect se reevalúa con cada cambio de estado del [AuthBloc]
/// gracias a `authRefreshListenableProvider`.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authBloc = ref.watch(authBlocProvider);
  return buildRouter(
    refreshListenable: ref.watch(authRefreshListenableProvider),
    getToken: () => authBloc.isAuthenticated ? 'authenticated' : null,
    getRole: () => authBloc.currentRoleName,
    // El splash decide si mostrar onboarding (lee secure storage async),
    // por eso el redirect no necesita este flag de forma síncrona.
    isOnboardingComplete: () => true,
  );
});
