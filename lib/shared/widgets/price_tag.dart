import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';

/// Tamaños disponibles para [PriceTag].
enum PriceTagSize { small, medium, large }

/// Etiqueta de precio en Quetzales con tendencia opcional.
///
/// Si `showTrend` es true y hay `previousPrice`, muestra una flecha:
/// roja hacia arriba si el precio subió, verde hacia abajo si bajó.
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.price,
    this.size = PriceTagSize.medium,
    this.showTrend = false,
    this.previousPrice,
  });

  final double price;
  final PriceTagSize size;
  final bool showTrend;
  final double? previousPrice;

  double get _fontSize => switch (size) {
        PriceTagSize.small => 14,
        PriceTagSize.medium => 18,
        PriceTagSize.large => 28,
      };

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: _fontSize,
      fontWeight: FontWeight.bold,
      height: 1.2,
      color: AppColors.accentAmber,
    );

    Widget? trendIcon;
    if (showTrend && previousPrice != null && previousPrice != price) {
      final wentUp = price > previousPrice!;
      trendIcon = Icon(
        wentUp ? Icons.arrow_upward : Icons.arrow_downward,
        size: _fontSize * 0.8,
        // Para el comprador: que suba el precio es malo (rojo),
        // que baje es bueno (verde).
        color: wentUp ? AppColors.errorRed : AppColors.successGreen,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(Formatters.formatQuetzal(price), style: style),
        if (trendIcon != null) ...[
          const SizedBox(width: 2),
          trendIcon,
        ],
      ],
    );
  }
}
