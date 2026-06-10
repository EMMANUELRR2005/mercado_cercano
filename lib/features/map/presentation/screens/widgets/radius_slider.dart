import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Panel flotante con el slider del radio de búsqueda (1-20 km).
///
/// Mientras se arrastra solo cambia la etiqueta local; la recarga del
/// mapa se dispara en `onChangeEnd` para no saturar al backend.
class RadiusSlider extends StatefulWidget {
  const RadiusSlider({
    super.key,
    required this.radiusKm,
    required this.onRadiusChanged,
  });

  /// Radio activo en kilómetros.
  final double radiusKm;

  /// Se invoca al soltar el slider con el nuevo radio.
  final ValueChanged<double> onRadiusChanged;

  @override
  State<RadiusSlider> createState() => _RadiusSliderState();
}

class _RadiusSliderState extends State<RadiusSlider> {
  late double _value = widget.radiusKm;

  @override
  void didUpdateWidget(RadiusSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.radiusKm != widget.radiusKm) {
      _value = widget.radiusKm;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceWhite,
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.radar,
              size: 20,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 8),
            Text(
              'Radio: ${_value.round()} km',
              style: AppTextStyles.labelLarge,
            ),
            SizedBox(
              width: 160,
              child: Slider(
                value: _value.clamp(1, 20),
                min: 1,
                max: 20,
                divisions: 19,
                label: '${_value.round()} km',
                activeColor: AppColors.primaryGreen,
                onChanged: (value) => setState(() => _value = value),
                onChangeEnd: widget.onRadiusChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
