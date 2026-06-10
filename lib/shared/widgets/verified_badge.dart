import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Insignia de "Vendedor Verificado" con tooltip explicativo.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, this.compact = false});

  /// Si es true, solo muestra el ícono (útil en tarjetas pequeñas).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          'Vendedor Verificado: su identidad y ubicación fueron confirmadas '
          'por MercadoCercano.',
      triggerMode: TooltipTriggerMode.tap,
      child: compact
          ? const Icon(Icons.verified, size: 18, color: AppColors.primaryGreen)
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, size: 16, color: AppColors.primaryGreen),
                  SizedBox(width: 4),
                  Text(
                    'Vendedor Verificado',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
