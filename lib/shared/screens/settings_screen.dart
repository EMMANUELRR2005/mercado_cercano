import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/route_names.dart';
import '../../core/di/core_providers.dart';
import '../../core/firebase/activity_logger.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../domain/entities/user_entity.dart';

/// Configuración: rol actual (con cambio Comprador ⇄ Vendedor),
/// privacidad y cierre de sesión.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  /// Rol solicitado en el switch; sirve para saber que el próximo
  /// `Authenticated` corresponde a un cambio de rol y hay que redirigir.
  UserRole? _pendingRole;

  UserRole? _currentRole(AuthState state) =>
      state is Authenticated ? state.user.role : null;

  // -----------------------------------------------------------------
  // Cambio de rol
  // -----------------------------------------------------------------

  Future<void> _confirmRoleChange(UserRole newRole) async {
    final isVendor = newRole == UserRole.vendor;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isVendor ? '¿Cambiar a modo Vendedor?' : '¿Cambiar a modo Comprador?',
        ),
        content: Text(
          isVendor
              ? 'Podrás publicar productos y gestionar tu catálogo.'
              : 'Podrás buscar productos, comparar precios y crear alertas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      // Revertir visualmente el switch.
      setState(() {});
      return;
    }
    setState(() => _pendingRole = newRole);
    ref.read(authBlocProvider).add(RoleSelected(newRole));
  }

  Future<void> _onRoleChanged(UserRole newRole) async {
    final local = ref.read(authLocalDatasourceProvider);
    final isVendor = newRole == UserRole.vendor;

    // Auditoría best-effort del cambio de rol.
    unawaited(
      ref.read(activityLoggerProvider).log(
        ActivityAction.roleChanged,
        metadata: {'newRole': newRole.name},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isVendor
              ? 'Ahora estás en modo Vendedor 🏪'
              : 'Ahora estás en modo Comprador 🛒',
        ),
        backgroundColor: AppColors.successGreen,
      ),
    );

    if (isVendor) {
      final seen = await local.hasBeenVendor();
      await local.markHasBeenVendor();
      if (!seen && mounted) {
        // Primera vez como vendedor: mini onboarding de 2 pasos.
        final startPublishing = await showModalBottomSheet<bool>(
          context: context,
          isDismissible: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => const _VendorOnboardingSheet(),
        );
        if (!mounted) return;
        context.go(
          startPublishing == true
              ? RouteNames.vendorPublishPath
              : RouteNames.vendorHomePath,
        );
        return;
      }
      if (mounted) context.go(RouteNames.vendorHomePath);
    } else {
      await local.markHasBeenBuyer();
      if (mounted) context.go(RouteNames.buyerHomePath);
    }
  }

  // -----------------------------------------------------------------
  // Logout
  // -----------------------------------------------------------------

  Future<void> _confirmLogout(AuthBloc bloc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir de tu cuenta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      bloc.add(const LogoutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = ref.watch(authBlocProvider);
    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go(RouteNames.authLoginPath);
          return;
        }
        // Cambio de rol completado: redirigir al home del nuevo rol.
        if (state is Authenticated &&
            _pendingRole != null &&
            state.user.role == _pendingRole) {
          final newRole = _pendingRole!;
          _pendingRole = null;
          _onRoleChanged(newRole);
        }
        if (state is AuthError && _pendingRole != null) {
          _pendingRole = null;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorRed,
            ),
          );
          setState(() {});
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (context, state) {
          final role = _currentRole(state);
          final changing = state is AuthLoading && _pendingRole != null;
          final user = state is Authenticated ? state.user : null;
          return Scaffold(
            appBar: AppBar(title: const Text('Configuración')),
            body: ListView(
              children: [
                // --- Perfil: foto, nombre, email y método de acceso ---
                if (user != null) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppColors.primaryGreenLight,
                          foregroundImage: (user.photoUrl ?? '').isNotEmpty
                              ? NetworkImage(user.photoUrl!)
                              : null,
                          child: Text(
                            (user.name ?? user.email ?? '?')
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? 'Usuario',
                                style: AppTextStyles.titleLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if ((user.email ?? '').isNotEmpty)
                                Text(
                                  user.email!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 6),
                              _LoginMethodBadge(
                                  method: user.loginMethod),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],

                // --- Mi rol actual: ambos modos siempre visibles ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mi rol actual',
                          style: AppTextStyles.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        role == UserRole.vendor
                            ? '🏪 Vendedor — publica y gestiona tu catálogo'
                            : '🛒 Comprador — busca precios y vendedores',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      if (changing)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<UserRole>(
                            segments: const [
                              ButtonSegment(
                                value: UserRole.buyer,
                                icon: Icon(Icons.shopping_cart_outlined),
                                label: Text('Comprador'),
                              ),
                              ButtonSegment(
                                value: UserRole.vendor,
                                icon: Icon(Icons.storefront_outlined),
                                label: Text('Vendedor'),
                              ),
                            ],
                            selected: {role ?? UserRole.buyer},
                            onSelectionChanged: (selection) {
                              final newRole = selection.first;
                              if (newRole != role) {
                                _confirmRoleChange(newRole);
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(),
                const ListTile(
                  leading:
                      Icon(Icons.language, color: AppColors.primaryGreen),
                  title: Text('Idioma', style: AppTextStyles.titleSmall),
                  subtitle: Text('Español (Guatemala)'),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.shield_outlined,
                    color: AppColors.primaryGreen,
                  ),
                  title: Text('Privacidad', style: AppTextStyles.titleSmall),
                  subtitle: Text(
                    'Tu ubicación nunca se almacena: solo se usa en el '
                    'momento para mostrarte vendedores cercanos.',
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: AppColors.primaryGreen,
                  ),
                  title:
                      const Text('Acerca de', style: AppTextStyles.titleSmall),
                  subtitle: Text(
                    'MercadoCercano v1.0'
                    '${AppConstants.useMockData ? ' · modo demo (datos de prueba)' : ''}',
                  ),
                ),
                const Divider(),
                ListTile(
                  leading:
                      const Icon(Icons.logout, color: AppColors.errorRed),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: AppColors.errorRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => _confirmLogout(authBloc),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Badge del método de acceso usado: Google / Apple / Email.
class _LoginMethodBadge extends StatelessWidget {
  const _LoginMethodBadge({this.method});

  final String? method;

  @override
  Widget build(BuildContext context) {
    final (label, icon) = switch (method) {
      'google' => ('Google', Icons.g_mobiledata),
      'apple' => ('Apple', Icons.apple),
      'email' => ('Email', Icons.mail_outline),
      _ => ('Cuenta', Icons.person_outline),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryGreen),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelMedium
                .copyWith(color: AppColors.primaryGreen),
          ),
        ],
      ),
    );
  }
}

/// Onboarding rápido de vendedor (2 pasos) — se muestra una sola vez.
class _VendorOnboardingSheet extends StatefulWidget {
  const _VendorOnboardingSheet();

  @override
  State<_VendorOnboardingSheet> createState() =>
      _VendorOnboardingSheetState();
}

class _VendorOnboardingSheetState extends State<_VendorOnboardingSheet> {
  int _step = 0;

  static const _steps = [
    (
      icon: Icons.add_a_photo_outlined,
      title: 'Publica tu primer producto en menos de 30 segundos',
      subtitle: 'Foto → nombre y precio → publicar. Así de simple.',
    ),
    (
      icon: Icons.update,
      title: 'Tus publicaciones duran 24h y puedes renovarlas fácilmente',
      subtitle: 'Con un toque en "Renovar todo" tu catálogo sigue visible '
          'un día más.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];
    final isLast = _step == _steps.length - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(step.icon, size: 56, color: AppColors.primaryGreen),
          const SizedBox(height: 16),
          Text(
            step.title,
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            step.subtitle,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _steps.length,
              (i) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _step
                      ? AppColors.primaryGreen
                      : AppColors.divider,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (isLast) {
                  Navigator.pop(context, true);
                } else {
                  setState(() => _step++);
                }
              },
              child:
                  Text(isLast ? 'Entendido, empezar' : 'Siguiente'),
            ),
          ),
          if (isLast)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Ver mi panel primero'),
            ),
        ],
      ),
    );
  }
}
