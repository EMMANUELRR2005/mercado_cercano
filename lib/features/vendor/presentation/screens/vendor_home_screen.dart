import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/vendor_profile.dart';
import '../bloc/vendor_bloc.dart';
import '../providers/vendor_provider.dart';

/// Pantalla principal del vendedor ("Mi negocio").
///
/// Es el cuerpo del shell `/vendor/home` (el router pone el bottom nav).
/// Muestra el resumen del día, el banner de productos por vencer con
/// "Renovar todo" y la lista de productos con su estado visual.
class VendorHomeScreen extends ConsumerStatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  ConsumerState<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends ConsumerState<VendorHomeScreen> {
  /// Perfil del negocio para el header (foto, nombre, zona).
  VendorProfile? _profile;

  /// Catálogo en TIEMPO REAL para el resumen del header
  /// ("Hoy: X vistas · Y productos activos").
  late final Stream<List<ProductEntity>> _myProductsStream;

  @override
  void initState() {
    super.initState();
    _myProductsStream = ref.read(watchMyProductsUsecaseProvider)();
    // Carga inicial de productos y métricas (el mock responde en 500 ms).
    final productsBloc = ref.read(vendorProductsBlocProvider);
    if (productsBloc.state is VendorProductsInitial) {
      productsBloc.add(const MyProductsRequested());
    }
    final statsBloc = ref.read(vendorStatsBlocProvider);
    if (statsBloc.state is VendorStatsInitial) {
      statsBloc.add(const StatsRequested());
    }
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile =
          await ref.read(vendorProfileDatasourceProvider).getMyProfile();
      if (mounted) setState(() => _profile = profile);
    } catch (_) {
      // Header con valores por defecto si el perfil no carga.
    }
  }

  /// Avatar del negocio: URL de Storage, base64 (Firestore) o ruta local.
  ImageProvider? _photoProvider() => appImageProvider(_profile?.photoUrl);

  Future<void> _editProfile() async {
    await context.pushNamed(RouteNames.vendorSetup);
    // Al volver de editar, refrescar el header.
    _loadProfile();
  }

  /// Productos disponibles que vencen en menos de 2 horas.
  List<ProductEntity> _expiringSoon(List<ProductEntity> products) {
    final now = DateTime.now();
    return products.where((p) {
      if (!p.isAvailable) return false;
      final remaining = p.expiresAt.difference(now);
      return !remaining.isNegative && remaining < const Duration(hours: 2);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(vendorProductsBlocProvider);
    final statsBloc = ref.watch(vendorStatsBlocProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        // Header del negocio: foto (50 px), nombre en bold y zona.
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              foregroundImage: _photoProvider(),
              child: const Icon(Icons.storefront,
                  size: 24, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _profile?.businessName.isNotEmpty ?? false
                        ? _profile!.businessName
                        : 'Mi negocio',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Resumen del día en VIVO: cada vista o publicación
                  // nueva re-emite el stream y actualiza el texto.
                  StreamBuilder<List<ProductEntity>>(
                    stream: _myProductsStream,
                    builder: (context, snapshot) {
                      final products =
                          snapshot.data ?? const <ProductEntity>[];
                      final now = DateTime.now();
                      final active = products
                          .where((p) =>
                              p.isAvailable && p.expiresAt.isAfter(now))
                          .toList();
                      final views = active.fold<int>(
                          0, (total, p) => total + p.viewCount);
                      return Text(
                        snapshot.hasData
                            ? 'Hoy: $views vistas · '
                                '${active.length} productos activos'
                            : (_profile?.neighborhood ?? ''),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Editar mi negocio',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _editProfile,
          ),
          IconButton(
            tooltip: 'Configuración',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.pushNamed(RouteNames.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        tooltip: 'Publicar producto',
        onPressed: () => context.push(RouteNames.vendorPublishPath),
        child: const Icon(Icons.add, size: 40),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: BlocConsumer<VendorProductsBloc, VendorProductsState>(
              bloc: bloc,
              listener: (context, state) {
                // Evita snackbars duplicados cuando otra pantalla
                // (editar/publicar) está encima de esta.
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
                  VendorProductsReady(:final products) =>
                    _buildContent(context, bloc, statsBloc, state, products),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    VendorProductsBloc bloc,
    VendorStatsBloc statsBloc,
    VendorProductsState state,
    List<ProductEntity> products,
  ) {
    if (products.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.storefront_outlined,
        title: 'Aún no tienes productos publicados',
        subtitle: 'Publica tu primer producto en menos de 3 toques.',
        actionLabel: 'Publicar mi primer producto',
        onAction: () => context.push(RouteNames.vendorPublishPath),
      );
    }

    final expiring = _expiringSoon(products);
    final isProcessing = state is VendorProductActionInProgress;
    final now = DateTime.now();
    final activeCount = products
        .where((p) => p.isAvailable && p.expiresAt.isAfter(now))
        .length;

    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () async {
        bloc.add(const MyProductsRequested());
        statsBloc.add(const StatsRequested());
        // Espera a que el bloc salga del estado de carga.
        await bloc.stream.firstWhere(
          (s) => s is! VendorProductsLoading,
        );
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          _SummaryCard(activeCount: activeCount, statsBloc: statsBloc),
          if (expiring.isNotEmpty) ...[
            const SizedBox(height: 12),
            _ExpiringBanner(
              count: expiring.length,
              isProcessing: isProcessing,
              onRenewAll: () => bloc.add(const RenewAllRequested()),
            ),
          ],
          const SizedBox(height: 16),
          Text('Mis productos', style: AppTextStyles.titleLarge),
          const SizedBox(height: 8),
          for (final product in products) ...[
            _ProductRow(
              product: product,
              onEdit: () => context.pushNamed(
                RouteNames.vendorEdit,
                pathParameters: {'productId': product.id},
              ),
              onMarkSoldOut: () => bloc.add(ProductMarkedSoldOut(product.id)),
              onRenew: () => bloc.add(ProductRenewed(product.id)),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

/// Card resumen: productos activos hoy y vistas de hoy.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.activeCount, required this.statsBloc});

  final int activeCount;
  final VendorStatsBloc statsBloc;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColors.primaryGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _SummaryMetric(
                icon: Icons.inventory_2_outlined,
                value: '$activeCount',
                label: 'Productos activos hoy',
              ),
            ),
            Container(
              width: 1,
              height: 48,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            Expanded(
              child: BlocBuilder<VendorStatsBloc, VendorStatsState>(
                bloc: statsBloc,
                builder: (context, state) {
                  // Vistas de hoy = último punto de la serie de 7 días.
                  final todayViews = switch (state) {
                    VendorStatsLoaded(:final stats)
                        when stats.viewsByDay.isNotEmpty =>
                      '${stats.viewsByDay.last.views}',
                    _ => '—',
                  };
                  return _SummaryMetric(
                    icon: Icons.visibility_outlined,
                    value: todayViews,
                    label: 'Vistas de hoy',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
        ),
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Banner ámbar prominente: productos por vencer + "Renovar todo".
class _ExpiringBanner extends StatelessWidget {
  const _ExpiringBanner({
    required this.count,
    required this.isProcessing,
    required this.onRenewAll,
  });

  final int count;
  final bool isProcessing;
  final VoidCallback onRenewAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentAmber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accentAmber),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined,
              color: AppColors.accentAmber, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              count == 1
                  ? 'Tienes 1 producto que vence en menos de 2 horas'
                  : 'Tienes $count productos que vencen en menos de 2 horas',
              style: AppTextStyles.titleSmall,
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentAmber,
              foregroundColor: Colors.white,
            ),
            onPressed: isProcessing ? null : onRenewAll,
            child: isProcessing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Renovar todo'),
          ),
        ],
      ),
    );
  }
}

/// Fila de producto con indicador de estado y menú contextual.
class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.product,
    required this.onEdit,
    required this.onMarkSoldOut,
    required this.onRenew,
  });

  final ProductEntity product;
  final VoidCallback onEdit;
  final VoidCallback onMarkSoldOut;
  final VoidCallback onRenew;

  /// Verde = activo, gris = agotado, rojo = por vencer o vencido.
  Color get _statusColor {
    if (!product.isAvailable) return AppColors.textHint;
    final remaining = product.expiresAt.difference(DateTime.now());
    if (remaining.isNegative || remaining < const Duration(hours: 2)) {
      return AppColors.errorRed;
    }
    return AppColors.successGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Indicador de estado.
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              // Foto mini.
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: AppImage(
                    imageUrl: product.photoUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => _imageFallback(),
                    errorWidget: (_, _, _) => _imageFallback(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
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
                      children: [
                        PriceTag(
                          price: product.price,
                          size: PriceTagSize.small,
                        ),
                        if (product.unit != null)
                          Flexible(
                            child: Text(
                              ' / ${product.unit}',
                              style: AppTextStyles.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (!product.isAvailable) ...[
                          const SizedBox(width: 8),
                          Text(
                            'Agotado',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.errorRed,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    ProductExpiryStepper(expiresAt: product.expiresAt),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Acciones',
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                    case 'soldOut':
                      onMarkSoldOut();
                    case 'renew':
                      onRenew();
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
                        leading: Icon(Icons.remove_shopping_cart_outlined),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: product.category.pinColor.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Icon(
        product.category.icon,
        color: product.category.pinColor,
        size: 26,
      ),
    );
  }
}
