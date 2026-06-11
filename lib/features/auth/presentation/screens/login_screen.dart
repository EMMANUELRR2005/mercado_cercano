import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../providers/auth_provider.dart';

/// Pantalla de acceso: Google (principal), Apple (solo iOS) y
/// Email/Password (respaldo).
///
/// La navegación post-login la decide el listener: usuario nuevo (sin
/// rol) → selector de rol; usuario existente → home de su rol.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(authBlocProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          bloc: bloc,
          listener: (context, state) {
            switch (state) {
              case Authenticated(:final user, :final isNewUser):
                if (isNewUser) {
                  context.goNamed(RouteNames.authRole);
                } else {
                  context.goNamed(
                    user.role.name == 'vendor'
                        ? RouteNames.vendorHome
                        : RouteNames.buyerHome,
                  );
                }
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
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // --- Logo + tagline ---
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.storefront,
                      size: 52,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('MercadoCercano',
                      style: AppTextStyles.headlineLarge),
                  const SizedBox(height: 6),
                  Text(
                    'Precios del mercado, en tu bolsillo',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),

                  const Spacer(flex: 2),

                  if (isLoading)
                    const CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    )
                  else ...[
                    // --- Google (principal, brand guidelines) ---
                    _GoogleButton(
                      onPressed: () =>
                          bloc.add(const GoogleSignInRequested()),
                    ),

                    // --- Apple (solo iOS) ---
                    if (Platform.isIOS) ...[
                      const SizedBox(height: 12),
                      _AppleButton(
                        onPressed: () =>
                            bloc.add(const AppleSignInRequested()),
                      ),
                    ],

                    // --- Divisor "o" ---
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(color: AppColors.divider)),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'o',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.textHint),
                          ),
                        ),
                        const Expanded(
                            child: Divider(color: AppColors.divider)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // --- Email (terciario, texto simple) ---
                    TextButton(
                      onPressed: () =>
                          context.pushNamed(RouteNames.authEmail),
                      child: Text(
                        'Usar email y contraseña',
                        style: AppTextStyles.titleSmall
                            .copyWith(color: AppColors.primaryGreen),
                      ),
                    ),
                  ],

                  const Spacer(flex: 2),

                  // --- Footer legal ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Al continuar aceptas nuestros Términos y '
                      'Política de Privacidad',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textHint),
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
}

/// Botón oficial de Google: fondo blanco, texto negro, borde gris y el
/// logo "G" multicolor (dibujado, sin assets externos).
class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFDADCE0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _GoogleLogo(size: 20),
            const SizedBox(width: 12),
            Text(
              'Continuar con Google',
              style: AppTextStyles.titleSmall.copyWith(
                color: const Color(0xFF1F1F1F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "G" de Google dibujada con los 4 colores de marca.
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.22;
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    // Arcos de la "G": rojo, amarillo, verde y azul.
    canvas.drawArc(rect, -2.1, 1.6, false, paint..color = const Color(0xFFEA4335));
    canvas.drawArc(rect, 2.6, 1.6, false, paint..color = const Color(0xFFFBBC05));
    canvas.drawArc(rect, 1.0, 1.6, false, paint..color = const Color(0xFF34A853));
    canvas.drawArc(rect, -0.4, 0.9, false, paint..color = const Color(0xFF4285F4));

    // Barra horizontal de la "G" (azul).
    final barPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width / 2,
        size.height / 2 - stroke / 2,
        size.width / 2,
        stroke,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Botón de Apple: fondo negro, logo y texto blancos.
class _AppleButton extends StatelessWidget {
  const _AppleButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.apple, size: 24, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Continuar con Apple',
              style: AppTextStyles.titleSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
