import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/core_providers.dart';
import '../../core/theme/app_colors.dart';

/// Franja superior que aparece cuando el dispositivo pierde conexión.
///
/// Escucha `networkInfoProvider.onConnectivityChanged` y se anima al
/// aparecer/desaparecer. Colocar arriba del contenido (ej. en una
/// Column dentro del Scaffold o como `appBar.bottom`).
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkInfo = ref.watch(networkInfoProvider);

    return StreamBuilder<bool>(
      stream: networkInfo.onConnectivityChanged,
      // Asumimos conexión hasta que el stream diga lo contrario,
      // para no mostrar un falso "sin conexión" al arrancar.
      initialData: true,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;
        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isOnline
              ? const SizedBox(width: double.infinity, height: 0)
              : Container(
                  width: double.infinity,
                  color: AppColors.accentAmber,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: const SafeArea(
                    bottom: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, size: 16, color: Colors.white),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Sin conexión — mostrando datos guardados',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
