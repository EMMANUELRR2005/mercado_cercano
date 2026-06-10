import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Overlay de carga: spinner verde sobre fondo semitransparente.
///
/// Uso como widget (dentro de un Stack) o como diálogo modal:
/// ```dart
/// LoadingOverlay.show(context, message: 'Enviando…');
/// // …al terminar:
/// LoadingOverlay.hide(context);
/// ```
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, this.message});

  final String? message;

  /// Muestra el overlay como diálogo modal no descartable.
  static Future<void> show(BuildContext context, {String? message}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) => PopScope(
        canPop: false,
        child: LoadingOverlay(message: message),
      ),
    );
  }

  /// Cierra el overlay mostrado con [show].
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.05),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primaryGreen),
            if (message != null) ...[
              const SizedBox(height: 16),
              Material(
                color: Colors.transparent,
                child: Text(
                  message!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.surfaceWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
