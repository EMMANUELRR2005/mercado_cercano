import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/vendor_stats_entity.dart';
import '../bloc/vendor_bloc.dart';
import '../providers/vendor_provider.dart';

/// Estadísticas del negocio (cuerpo del shell `/vendor/stats`).
class VendorStatsScreen extends ConsumerStatefulWidget {
  const VendorStatsScreen({super.key});

  @override
  ConsumerState<VendorStatsScreen> createState() => _VendorStatsScreenState();
}

class _VendorStatsScreenState extends ConsumerState<VendorStatsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(vendorStatsBlocProvider).add(const StatsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(vendorStatsBlocProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Estadísticas')),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: BlocBuilder<VendorStatsBloc, VendorStatsState>(
              bloc: bloc,
              builder: (context, state) {
                return switch (state) {
                  VendorStatsLoading() || VendorStatsInitial() =>
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  VendorStatsError(:final message) => ErrorStateWidget(
                      message: message,
                      onRetry: () => bloc.add(const StatsRequested()),
                    ),
                  VendorStatsLoaded(:final stats) =>
                    _StatsContent(stats: stats),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsContent extends StatelessWidget {
  const _StatsContent({required this.stats});

  final VendorStatsEntity stats;

  /// Productos vigentes (disponibles y no vencidos).
  List<ProductEntity> get _activeProducts {
    final now = DateTime.now();
    return stats.topProducts
        .where((p) => p.isAvailable && p.expiresAt.isAfter(now))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Con publicaciones de 24 h, las vistas de los productos ACTIVOS
    // son las vistas "de hoy".
    final viewsToday =
        _activeProducts.fold<int>(0, (total, p) => total + p.viewCount);
    final mostViewed =
        stats.topProducts.isNotEmpty ? stats.topProducts.first : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // --- Resumen de hoy ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.visibility_outlined,
                          color: AppColors.primaryGreen, size: 20),
                      const SizedBox(height: 8),
                      Text(
                        '$viewsToday',
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Vistas hoy',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: AppColors.accentAmber, size: 20),
                      const SizedBox(height: 8),
                      Text(
                        mostViewed?.name ?? 'Sin productos',
                        style: AppTextStyles.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mostViewed != null
                            ? '${mostViewed.viewCount} vistas · '
                                'Producto más visto'
                            : 'Producto más visto',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // --- Métricas principales ---
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.visibility,
                label: 'Vistas totales',
                value: '${stats.totalViews}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.touch_app,
                label: 'Clics',
                value: '${stats.totalClicks}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.inventory_2,
                label: 'Activos',
                value: '${stats.activeProducts}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.star,
                          color: AppColors.accentAmber, size: 20),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            stats.averageRating.toStringAsFixed(1),
                            style: AppTextStyles.headlineMedium,
                          ),
                          const SizedBox(width: 6),
                          StarRating(
                            rating: stats.averageRating,
                            size: 14,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Calificación',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // --- Vistas por día (últimos 7 días) ---
        // Nota de monetización: las métricas avanzadas (comparativas,
        // exportar, demografía) irían detrás de PremiumFeatureGate.
        const Text('Vistas esta semana', style: AppTextStyles.titleLarge),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: _ViewsChart(viewsByDay: stats.viewsByDay),
        ),
        const SizedBox(height: 24),

        // --- Productos ordenados por vistas ---
        const Text('Tus productos más vistos',
            style: AppTextStyles.titleLarge),
        const SizedBox(height: 8),
        if (stats.topProducts.isEmpty)
          const EmptyStateWidget(
            icon: Icons.trending_up,
            title: 'Aún no hay datos',
            subtitle: 'Publica productos para empezar a medir.',
          )
        else
          ...stats.topProducts.map(
            (product) => _ProductViewsRow(
              product: product,
              // Barra proporcional al producto más visto.
              maxViews: stats.topProducts.first.viewCount,
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Fila de producto en el ranking de vistas: foto pequeña, nombre,
/// precio, barra proporcional al más visto y número de vistas.
class _ProductViewsRow extends StatelessWidget {
  const _ProductViewsRow({required this.product, required this.maxViews});

  final ProductEntity product;
  final int maxViews;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 40,
                height: 40,
                child: AppImage(
                  imageUrl: product.photoUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => Container(
                    color: AppColors.divider,
                    child: Icon(
                      product.category.icon,
                      size: 20,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: AppTextStyles.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      PriceTag(price: product.price, size: PriceTagSize.small),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: maxViews > 0
                          ? product.viewCount / maxViews
                          : 0,
                      minHeight: 6,
                      backgroundColor: AppColors.divider,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                Text('${product.viewCount}', style: AppTextStyles.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 20),
            const SizedBox(height: 8),
            Text(value, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gráfica de barras de vistas por día (fl_chart 1.x).
class _ViewsChart extends StatelessWidget {
  const _ViewsChart({required this.viewsByDay});

  final List<DailyViewsEntity> viewsByDay;

  @override
  Widget build(BuildContext context) {
    if (viewsByDay.isEmpty) {
      return const Center(
        child: Text('Sin datos esta semana', style: AppTextStyles.bodySmall),
      );
    }
    final dayFormat = DateFormat('E', 'es');
    final maxViews = viewsByDay
        .map((d) => d.views)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return BarChart(
      BarChartData(
        maxY: maxViews * 1.2,
        gridData: FlGridData(
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: AppColors.divider, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, _) => Text(
                value.toInt().toString(),
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textHint, fontSize: 10),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= viewsByDay.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    dayFormat.format(viewsByDay[i].date),
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textHint, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, _, rod, _) => BarTooltipItem(
              '${rod.toY.toInt()} vistas',
              AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < viewsByDay.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: viewsByDay[i].views.toDouble(),
                  width: 18,
                  color: AppColors.primaryGreen,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
