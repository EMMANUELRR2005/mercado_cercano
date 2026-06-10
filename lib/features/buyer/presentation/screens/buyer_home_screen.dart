import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/domain/entities/price_entities.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/widgets/widgets.dart';
import '../bloc/buyer_bloc.dart';
import '../providers/buyer_provider.dart';

/// Home del comprador (cuerpo del shell `/buyer/home`).
///
/// El bottom nav lo pone el shell del router; esta pantalla solo aporta
/// el contenido: búsqueda, categorías, índice de HOY y vendedores
/// cercanos.
class BuyerHomeScreen extends ConsumerStatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  ConsumerState<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends ConsumerState<BuyerHomeScreen> {
  late final BuyerBloc _bloc;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = createBuyerBloc(ref)..add(const BuyerHomeRequested());
  }

  @override
  void dispose() {
    _bloc.close();
    _searchController.dispose();
    super.dispose();
  }

  /// Al enviar la búsqueda se navega a /buyer/search con el query.
  void _submitSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    _searchController.clear();
    context.pushNamed(
      RouteNames.buyerSearch,
      queryParameters: {'q': query},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          toolbarHeight: 68,
          // Barra de búsqueda inline en el AppBar.
          title: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: _submitSearch,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: '¿Qué buscás hoy? Ej. tomate, pollo…',
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textHint),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textSecondary),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'buyer_home_map_fab',
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          onPressed: () => context.go(RouteNames.buyerMapPath),
          icon: const Icon(Icons.map),
          label: const Text('Mapa'),
        ),
        body: Column(
          children: [
            const OfflineBanner(),
            Expanded(
              child: BlocBuilder<BuyerBloc, BuyerState>(
                builder: (context, state) {
                  return switch (state) {
                    BuyerLoading() || BuyerInitial() => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    BuyerError(:final message) => ErrorStateWidget(
                        message: message,
                        onRetry: () =>
                            _bloc.add(const BuyerHomeRequested()),
                      ),
                    BuyerHomeLoaded() => _HomeContent(state: state),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final BuyerHomeLoaded state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () async {
        final bloc = context.read<BuyerBloc>();
        bloc.add(const BuyerHomeRequested());
        await bloc.stream.firstWhere((s) => s is! BuyerLoading);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          // --- Categorías ---
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Categorías', style: AppTextStyles.titleLarge),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: ProductCategory.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final category = ProductCategory.values[i];
                return CategoryChip(
                  category: category,
                  onTap: () => context.pushNamed(
                    RouteNames.buyerSearch,
                    queryParameters: {'category': category.name},
                  ),
                );
              },
            ),
          ),

          // --- Precio promedio HOY en tu zona ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Precio promedio HOY en tu zona',
                    style: AppTextStyles.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      context.go(RouteNames.buyerPriceIndexPath),
                  child: const Text(
                    'Ver todos',
                    style: TextStyle(color: AppColors.primaryGreen),
                  ),
                ),
              ],
            ),
          ),
          if (state.priceIndex.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Aún no hay reportes de precios hoy.',
                style: AppTextStyles.bodySmall,
              ),
            )
          else
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.priceIndex.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) =>
                    _TodayPriceCard(index: state.priceIndex[i]),
              ),
            ),

          // --- Vendedores cercanos ---
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text('Vendedores cercanos', style: AppTextStyles.titleLarge),
          ),
          if (state.vendors.isEmpty)
            const EmptyStateWidget(
              icon: Icons.storefront,
              title: 'No hay vendedores cerca',
              subtitle: 'Intenta ampliar el radio de búsqueda.',
            )
          else
            ...state.vendors.map(
              (v) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: VendorCard(
                  vendor: v.vendor,
                  distanceKm: v.distanceKm,
                  onTap: () => context.pushNamed(
                    RouteNames.buyerVendorProfile,
                    pathParameters: {'id': v.vendor.id},
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Card compacta del carrusel "HOY": producto, promedio en ámbar grande
/// y flecha de tendencia (verde si bajó, rojo si subió).
class _TodayPriceCard extends StatelessWidget {
  const _TodayPriceCard({required this.index});

  final PriceIndex index;

  @override
  Widget build(BuildContext context) {
    final change = index.changeVsYesterday;
    final wentUp = change > 0;
    final isFlat = change == 0;
    final trendColor = isFlat
        ? AppColors.textSecondary
        : (wentUp ? AppColors.errorRed : AppColors.successGreen);

    return SizedBox(
      width: 150,
      child: Card(
        elevation: 1,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.pushNamed(
            RouteNames.buyerPriceHistory,
            pathParameters: {'product': index.productName},
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${index.productName} · ${index.unit}',
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  Formatters.formatQuetzal(index.averagePrice),
                  style: AppTextStyles.price.copyWith(fontSize: 22),
                ),
                Row(
                  children: [
                    Icon(
                      isFlat
                          ? Icons.trending_flat
                          : (wentUp
                              ? Icons.arrow_upward
                              : Icons.arrow_downward),
                      size: 16,
                      color: trendColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}% '
                      'vs ayer',
                      style: AppTextStyles.labelMedium
                          .copyWith(color: trendColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
