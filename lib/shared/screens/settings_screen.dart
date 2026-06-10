import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Configuración de la app: cuenta, privacidad y cierre de sesión.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmLogout(BuildContext context, AuthBloc bloc) async {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final authBloc = ref.watch(authBlocProvider);
    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go(RouteNames.authPhonePath);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Configuración')),
        body: ListView(
          children: [
            const SizedBox(height: 8),
            const ListTile(
              leading: Icon(Icons.language, color: AppColors.primaryGreen),
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
                'Tu ubicación nunca se almacena: solo se usa en el momento '
                'para mostrarte vendedores cercanos.',
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: AppColors.primaryGreen,
              ),
              title: const Text('Acerca de', style: AppTextStyles.titleSmall),
              subtitle: Text(
                'MercadoCercano v1.0'
                '${AppConstants.useMockData ? ' · modo demo (datos de prueba)' : ''}',
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.errorRed),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: AppColors.errorRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => _confirmLogout(context, authBloc),
            ),
          ],
        ),
      ),
    );
  }
}
