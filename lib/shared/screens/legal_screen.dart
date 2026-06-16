import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Pantalla legal: enlaces a la Política de Privacidad y los Términos del
/// Servicio (App Store y Google Play exigen que sean accesibles desde la
/// app), más un resumen de privacidad de datos.
///
/// Las URLs viven en [AppConstants] (placeholders hasta que se publiquen
/// las reales — ver MIGRATION.md).
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo abrir $url'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacidad y Términos')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.shield_outlined,
                color: AppColors.primaryGreen),
            title: const Text('Política de Privacidad',
                style: AppTextStyles.titleSmall),
            subtitle: const Text('Cómo tratamos tus datos'),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => _open(context, AppConstants.privacyPolicyUrl),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined,
                color: AppColors.primaryGreen),
            title: const Text('Términos del Servicio',
                style: AppTextStyles.titleSmall),
            subtitle: const Text('Condiciones de uso de la app'),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => _open(context, AppConstants.termsOfServiceUrl),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tu privacidad en MercadoCercano',
                    style: AppTextStyles.titleSmall),
                const SizedBox(height: 8),
                _bullet(
                  'Tu ubicación se usa solo en el momento para mostrarte '
                  'vendedores cercanos y calcular distancias. Nunca se '
                  'almacena en nuestros servidores.',
                ),
                _bullet(
                  'Tu correo, nombre y foto se usan para tu cuenta y perfil. '
                  'Puedes borrar tu cuenta y tus datos desde Configuración.',
                ),
                _bullet(
                  'Los reportes de precios que contribuyes al índice '
                  'colaborativo se conservan de forma anónima.',
                ),
                const SizedBox(height: 8),
                Text(
                  'Dudas o solicitudes de datos: ${AppConstants.supportEmail}',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8),
            child: Icon(Icons.check_circle_outline,
                size: 16, color: AppColors.primaryGreen),
          ),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
