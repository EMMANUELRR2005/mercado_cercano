import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/search_filters.dart';
import '../bloc/buyer_bloc.dart';
import '../providers/buyer_provider.dart';

/// Detalle de un producto: foto grande, precio en ámbar, vendedor y
/// acciones (cómo llegar, reportar precio).
class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late final BuyerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = createBuyerBloc(ref)
      ..add(BuyerProductDetailRequested(widget.productId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Producto')),
      body: BlocBuilder<BuyerBloc, BuyerState>(
        bloc: _bloc,
        builder: (context, state) {
          return switch (state) {
            BuyerLoading() || BuyerInitial() => const Center(
                child:
                    CircularProgressIndicator(color: AppColors.primaryGreen),
              ),
            BuyerError(:final message) => ErrorStateWidget(
                message: message,
                onRetry: () =>
                    _bloc.add(BuyerProductDetailRequested(widget.productId)),
              ),
            BuyerProductDetailLoaded(:final result) =>
              _DetailContent(result: result),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.result});

  final SearchResult result;

  @override
  Widget build(BuildContext context) {
    final ProductEntity product = result.product;
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        // Foto grande con fallback al ícono de la categoría.
        AspectRatio(
          aspectRatio: 4 / 3,
          child: CachedNetworkImage(
            imageUrl: product.photoUrl,
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(
              color: AppColors.divider,
              child: Icon(
                product.category.icon,
                size: 64,
                color: AppColors.textHint,
              ),
            ),
            errorWidget: (_, _, _) => Container(
              color: AppColors.divider,
              child: Icon(
                product.category.icon,
                size: 64,
                color: AppColors.textHint,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: AppTextStyles.headlineMedium,
                    ),
                  ),
                  if (product.isFeatured ?? false)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentAmberLight
                            .withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Destacado',
                        style: TextStyle(
                          color: AppColors.accentAmber,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PriceTag(price: product.price, size: PriceTagSize.large),
                  if (product.unit != null) ...[
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '/ ${product.unit}',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CategoryChip(category: product.category),
                  const SizedBox(width: 8),
                  if (!product.isAvailable)
                    const Chip(
                      label: Text('Agotado'),
                      backgroundColor: AppColors.divider,
                    ),
                ],
              ),
              if (product.description != null &&
                  product.description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(product.description!, style: AppTextStyles.bodyMedium),
              ],
              const SizedBox(height: 24),
              const Text('Vendedor', style: AppTextStyles.titleLarge),
              const SizedBox(height: 8),
              VendorCard(
                vendor: result.vendor,
                distanceKm: result.distanceKm,
                onTap: () => context.pushNamed(
                  RouteNames.buyerVendorProfile,
                  pathParameters: {'id': result.vendor.id},
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.go(RouteNames.buyerMapPath),
                      icon: const Icon(Icons.directions),
                      label: const Text('Cómo llegar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          context.pushNamed(RouteNames.reportPrice),
                      icon: const Icon(Icons.campaign_outlined),
                      label: const Text('Reportar precio'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
