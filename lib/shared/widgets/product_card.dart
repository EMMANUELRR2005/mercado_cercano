import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../domain/entities/product_entity.dart';
import 'app_image.dart';
import 'price_tag.dart';

/// Tarjeta de producto para listas y grillas del comprador.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.distanceKm,
    this.showViews = false,
    this.onTap,
  });

  final ProductEntity product;

  /// Distancia en kilómetros al vendedor (opcional).
  final double? distanceKm;

  /// Muestra el contador de vistas bajo el precio (catálogo del
  /// vendedor; los compradores no lo ven).
  final bool showViews;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImage(),
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
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      PriceTag(price: product.price),
                      if (product.unit != null) ...[
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '/ ${product.unit}',
                            style: AppTextStyles.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (distanceKm != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          Formatters.formatDistance(distanceKm! * 1000),
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                  if (showViews) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${product.viewCount} vistas',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: AppImage(
            imageUrl: product.photoUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => _CategoryPlaceholder(
              category: product.category,
            ),
            // Los photoUrl del mock pueden no resolver: fallback al
            // ícono de la categoría.
            errorWidget: (context, url, error) => _CategoryPlaceholder(
              category: product.category,
            ),
          ),
        ),
        // Badge "Destacado" (publicación premium del vendedor).
        if (product.isFeatured ?? false)
          Positioned(
            top: 8,
            left: 8,
            child: _Badge(
              label: 'Destacado',
              color: AppColors.accentAmber,
              icon: Icons.star,
            ),
          ),
        // Badge "Agotado".
        if (!product.isAvailable)
          Positioned(
            top: 8,
            right: 8,
            child: _Badge(label: 'Agotado', color: AppColors.errorRed),
          ),
      ],
    );
  }
}

/// Placeholder con el ícono de la categoría cuando no hay foto.
class _CategoryPlaceholder extends StatelessWidget {
  const _CategoryPlaceholder({required this.category});

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: category.pinColor.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Icon(category.icon, size: 40, color: category.pinColor),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
