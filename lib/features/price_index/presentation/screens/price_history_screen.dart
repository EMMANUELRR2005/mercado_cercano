import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/domain/entities/price_entities.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../../../../shared/widgets/widgets.dart';
import '../bloc/price_bloc.dart';
import '../providers/price_provider.dart';

/// Rangos disponibles para la gráfica de historial.
enum _Range {
  week(7, '7d'),
  month(30, '30d'),
  quarter(90, '90d');

  const _Range(this.days, this.label);

  final int days;
  final String label;
}

/// Historial de precios de un producto — función Premium (Plan Pro).
class PriceHistoryScreen extends ConsumerStatefulWidget {
  const PriceHistoryScreen({super.key, required this.productName});

  final String productName;

  @override
  ConsumerState<PriceHistoryScreen> createState() =>
      _PriceHistoryScreenState();
}

class _PriceHistoryScreenState extends ConsumerState<PriceHistoryScreen> {
  late final PriceBloc _bloc;
  _Range _range = _Range.month;

  // En demo el usuario arranca como free; "Mejorar a Pro" desbloquea
  // localmente. El Agente 7 / backend conectará la suscripción real.
  UserSubscription _subscription = UserSubscription.free;

  @override
  void initState() {
    super.initState();
    _bloc = createPriceBloc(ref)
      ..add(PriceHistoryRequested(widget.productName));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _upgrade() {
    setState(() => _subscription = UserSubscription.pro);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Plan Pro activado (demo)'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Historial · ${widget.productName}')),
      body: PremiumFeatureGate(
        featureName: 'Historial de precios',
        subscription: _subscription,
        onUpgrade: _upgrade,
        child: BlocBuilder<PriceBloc, PriceState>(
          bloc: _bloc,
          builder: (context, state) {
            return switch (state) {
              PriceLoading() || PriceInitial() => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                ),
              PriceError(:final message) => ErrorStateWidget(
                  message: message,
                  onRetry: () =>
                      _bloc.add(PriceHistoryRequested(widget.productName)),
                ),
              PriceHistoryLoaded(:final history) => _HistoryContent(
                  history: history,
                  range: _range,
                  onRangeChanged: (r) => setState(() => _range = r),
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({
    required this.history,
    required this.range,
    required this.onRangeChanged,
  });

  final PriceHistory history;
  final _Range range;
  final ValueChanged<_Range> onRangeChanged;

  /// Puntos visibles según el rango elegido (orden cronológico).
  List<PricePoint> get _visible {
    final cutoff = DateTime.now().subtract(Duration(days: range.days));
    final points =
        history.points.where((p) => p.date.isAfter(cutoff)).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    return points;
  }

  @override
  Widget build(BuildContext context) {
    final points = _visible;
    if (points.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.show_chart,
        title: 'Sin datos de precios',
        subtitle: 'Aún no hay reportes en este rango de fechas.',
      );
    }

    final latest = points.last.price;
    // Comparación contra el precio de hace ~7 días.
    final weekAgoCut = DateTime.now().subtract(const Duration(days: 7));
    final older = points.where((p) => p.date.isBefore(weekAgoCut)).toList();
    final weekAgo = older.isNotEmpty ? older.last.price : null;
    final diff = weekAgo != null ? latest - weekAgo : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PriceTag(price: latest, size: PriceTagSize.large),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '/ ${history.unit} hoy',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
        if (diff != null && diff < 0) ...[
          const SizedBox(height: 4),
          Text(
            '↓ ${Formatters.formatQuetzal(diff.abs())} menos que hace 7 días',
            style: AppTextStyles.titleSmall
                .copyWith(color: AppColors.successGreen),
          ),
        ] else if (diff != null && diff > 0) ...[
          const SizedBox(height: 4),
          Text(
            '↑ ${Formatters.formatQuetzal(diff)} más que hace 7 días',
            style:
                AppTextStyles.titleSmall.copyWith(color: AppColors.errorRed),
          ),
        ],
        const SizedBox(height: 16),
        Center(
          child: SegmentedButton<_Range>(
            segments: _Range.values
                .map(
                  (r) => ButtonSegment(value: r, label: Text(r.label)),
                )
                .toList(),
            selected: {range},
            onSelectionChanged: (s) => onRangeChanged(s.first),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(height: 260, child: _Chart(points: points)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: AppColors.primaryGreen, label: history.unit),
            const SizedBox(width: 16),
            const _LegendDot(
              color: AppColors.textSecondary,
              label: 'Promedio de zona',
              dashed: true,
            ),
          ],
        ),
      ],
    );
  }
}

/// Gráfica de línea: precio del producto + promedio de zona (punteado).
class _Chart extends StatelessWidget {
  const _Chart({required this.points});

  final List<PricePoint> points;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM', 'es');
    final spots = <FlSpot>[];
    final zoneSpots = <FlSpot>[];
    for (var i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), points[i].price));
      final zone = points[i].zoneAverage;
      if (zone != null) {
        zoneSpots.add(FlSpot(i.toDouble(), zone));
      }
    }
    final labelStep = (points.length / 4).ceil().clamp(1, points.length);

    return LineChart(
      LineChartData(
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
              reservedSize: 44,
              getTitlesWidget: (value, _) => Text(
                'Q${value.toStringAsFixed(0)}',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textHint),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: labelStep.toDouble(),
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= points.length) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    dateFormat.format(points[i].date),
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textHint, fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touched) => touched.map((spot) {
              final i = spot.x.toInt();
              final date = i >= 0 && i < points.length
                  ? dateFormat.format(points[i].date)
                  : '';
              return LineTooltipItem(
                '${Formatters.formatQuetzal(spot.y)}\n$date',
                AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primaryGreen,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryGreen.withValues(alpha: 0.08),
            ),
          ),
          if (zoneSpots.isNotEmpty)
            LineChartBarData(
              spots: zoneSpots,
              isCurved: true,
              color: AppColors.textSecondary,
              barWidth: 2,
              dashArray: [6, 4],
              dotData: const FlDotData(show: false),
            ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    this.dashed = false,
  });

  final Color color;
  final String label;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: dashed
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    2,
                    (_) => Container(width: 3, height: 3, color: Colors.white),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
