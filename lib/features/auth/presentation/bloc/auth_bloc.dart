import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/firebase/activity_logger.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC del flujo de autenticación: Google (principal), Apple (iOS) y
/// Email/Password (respaldo).
///
/// Convención de errores: el repositorio LANZA excepciones; este BLoC es
/// el único punto donde se capturan y se mapean a `Failure` (mensajes en
/// español) con `mapAppException` / `mapDioException`.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this._repository,
    this._activityLogger,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<GoogleSignInRequested>(
      (event, emit) => _signIn(emit, _repository.signInWithGoogle),
    );
    on<AppleSignInRequested>(
      (event, emit) => _signIn(emit, _repository.signInWithApple),
    );
    on<EmailSignUpRequested>(
      (event, emit) => _signIn(
        emit,
        () => _repository.signUpWithEmail(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      ),
    );
    on<EmailSignInRequested>(
      (event, emit) => _signIn(
        emit,
        () => _repository.signInWithEmail(
          email: event.email,
          password: event.password,
        ),
      ),
    );
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<RoleSelected>(_onRoleSelected);
    on<LogoutRequested>(_onLogoutRequested);
    on<AccountDeletionRequested>(_onAccountDeletionRequested);
    on<SessionExpiredExternally>(_onSessionExpiredExternally);

    // authStateChanges como fuente de verdad: si Firebase cierra la
    // sesión por fuera (token revocado, usuario borrado), reflejarlo.
    _sessionSub = _repository.watchSessionActive().listen(
      (active) {
        if (!active && state is Authenticated) {
          add(const SessionExpiredExternally());
        }
      },
      onError: (_) {},
    );
  }

  final AuthRepository _repository;

  /// Auditoría best-effort (login/logout); opcional en tests.
  final ActivityLogger? _activityLogger;

  StreamSubscription<bool>? _sessionSub;

  // -----------------------------------------------------------------------
  // Helpers síncronos para el router
  // -----------------------------------------------------------------------

  /// `true` cuando hay sesión activa (estado [Authenticated]).
  bool get isAuthenticated => state is Authenticated;

  /// Rol actual ('buyer'/'vendor'), o `null` sin sesión o si el usuario
  /// nuevo aún no elige rol.
  String? get currentRoleName => switch (state) {
        Authenticated(:final user, :final isNewUser) =>
          isNewUser ? null : user.role.name,
        _ => null,
      };

  // -----------------------------------------------------------------------
  // Handlers
  // -----------------------------------------------------------------------

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.checkAuthStatus();
      emit(user != null ? Authenticated(user) : const Unauthenticated());
    } catch (_) {
      // Ante cualquier fallo restaurando sesión: no autenticado.
      emit(const Unauthenticated());
    }
  }

  /// Flujo común de los 4 métodos de acceso.
  Future<void> _signIn(
    Emitter<AuthState> emit,
    Future<SignInResult> Function() method,
  ) async {
    emit(const AuthLoading());
    try {
      final result = await method();
      emit(Authenticated(result.user, isNewUser: result.isNewUser));
      // Auditoría best-effort (nunca interrumpe el flujo).
      unawaited(_activityLogger?.log(
        ActivityAction.login,
        metadata: {'method': ?result.user.loginMethod},
      ));
    } on ValidationException catch (e) {
      // Incluye la cancelación del selector de cuenta: volver al login
      // sin mostrar un error aparatoso.
      if (e.message == 'Operación cancelada') {
        emit(const Unauthenticated());
      } else {
        emit(AuthError(mapAppException(e).message));
      }
    } catch (e) {
      emit(AuthError(_messageOf(e)));
    }
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _repository.sendPasswordReset(event.email);
      emit(PasswordResetSent(event.email));
    } catch (e) {
      emit(AuthError(_messageOf(e)));
    }
  }

  Future<void> _onRoleSelected(
    RoleSelected event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.selectRole(event.role);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(_messageOf(e)));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    // El log va antes de limpiar storage (necesita el userId guardado).
    await _activityLogger?.log(ActivityAction.logout);
    try {
      await _repository.logout();
    } finally {
      // Pase lo que pase, la sesión local queda cerrada.
      emit(const Unauthenticated());
    }
  }

  Future<void> _onAccountDeletionRequested(
    AccountDeletionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    // El log va antes de borrar (necesita el userId aún en storage).
    await _activityLogger?.log(ActivityAction.accountDeleted);
    try {
      await _repository.deleteAccount();
      emit(const Unauthenticated());
    } catch (e) {
      // Falló (p. ej. reautenticación cancelada): la sesión sigue activa.
      emit(AuthError(_messageOf(e)));
    }
  }

  /// Firebase cerró la sesión por fuera (token revocado/usuario borrado).
  void _onSessionExpiredExternally(
    SessionExpiredExternally event,
    Emitter<AuthState> emit,
  ) {
    emit(const Unauthenticated());
  }

  @override
  Future<void> close() async {
    await _sessionSub?.cancel();
    return super.close();
  }

  // -----------------------------------------------------------------------
  // Mapeo de excepciones a mensajes user-friendly (en español)
  // -----------------------------------------------------------------------

  String _messageOf(Object error) {
    return switch (error) {
      AppException e => mapAppException(e).message,
      DioException e => mapDioException(e).message,
      _ => 'Ocurrió un error inesperado. Intenta de nuevo.',
    };
  }
}
