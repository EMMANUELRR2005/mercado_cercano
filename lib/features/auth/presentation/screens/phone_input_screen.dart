import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../providers/auth_provider.dart';

/// Pantalla de ingreso del teléfono.
///
/// Prefijo +502 fijo (no editable) + 8 dígitos. Al recibir [OtpSent]
/// navega a `/auth/otp?phone=XXXXXXXX` (el teléfono viaja como query
/// parameter, 8 dígitos sin prefijo).
class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final _controller = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    // Habilita el botón solo con un celular GT válido (8 dígitos).
    setState(() {
      _isValid = Validators.validatePhoneGt(value) == null;
    });
  }

  void _submit() {
    if (!_isValid) return;
    FocusScope.of(context).unfocus();
    ref
        .read(authBlocProvider)
        .add(SendOtpRequested(_controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(authBlocProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          bloc: bloc,
          listener: (context, state) {
            switch (state) {
              case OtpSent(:final phone):
                // El teléfono viaja como query parameter a la pantalla OTP.
                context.pushNamed(
                  RouteNames.authOtp,
                  queryParameters: {'phone': phone},
                );
              case AuthError(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.errorRed,
                  ),
                );
              default:
                break;
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  const Icon(
                    Icons.phone_android,
                    size: 48,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '¿Cuál es tu número?',
                    style: AppTextStyles.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Te enviaremos un código por SMS para verificar '
                    'tu cuenta.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Prefijo de Guatemala, fijo y no editable.
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Text('+502', style: AppTextStyles.titleMedium),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: _onChanged,
                          enabled: !isLoading,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: AppTextStyles.titleMedium,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '5555 5555',
                            hintStyle: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.textHint,
                            ),
                            filled: true,
                            fillColor: AppColors.surfaceWhite,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.divider),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.divider),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primaryGreen,
                                width: 2,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _submit(),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _isValid && !isLoading ? _submit : null,
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
                              'Enviar código',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.surfaceWhite,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
