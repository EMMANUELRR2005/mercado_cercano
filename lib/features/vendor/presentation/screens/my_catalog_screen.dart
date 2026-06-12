import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/widgets/widgets.dart';
import '../bloc/vendor_bloc.dart';
import '../providers/vendor_provider.dart';

/// Catálogo del vendedor con tabs Activos / Agotados / Vencidos.
///
/// Es el cuerpo del shell `/vendor/catalog` (el router pone el bottom nav).
class MyCatalogScreen extends ConsumerStatefulWidget {
  const MyCatalogScreen({super.key});

  @override
  ConsumerState<MyCatalogScreen> createState() => _MyCatalogScreenState();
}

class _MyCatalogScreenState extends ConsumerState<MyCatalogScreen> {
  @override
  void initState() {
    super.initState();
    // Catálogo en TIEMPO REAL: con Firestore cada cambio re-emite la
    // lista (el evento es idempotente, una sola suscripción por bloc).
    ref
        .read(vendorProductsBlocProvider)
        .add(const MyProductsWatchStarted());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(vendorProductsBlocProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi catálogo'),
          bottom: const TabBar(
            labelColor: AppColors.primaryGreen,
            indicatorColor: AppColors.primaryGreen,
            tabs: [
              Tab(text: 'Activos'),
              Tab(text: 'Agotados'),
              Tab(text: 'Vencidos'),
            ],
          ),
        ),
        body: Column(
          children: [
            const OfflineBanner(),
            Expanded(
              child: BlocConsumer<VendorProductsBloc, VendorProductsState>(
                bloc: bloc,
                listener: (context, state) {
                  final route = ModalRoute.of(context);
                  if (route != null && !route.isCurrent) return;

                  if (state is VendorProductActionSuccess &&
                      state.createdProduct == null) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.successGreen,
                      ));
                  } else if (state is VendorProductActionFailure) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.errorRed,
                      ));
                  }
                },
                builder: (context, state) {
                  return switch (state) {
                    VendorProductsInitial() ||
                    VendorProductsLoading() =>
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    VendorProductsError(:final message) => ErrorStateWidget(
                        message: message,
                        onRetry: () => bloc.add(const MyProductsRequested()),
                      ),
                    VendorProductsReady(:final products) => TabBarView(
                        children: [
                          _ProductsTab(
                            products: _activeOf(products),
                            emptyTitle:
                                'Aún no tienes productos publicados',
                            emptySubtitle: '¡Publica tu primero!',
                            bloc: bloc,
                          ),
                          _ProductsTab(
                            products: _soldOutOf(products),
                            emptyTitle: 'No tienes productos agotados',
                            emptySubtitle:
                                'Cuando algo se te acabe, márcalo como agotado.',
                            bloc: bloc,
                          ),
                          _ProductsTab(
                            products: _expiredOf(products),
                            emptyTitle: 'No tienes productos vencidos',
                            emptySubtitle:
                                '¡Buen trabajo! Tus publicaciones están al día.',
                            bloc: bloc,
                          ),
                        ],
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Disponibles y con la publicación vigente.
  List<ProductEntity> _activeOf(List<ProductEntity> products) {
    final now = DateTime.now();
    return products
        .where((p) => p.isAvailable && p.expiresAt.isAfter(now))
        .toList();
  }

  /// Marcados como agotados (sin importar su vigencia).
  List<ProductEntity> _soldOutOf(List<ProductEntity> products) {
    return products.where((p) => !p.isAvailable).toList();
  }

  /// Disponibles pero con la publicación vencida (ya no se muestran
  /// a los compradores hasta renovarlos).
  List<ProductEntity> _expiredOf(List<ProductEntity> products) {
    final now = DateTime.now();
    return products
        .where((p) => p.isAvailable && !p.expiresAt.isAfter(now))
        .toList();
  }
}

/// Grilla de productos de una pestaña, con pull-to-refresh y acciones.
class _ProductsTab extends StatelessWidget {
  const _ProductsTab({
    required this.products,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.bloc,
  });

  final List<ProductEntity> products;
  final String emptyTitle;
  final String emptySubtitle;
  final VendorProductsBloc bloc;

  Future<void> _refresh() async {
    bloc.add(const MyProductsRequested());
    await bloc.stream.firstWhere((s) => s is! VendorProductsLoading);
  }

  void _openEdit(BuildContext context, ProductEntity product) {
    context.pushNamed(
      RouteNames.vendorEdit,
      pathParameters: {'productId': product.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      // El RefreshIndicator necesita un scrollable incluso en vacío.
      return RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.6,
              child: EmptyStateWidget(
                icon: Icons.inventory_2_outlined,
                title: emptyTitle,
                subtitle: emptySubtitle,
                actionLabel: 'Publicar tu primer producto',
                onAction: () => context.push(RouteNames.vendorPublishPath),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: _refresh,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          // Más alto que el grid del comprador: la tarjeta del vendedor
          // agrega la fila de vistas bajo el precio.
          childAspectRatio: 0.72,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Stack(
            children: [
              Positioned.fill(
                child: ProductCard(
                  product: product,
                  showViews: true,
                  onTap: () => _openEdit(context, product),
                ),
              ),
              // Menú de acciones sobre la esquina de la tarjeta.
              Positioned(
                bottom: 0,
                right: 0,
                child: Material(
                  color: Colors.transparent,
                  child: PopupMenuButton<String>(
                    tooltip: 'Acciones',
                    icon: const Icon(
                      Icons.more_vert,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _openEdit(context, product);
                        case 'soldOut':
                          bloc.add(ProductMarkedSoldOut(product.id));
                        case 'renew':
                          bloc.add(ProductRenewed(product.id));
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Editar'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      if (product.isAvailable)
                        const PopupMenuItem(
                          value: 'soldOut',
                          child: ListTile(
                            leading:
                                Icon(Icons.remove_shopping_cart_outlined),
                            title: Text('Marcar agotado'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'renew',
                        child: ListTile(
                          leading: Icon(Icons.autorenew),
                          title: Text('Renovar'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
