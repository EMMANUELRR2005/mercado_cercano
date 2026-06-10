import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/core_providers.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_mock_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../bloc/auth_bloc.dart';

/// DI del feature de auth (Riverpod 3, `Provider<T>` manual).
///
/// PARA EL AGENTE 7 (router):
/// - `authBlocProvider` expone el [AuthBloc] (singleton con dispose).
/// - `authRefreshListenableProvider` expone un [Listenable] que notifica
///   en cada cambio de estado del bloc: pásalo como `refreshListenable`
///   de GoRouter.
/// - Callbacks síncronos para el redirect:
///   `getToken: () => bloc.isAuthenticated ? 'authenticated' : null`
///   `getRole:  () => bloc.currentRoleName`
///   Nota: `currentRoleName` es `null` mientras un usuario nuevo no haya
///   elegido rol → el redirect debe permitir `/auth/role` en ese caso.

/// Almacenamiento local del feature (onboarding, teléfono).
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  return AuthLocalDatasource();
});

/// Datasource de auth: mock o API real según `AppConstants.useMockData`.
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  if (AppConstants.useMockData) {
    return AuthMockDatasource();
  }
  return AuthRemoteDatasourceImpl(client: ref.watch(dioClientProvider));
});

/// Repositorio de autenticación.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    datasource: ref.watch(authRemoteDatasourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
    localDatasource: ref.watch(authLocalDatasourceProvider),
  );
});

// --- Usecases ---

final sendOtpUsecaseProvider = Provider<SendOtpUsecase>((ref) {
  return SendOtpUsecase(ref.watch(authRepositoryProvider));
});

final verifyOtpUsecaseProvider = Provider<VerifyOtpUsecase>((ref) {
  return VerifyOtpUsecase(ref.watch(authRepositoryProvider));
});

final refreshTokenUsecaseProvider = Provider<RefreshTokenUsecase>((ref) {
  return RefreshTokenUsecase(ref.watch(authRepositoryProvider));
});

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  return LogoutUsecase(ref.watch(authRepositoryProvider));
});

/// BLoC de autenticación (instancia única, se cierra con el provider).
final authBlocProvider = Provider<AuthBloc>((ref) {
  final bloc = AuthBloc(
    sendOtp: ref.watch(sendOtpUsecaseProvider),
    verifyOtp: ref.watch(verifyOtpUsecaseProvider),
    logout: ref.watch(logoutUsecaseProvider),
    repository: ref.watch(authRepositoryProvider),
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
