import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../providers/auth_provider.dart';

/// Pantalla de verificación del código OTP.
///
/// Recibe [phone] (8 dígitos, sin prefijo) — el Agente 7 lo lee del
/// query parameter `phone` de `/auth/otp?phone=XXXXXXXX`:
/// `OtpVerificationScreen(phone: state.uri.queryParameters['phone'] ?? '')`.
///
/// - 6 campos individuales con auto-focus al siguiente.
/// - Countdown de expiración del código (5:00).
/// - "Reenviar código" deshabilitado 60 s con countdown.
/// - Máx 3 intentos → [MaxAttemptsReached].
/// - Verificación exitosa: usuario nuevo → `/auth/role`; con rol → home.
class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key, required this.phone});

  /// Teléfono al que se envió el código (8 dígitos, sin prefijo).
  final String phone;

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    AppConstants.otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    AppConstants.otpLength,
    (_) => FocusNode(),
  );

  Timer? _expiryTimer;
  Timer? _resendTimer;
  int _expirySeconds = AppConstants.otpExpiryMinutes * 60;
  int _resendSeconds = AppConstants.otpResendSeconds;
  bool _expiredLocally = false;

  @override
  void initState() {
    super.initState();
    _startTimers();
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    _resendTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // -----------------------------------------------------------------------
  // Timers
  // -----------------------------------------------------------------------

  void _startTimers() {
    _expiryTimer?.cancel();
    _resendTimer?.cancel();
    setState(() {
      _expirySeconds = AppConstants.otpExpiryMinutes * 60;
      _resendSeconds = AppConstants.otpResendSeconds;
      _expiredLocally = false;
    });

    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_expirySeconds <= 1) {
        timer.cancel();
        setState(() {
          _expirySeconds = 0;
          _expiredLocally = true; // El código ya no sirve.
        });
      } else {
        setState(() => _expirySeconds--);
      }
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 1) {
        timer.cancel();
        setState(() => _resendSeconds = 0);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // -----------------------------------------------------------------------
  // Manejo del código
  // -----------------------------------------------------------------------

  String get _code => _controllers.map((c) => c.text).join();

  void _clearCode() {
    for (final c in _controllers) {
      c.clear();
    }
    if (mounted) _focusNodes.first.requestFocus();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Si se pegaron varios dígitos, distribuirlos.
      if (value.length > 1) {
        _distributePaste(index, value);
        return;
      }
      // Avanza el foco al siguiente campo.
      if (index < AppConstants.otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
      // Auto-verificar al completar los 6 dígitos.
      if (_code.length == AppConstants.otpLength) {
        _verify();
      }
    }
  }

  void _distributePaste(int startIndex, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    var i = startIndex;
    for (final d in digits.split('')) {
      if (i >= AppConstants.otpLength) break;
      _controllers[i].text = d;
      i++;
    }
    final next = i < AppConstants.otpLength ? i : AppConstants.otpLength - 1;
    _focusNodes[next].requestFocus();
    if (_code.length == AppConstants.otpLength) _verify();
  }

  KeyEventResult _onKeyEvent(int index, KeyEvent event) {
    // Backspace en campo vacío: regresa al campo anterior y lo borra.
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _verify() {
    if (_expiredLocally) return;
    if (_code.length != AppConstants.otpLength) return;
    FocusScope.of(context).unfocus();
    ref.read(authBlocProvider).add(
          VerifyOtpRequested(phone: widget.phone, otp: _code),
        );
  }

  void _resend() {
    ref.read(authBlocProvider).add(const ResendOtpRequested());
  }

  void _goAfterAuth(Authenticated state) {
    if (state.isNewUser) {
      // Usuario nuevo: aún debe elegir rol.
      context.goNamed(RouteNames.authRole);
    } else {
      context.goNamed(
        state.user.role == UserRole.vendor
            ? RouteNames.vendorHome
            : RouteNames.buyerHome,
      );
    }
  }

  // -----------------------------------------------------------------------
  // UI
  // -----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(authBlocProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          bloc: bloc,
          listener: (context, state) {
            switch (state) {
              case Authenticated():
                _goAfterAuth(state);
              case OtpSent():
                // Reenvío exitoso: reinicia countdowns y limpia campos.
                _startTimers();
                _clearCode();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Te enviamos un nuevo código.'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              case AuthError():
                _clearCode();
              case OtpExpired():
                setState(() => _expiredLocally = true);
              default:
                break;
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final maxReached = state is MaxAttemptsReached;
            final inputsDisabled = isLoading || maxReached || _expiredLocally;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingresa el código', style: AppTextStyles.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Enviamos un código de ${AppConstants.otpLength} dígitos '
                    'al +502 ${widget.phone}.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // --- 6 campos del código ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var i = 0; i < AppConstants.otpLength; i++)
                        _OtpBox(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          enabled: !inputsDisabled,
                          onChanged: (value) => _onDigitChanged(i, value),
                          onKeyEvent: (event) => _onKeyEvent(i, event),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // --- Countdown de expiración / mensajes de estado ---
                  Center(child: _buildStatus(state)),
                  const SizedBox(height: 32),
                  // --- Botón verificar ---
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: inputsDisabled ? null : _verify,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        disabledBackgroundColor:
                            AppColors.primaryGreen.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.surfaceWhite,
                                ),
                              ),
                            )
                          : Text(
                              'Verificar',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.surfaceWhite,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // --- Reenviar código (deshabilitado 60 s) ---
                  Center(
                    child: TextButton(
                      onPressed:
                          _resendSeconds == 0 && !isLoading ? _resend : null,
                      child: Text(
                        _resendSeconds == 0
                            ? 'Reenviar código'
                            : 'Reenviar código en ${_resendSeconds}s',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: _resendSeconds == 0 && !isLoading
                              ? AppColors.primaryGreen
                              : AppColors.textHint,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Mensaje contextual bajo los campos según el estado actual.
  Widget _buildStatus(AuthState state) {
    if (state is MaxAttemptsReached) {
      return _StatusMessage(
        icon: Icons.block,
        color: AppColors.errorRed,
        text: 'Alcanzaste el máximo de ${AppConstants.maxOtpAttempts} '
            'intentos. Solicita un nuevo código para continuar.',
      );
    }

    if (state is OtpExpired || _expiredLocally) {
      return const _StatusMessage(
        icon: Icons.timer_off,
        color: AppColors.errorRed,
        text: 'El código expiró. Solicita uno nuevo para continuar.',
      );
    }

    if (state is AuthError) {
      final attempts = state.attemptsLeft;
      return _StatusMessage(
        icon: Icons.error_outline,
        color: AppColors.errorRed,
        text: attempts != null
            ? '${state.message} Te quedan $attempts '
                '${attempts == 1 ? 'intento' : 'intentos'}.'
            : state.message,
      );
    }

    return Text(
      'El código expira en ${_formatTime(_expirySeconds)}',
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }
}

/// Campo individual de un dígito del OTP.
class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onChanged,
    required this.onKeyEvent,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final KeyEventResult Function(KeyEvent) onKeyEvent;

  @override
  Widget build(BuildContext context) {
    return Focus(
      // Captura backspace para regresar al campo anterior.
      onKeyEvent: (node, event) => onKeyEvent(event),
      child: SizedBox(
        width: 48,
        height: 56,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: AppTextStyles.headlineMedium,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          // Permitimos más de 1 char temporalmente para soportar pegado;
          // _onDigitChanged distribuye los dígitos.
          onChanged: onChanged,
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: enabled
                ? AppColors.surfaceWhite
                : AppColors.divider.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mensaje de estado (error/expirado/bloqueado) bajo los campos.
class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
