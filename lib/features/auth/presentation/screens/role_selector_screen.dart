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

/// Selector de rol para usuarios nuevos (post verificación de OTP).
///
/// Sin botón de retroceso ([PopScope] con `canPop: false`): el usuario
/// DEBE elegir un rol. La selección dispara [RoleSelected]; el mock
/// actualiza y persiste el rol, y al quedar [Authenticated] se navega
/// al home correspondiente.
class RoleSelectorScreen extends ConsumerStatefulWidget {
  const RoleSelectorScreen({super.key});

  @override
  ConsumerState<RoleSelectorScreen> createState() =>
      _RoleSelectorScreenState();
}

class _RoleSelectorScreenState extends ConsumerState<RoleSelectorScreen> {
  UserRole? _selecting;

  void _select(UserRole role) {
    setState(() => _selecting = role);
    ref.read(authBlocProvider).add(RoleSelected(role));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(authBlocProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            bloc: bloc,
            listener: (context, state) {
              switch (state) {
                case Authenticated(:final user):
                  context.goNamed(
                    user.role == UserRole.vendor
                        ? RouteNames.vendorHome
                        : RouteNames.buyerHome,
                  );
                case AuthError(:final message):
                  setState(() => _selecting = null);
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
                    Text(
                      '¿Cómo usarás\nMercadoCercano?',
                      style: AppTextStyles.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Elige tu rol para personalizar tu experiencia. '
                      'Podrás cambiarlo después en configuración.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _RoleCard(
                      icon: Icons.shopping_cart,
                      title: 'Soy Comprador',
                      description:
                          'Compara precios del día, encuentra ventas '
                          'cercanas y recibe alertas de ofertas.',
                      isLoading: isLoading && _selecting == UserRole.buyer,
                      onTap: isLoading ? null : () => _select(UserRole.buyer),
                    ),
                    const SizedBox(height: 20),
                    _RoleCard(
                      icon: Icons.storefront,
                      title: 'Soy Vendedor',
                      description:
                          'Publica tus productos y precios, llega a más '
                          'clientes y haz crecer tu venta.',
                      isLoading: isLoading && _selecting == UserRole.vendor,
                      onTap: isLoading ? null : () => _select(UserRole.vendor),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Tarjeta grande de selección de rol.
class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isLoading,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceWhite,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(22),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryGreen,
                          ),
                        ),
                      )
                    : Icon(icon, size: 40, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleLarge),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
