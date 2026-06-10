import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../domain/entities/user_entity.dart';

/// Compuerta de funciones premium.
///
/// - Suscripción `pro` o `family`: muestra [child] sin cambios.
/// - Suscripción `free`: muestra [child] difuminado y bloqueado, con un
///   overlay de candado e invitación a mejorar al Plan Pro.
class PremiumFeatureGate extends StatelessWidget {
  const PremiumFeatureGate({
    super.key,
    required this.child,
    required this.featureName,
    this.subscription = UserSubscription.free,
    this.onUpgrade,
  });

  final Widget child;

  /// Nombre legible de la función (ej. "Estadísticas avanzadas").
  final String featureName;

  final UserSubscription subscription;

  /// Acción del botón "Mejorar a Pro" (ej. navegar a la pantalla de planes).
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    // Plan pagado: acceso completo.
    if (subscription != UserSubscription.free) return child;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        // Contenido difuminado y sin interacción.
        IgnorePointer(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: child,
          ),
        ),
        Positioned.fill(
          child: ColoredBox(
            color: Colors.white.withValues(alpha: 0.55),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accentAmber.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        size: 28,
                        color: AppColors.accentAmber,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Función Premium',
                      style: AppTextStyles.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Accede a $featureName con el Plan Pro',
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accentAmber,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: onUpgrade,
                      icon: const Icon(Icons.workspace_premium, size: 18),
                      label: const Text('Mejorar a Pro'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
