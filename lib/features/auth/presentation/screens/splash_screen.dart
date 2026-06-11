import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../providers/auth_provider.dart';

/// Splash: muestra el logo mientras se restaura la sesión guardada.
///
/// Navegación:
/// - Sin onboarding visto → `/onboarding`.
/// - Sin token → `/auth/phone`.
/// - Con token → home según rol (buyer/vendor).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _brandingTimer;

  @override
  void initState() {
    super.initState();
    // Pausa breve de branding antes de verificar la sesión.
    _brandingTimer = Timer(const Duration(milliseconds: 1200), () {
      ref.read(authBlocProvider).add(const AuthCheckRequested());
    });
  }

  @override
  void dispose() {
    _brandingTimer?.cancel();
    super.dispose();
  }

  Future<void> _onUnauthenticated() async {
    // Sin sesión: decide entre onboarding y login según la marca local.
    final onboardingDone =
        await ref.read(authLocalDatasourceProvider).isOnboardingComplete();
    if (!mounted) return;
    if (onboardingDone) {
      context.goNamed(RouteNames.authLogin);
    } else {
      context.goNamed(RouteNames.onboarding);
    }
  }

  void _goHome(UserEntity user) {
    context.goNamed(
      user.role == UserRole.vendor
          ? RouteNames.vendorHome
          : RouteNames.buyerHome,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(authBlocProvider);

    return BlocListener<AuthBloc, AuthState>(
      bloc: bloc,
      listener: (context, state) {
        switch (state) {
          case Authenticated(:final user):
            _goHome(user);
          case Unauthenticated():
            _onUnauthenticated();
          default:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryGreen,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.storefront,
                  size: 64,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'MercadoCercano',
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.surfaceWhite,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Precios justos, cerca de ti',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.surfaceWhite.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.surfaceWhite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
