import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../domain/auth_exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC del flujo de autenticación por OTP.
///
/// Convención de errores: los usecases/repositorio LANZAN excepciones;
/// este BLoC es el único punto donde se capturan y se mapean a `Failure`
/// (mensajes en español) con `mapAppException` / `mapDioException`.
///
/// Lleva el contador interno de intentos de OTP: tras
/// `AppConstants.maxOtpAttempts` códigos incorrectos emite
/// [MaxAttemptsReached] y solo un reenvío reinicia el contador.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this._sendOtp,
    required this._verifyOtp,
    required this._logout,
    required this._repository,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResendOtpRequested>(_onResendOtpRequested);
    on<RoleSelected>(_onRoleSelected);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final SendOtpUsecase _sendOtp;
  final VerifyOtpUsecase _verifyOtp;
  final LogoutUsecase _logout;

  // checkAuthStatus y selectRole no tienen usecase dedicado: el BLoC
  // los invoca directamente en el repositorio.
  final AuthRepository _repository;

  /// Intentos de OTP fallidos desde el último envío.
  int _failedAttempts = 0;

  /// Último teléfono al que se envió OTP (para reenvíos).
  String? _lastPhone;

  // -----------------------------------------------------------------------
  // Helpers síncronos para el router (Agente 7)
  // -----------------------------------------------------------------------

  /// `true` cuando hay sesión activa (estado [Authenticated]).
  bool get isAuthenticated => state is Authenticated;

  /// Rol actual en formato string ('buyer'/'vendor'), o `null` sin sesión
  /// o si el usuario nuevo aún no elige rol.
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
    } catch (e) {
      // Ante cualquier fallo restaurando sesión, tratamos como no autenticado.
      emit(const Unauthenticated());
    }
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _sendOtp(event.phone);
      _lastPhone = event.phone;
      _failedAttempts = 0;
      emit(OtpSent(event.phone));
    } catch (e) {
      emit(AuthError(_messageOf(e)));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_failedAttempts >= AppConstants.maxOtpAttempts) {
      emit(const MaxAttemptsReached());
      return;
    }

    emit(const AuthLoading());
    try {
      final result = await _verifyOtp(
        phone: event.phone,
        otp: event.otp,
        role: event.role,
      );
      _failedAttempts = 0;
      emit(Authenticated(result.user, isNewUser: result.isNewUser));
    } on OtpExpiredException {
      emit(const OtpExpired());
    } on ValidationException catch (e) {
      // Código incorrecto: consume un intento.
      _failedAttempts++;
      if (_failedAttempts >= AppConstants.maxOtpAttempts) {
        emit(const MaxAttemptsReached());
      } else {
        emit(AuthError(
          mapAppException(e).message,
          attemptsLeft: AppConstants.maxOtpAttempts - _failedAttempts,
        ));
      }
    } catch (e) {
      // Errores de red/servidor NO consumen intentos.
      emit(AuthError(_messageOf(e)));
    }
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final phone = _lastPhone;
    if (phone == null) {
      emit(const AuthError('No hay un número registrado. Vuelve a ingresarlo.'));
      return;
    }

    emit(const AuthLoading());
    try {
      await _sendOtp(phone);
      _failedAttempts = 0;
      emit(OtpSent(phone));
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
    try {
      await _logout();
    } finally {
      // Pase lo que pase, la sesión local queda cerrada.
      _lastPhone = null;
      _failedAttempts = 0;
      emit(const Unauthenticated());
    }
  }

  // -----------------------------------------------------------------------
  // Mapeo de excepciones a mensajes user-friendly (en español)
  // -----------------------------------------------------------------------

  String _messageOf(Object error) {
    return switch (error) {
      AppException e => mapAppException(e).message,
      DioException e => mapDioException(e).message,
      OtpExpiredException e => e.message,
      _ => 'Ocurrió un error inesperado. Intenta de nuevo.',
    };
  }
}
