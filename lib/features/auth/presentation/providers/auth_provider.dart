import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/core_providers.dart';
import '../../data/datasources/auth_firebase_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../bloc/auth_bloc.dart';

/// DI del feature de auth (Riverpod 3, `Provider<T>` manual).
///
/// Para el router:
/// - `authRefreshListenableProvider` → `refreshListenable` de GoRouter.
/// - Callbacks síncronos del redirect:
///   `getToken: () => bloc.isAuthenticated ? 'authenticated' : null`
///   `getRole:  () => bloc.currentRoleName`
///   (`currentRoleName` es `null` mientras el usuario nuevo no elija rol
///   → el redirect permite `/auth/role` en ese caso.)

/// Almacenamiento local del feature (onboarding, flags de rol).
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  return AuthLocalDatasource();
});

/// Datasource de auth: Firebase (Google / Apple / Email-Password).
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthFirebaseDatasource();
});

/// Repositorio de autenticación.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    datasource: ref.watch(authRemoteDatasourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
    local: ref.watch(authLocalDatasourceProvider),
  );
});

/// BLoC de autenticación (instancia única, se cierra con el provider).
final authBlocProvider = Provider<AuthBloc>((ref) {
  final bloc = AuthBloc(
    repository: ref.watch(authRepositoryProvider),
    activityLogger: ref.watch(activityLoggerProvider),
  );
  ref.onDispose(bloc.close);
  return bloc;
});

/// [Listenable] para el `refreshListenable` de GoRouter: notifica en cada
/// cambio de estado de auth para reevaluar el redirect.
final authRefreshListenableProvider = Provider<Listenable>((ref) {
  final bloc = ref.watch(authBlocProvider);
  final notifier = AuthRefreshNotifier(bloc.stream);
  ref.onDispose(notifier.dispose);
  return notifier;
});

/// Adapta el stream de estados del [AuthBloc] a un [ChangeNotifier]
/// (equivalente al viejo `GoRouterRefreshStream`).
class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
