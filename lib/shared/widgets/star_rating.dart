import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';

/// Estrellas de calificación: display (con medias estrellas) o input.
///
/// En modo interactivo, tocar la estrella N asigna `N.0` y dispara
/// [onChanged] con feedback háptico ligero.
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.interactive = false,
    this.onChanged,
    this.size = 20,
  });

  /// Valor actual de 0 a 5 (admite medias estrellas en display).
  final double rating;

  /// Si es true, las estrellas responden al tacto.
  final bool interactive;

  /// Callback al elegir un valor (solo en modo interactivo).
  final ValueChanged<double>? onChanged;

  /// Tamaño de cada estrella.
  final double size;

  IconData _iconFor(int index) {
    // index es 0-based: estrella llena si rating cubre la posición,
    // media si cubre al menos la mitad.
    if (rating >= index + 1) return Icons.star;
    if (rating >= index + 0.5) return Icons.star_half;
    return Icons.star_border;
  }

  void _onStarTap(int index) {
    HapticFeedback.lightImpact();
    onChanged?.call((index + 1).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final star = Icon(
          _iconFor(index),
          size: size,
          color: AppColors.accentAmber,
        );
        if (!interactive) return star;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onStarTap(index),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.05),
            child: star,
          ),
        );
      }),
    );
  }
}
