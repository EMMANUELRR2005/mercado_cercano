import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../domain/entities/price_entities.dart';

/// Tarjeta del índice de precios de un producto en la zona.
///
/// La tendencia se lee desde la óptica del comprador:
/// bajó = verde (bueno), subió = rojo (malo).
class PriceIndexCard extends StatelessWidget {
  const PriceIndexCard({super.key, required this.priceIndex, this.onTap});

  final PriceIndex priceIndex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final change = priceIndex.changeVsYesterday;
    final wentUp = change > 0;
    final isFlat = change == 0;
    final trendColor = isFlat
        ? AppColors.textSecondary
        : (wentUp ? AppColors.errorRed : AppColors.successGreen);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${priceIndex.productName} · ${priceIndex.unit}',
                      style: AppTextStyles.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      Formatters.formatQuetzal(priceIndex.averagePrice),
                      style: AppTextStyles.price,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mín ${Formatters.formatQuetzal(priceIndex.minPrice)} · '
                      'Máx ${Formatters.formatQuetzal(priceIndex.maxPrice)}',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      priceIndex.reportCount == 1
                          ? '1 reporte'
                          : '${priceIndex.reportCount} reportes',
                      style: AppTextStyles.labelMedium,
                    ),
                  ],
                ),
              ),
              // Tendencia vs. ayer.
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isFlat
                        ? Icons.trending_flat
                        : (wentUp ? Icons.arrow_upward : Icons.arrow_downward),
                    color: trendColor,
                    size: 26,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%',
                    style: AppTextStyles.labelLarge.copyWith(color: trendColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
