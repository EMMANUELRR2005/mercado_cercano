import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../domain/entities/product_entity.dart';
import '../domain/entities/vendor_entity.dart';
import 'star_rating.dart';
import 'verified_badge.dart';

/// Tarjeta de vendedor para listas de "vendedores cercanos".
class VendorCard extends StatelessWidget {
  const VendorCard({
    super.key,
    required this.vendor,
    this.distanceKm,
    this.onTap,
  });

  final VendorEntity vendor;

  /// Distancia en kilómetros al vendedor (opcional).
  final double? distanceKm;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _Avatar(vendor: vendor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            vendor.name,
                            style: AppTextStyles.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (vendor.isVerified) ...[
                          const SizedBox(width: 6),
                          const VerifiedBadge(compact: true),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        StarRating(rating: vendor.rating, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${vendor.rating.toStringAsFixed(1)} '
                          '(${vendor.totalRatings})',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _CategoryMiniChip(category: vendor.category),
                        if (distanceKm != null) ...[
                          const SizedBox(width: 8),
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
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}

/// Avatar circular: foto del vendedor o su inicial.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.vendor});

  final VendorEntity vendor;

  @override
  Widget build(BuildContext context) {
    final initial = vendor.name.isNotEmpty ? vendor.name[0].toUpperCase() : '?';
    final hasPhoto = vendor.photoUrl != null && vendor.photoUrl!.isNotEmpty;

    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
      foregroundImage:
          hasPhoto ? CachedNetworkImageProvider(vendor.photoUrl!) : null,
      // Si la foto falla en cargar, queda la inicial de fondo.
      onForegroundImageError: hasPhoto ? (_, _) {} : null,
      child: Text(
        initial,
        style: AppTextStyles.titleLarge.copyWith(
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}

/// Chip pequeño de categoría (solo lectura).
class _CategoryMiniChip extends StatelessWidget {
  const _CategoryMiniChip({required this.category});

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: category.pinColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 12, color: category.pinColor),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: category.pinColor,
            ),
          ),
        ],
      ),
    );
  }
}
