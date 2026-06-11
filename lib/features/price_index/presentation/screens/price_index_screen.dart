import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/domain/entities/price_entities.dart';
import '../../../../shared/widgets/widgets.dart';
import '../bloc/price_bloc.dart';
import '../providers/price_provider.dart';

/// Índice de precios de la canasta básica por zona (cuerpo del shell
/// `/buyer/price-index`).
class PriceIndexScreen extends ConsumerStatefulWidget {
  const PriceIndexScreen({super.key});

  @override
  ConsumerState<PriceIndexScreen> createState() => _PriceIndexScreenState();
}

class _PriceIndexScreenState extends ConsumerState<PriceIndexScreen> {
  late final PriceBloc _bloc;
  final _filterController = TextEditingController();
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _bloc = createPriceBloc(ref)..add(const PriceIndexRequested());
  }

  @override
  void dispose() {
    _bloc.close();
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Índice de precios')),
      body: Column(
        children: [
          // Al recuperar conexión se recarga el índice automáticamente.
          OfflineBanner(
            onReconnected: () => _bloc.add(const PriceIndexRequested()),
          ),
          Expanded(
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
                          _bloc.add(const PriceIndexRequested()),
                    ),
                  PriceIndexLoaded(
                    :final indices,
                    :final zone,
                    :final updatedAt,
                  ) =>
                    _buildIndex(indices, zone, updatedAt),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndex(
    List<PriceIndex> indices,
    String zone,
    DateTime updatedAt,
  ) {
    final filtered = _filter.isEmpty
        ? indices
        : indices
            .where(
              (i) => i.productName
                  .toLowerCase()
                  .contains(_filter.toLowerCase()),
            )
            .toList();

    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () async {
        _bloc.add(const PriceIndexRequested());
        await _bloc.stream.firstWhere((s) => s is! PriceLoading);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Encabezado: zona + última actualización.
          Row(
            children: [
              const Icon(Icons.place, color: AppColors.primaryGreen, size: 18),
              const SizedBox(width: 4),
              Expanded(
                child: Text(zone, style: AppTextStyles.titleSmall),
              ),
              Text(
                'Actualizado ${updatedAt.timeAgo}',
                style:
                    AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _filterController,
            onChanged: (v) => setState(() => _filter = v.trim()),
            decoration: InputDecoration(
              hintText: 'Filtrar producto…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _filter.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _filterController.clear();
                        setState(() => _filter = '');
                      },
                    ),
            ),
          ),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const EmptyStateWidget(
              icon: Icons.price_check,
              title: 'Sin resultados',
              subtitle: 'No hay reportes para ese producto en tu zona.',
            )
          else
            ...filtered.map(
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PriceIndexCard(
                  priceIndex: index,
                  onTap: () => context.pushNamed(
                    RouteNames.buyerPriceHistory,
                    pathParameters: {'product': index.productName},
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
