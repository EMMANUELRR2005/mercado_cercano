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
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/search_filters.dart';
import '../bloc/buyer_bloc.dart';
import '../providers/buyer_provider.dart';

/// Home del comprador (cuerpo del shell `/buyer/home`).
///
/// Enfocada en PRODUCTOS: saludo, búsqueda, categorías, grid "Cerca de
/// ti" (ordenado por distancia, paginado) y carrusel "Precios de hoy".
/// Sin estadísticas ni gráficas.
class BuyerHomeScreen extends ConsumerStatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  ConsumerState<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends ConsumerState<BuyerHomeScreen> {
  late final BuyerBloc _bloc;
  final _searchController = TextEditingController();

  /// Paginación local del grid: 10 productos por página.
  static const _pageSize = 10;
  int _visibleCount = _pageSize;

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

  /// Saludo según la hora local.
  String _greeting() {
    final hour = DateTime.now().hour;
    final authState = ref.read(authBlocProvider).state;
    final name = authState is Authenticated ? authState.user.name : null;
    final base = switch (hour) {
      >= 5 && < 12 => 'Buenos días',
      >= 12 && < 19 => 'Buenas tardes',
      _ => 'Buenas noches',
    };
    return name == null || name.isEmpty ? 'Hola' : '$base, $name';
  }

  void _submitSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    _searchController.clear();
    context.pushNamed(
      RouteNames.buyerSearch,
      queryParameters: {'q': query},
    );
  }

  void _openCategory(ProductCategory? category) {
    context.pushNamed(
      RouteNames.buyerSearch,
      queryParameters: {'category': ?category?.name},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Al recuperar conexión se recarga la home automáticamente.
              OfflineBanner(
                onReconnected: () =>
                    _bloc.add(const BuyerHomeRequested()),
              ),
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
                      BuyerHomeLoaded() => _buildHome(state),
                      _ => const SizedBox.shrink(),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHome(BuyerHomeLoaded state) {
    final visibleProducts =
        state.products.take(_visibleCount).toList();
    final hasMore = state.products.length > _visibleCount;

    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () async {
        _bloc.add(const BuyerHomeRequested());
        await _bloc.stream.firstWhere((s) => s is! BuyerLoading);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // --- Header: saludo + notificaciones ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_greeting(),
                          style: AppTextStyles.headlineMedium),
                      const SizedBox(height: 2),
                      Text(
                        '¿Qué buscas hoy?',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Alertas',
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () =>
                      context.go(RouteNames.buyerAlertsPath),
                ),
                IconButton(
                  tooltip: 'Configuración',
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () =>
                      context.pushNamed(RouteNames.settings),
                ),
              ],
            ),
          ),

          // --- Búsqueda prominente ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _submitSearch,
              decoration: InputDecoration(
                hintText: 'Buscar productos… Ej. tomate, pollo',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textHint),
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surfaceWhite,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.divider),
                ),
              ),
            ),
          ),

          // --- Categorías (con "Todos") ---
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: ProductCategory.values.length + 1,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return ActionChip(
                    avatar: const Icon(Icons.apps,
                        size: 18, color: Colors.white),
                    label: const Text('Todos'),
                    labelStyle: const TextStyle(color: Colors.white),
                    backgroundColor: AppColors.primaryGreen,
                    onPressed: () => _openCategory(null),
                  );
                }
                final category = ProductCategory.values[i - 1];
                return CategoryChip(
                  category: category,
                  onTap: () => _openCategory(category),
                );
              },
            ),
          ),

          // --- Cerca de ti: grid 2 columnas ---
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text('Cerca de ti', style: AppTextStyles.titleLarge),
          ),
          if (state.products.isEmpty)
            const EmptyStateWidget(
              icon: Icons.storefront_outlined,
              title: 'Aún no hay productos cerca de ti',
              subtitle: '¡Sé el primero en publicar!',
            )
          else ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: visibleProducts.length,
              itemBuilder: (context, i) => _ProductGridCard(
                result: visibleProducts[i],
                onTap: () => context.pushNamed(
                  RouteNames.buyerProductDetail,
                  pathParameters: {'id': visibleProducts[i].product.id},
                ),
              ),
            ),
            if (hasMore)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: OutlinedButton(
                  onPressed: () => setState(
                    () => _visibleCount += _pageSize,
                  ),
                  child: Text(
                    'Ver más '
                    '(${state.products.length - _visibleCount} restantes)',
                  ),
                ),
              ),
          ],

          // --- Precios de hoy ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Precios de hoy',
                      style: AppTextStyles.titleLarge),
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
        ],
      ),
    );
  }
}

/// Card de producto para el grid 2 columnas: foto, nombre, precio en
/// ámbar grande, vendedor y distancia.
class _ProductGridCard extends StatelessWidget {
  const _ProductGridCard({required this.result, this.onTap});

  final SearchResult result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final product = result.product;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(
                    imageUrl: product.photoUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      color: AppColors.divider,
                      child: Icon(
                        product.category.icon,
                        size: 40,
                        color: AppColors.textHint,
                      ),
                    ),
                    errorWidget: (_, _, _) => Container(
                      color: AppColors.divider,
                      child: Icon(
                        product.category.icon,
                        size: 40,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                  if (!product.isAvailable)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary
                              .withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Agotado',
                          style: TextStyle(
                              color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatters.formatQuetzal(product.price),
                        style: AppTextStyles.price
                            .copyWith(fontSize: 18),
                      ),
                      if (product.unit != null)
                        Text(
                          ' /${product.unit}',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textHint),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          result.vendor.name,
                          style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        Formatters.formatDistance(
                            result.distanceKm * 1000),
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textHint),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card compacta del carrusel "Precios de hoy": producto, promedio en
/// ámbar y flecha de tendencia (verde si bajó, rojo si subió).
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
