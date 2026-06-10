import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/route_names.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../shared/domain/entities/product_entity.dart';
import '../../../../../shared/widgets/widgets.dart';
import '../../../domain/entities/vendor_location_entity.dart';

/// Bottom sheet con el detalle de un vendedor al tocar su pin.
class VendorInfoBottomSheet extends StatelessWidget {
  const VendorInfoBottomSheet({super.key, required this.vendorLocation});

  final VendorLocationEntity vendorLocation;

  /// Muestra el sheet con esquinas redondeadas y animación slide-up.
  static Future<void> show(
    BuildContext context,
    VendorLocationEntity vendorLocation,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => VendorInfoBottomSheet(vendorLocation: vendorLocation),
    );
  }

  // -----------------------------------------------------------------
  // Acciones de contacto
  // -----------------------------------------------------------------

  /// Marca el teléfono del vendedor con la app de llamadas.
  Future<void> _call(String phone) async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri(scheme: 'tel', path: digits);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Abre WhatsApp con el número del vendedor (formato Guatemala: 502).
  Future<void> _openWhatsApp(String whatsapp) async {
    final digits = whatsapp.replaceAll(RegExp(r'\D'), '');
    // Si ya trae el código de país no lo duplicamos.
    final number = digits.startsWith('502') ? digits : '502$digits';
    final uri = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendor = vendorLocation.vendor;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle del sheet.
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Encabezado: avatar + nombre + categoría ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      vendor.category.pinColor.withValues(alpha: 0.15),
                  foregroundImage: vendor.photoUrl != null
                      ? NetworkImage(vendor.photoUrl!)
                      : null,
                  child: Text(
                    vendor.name.isNotEmpty
                        ? vendor.name[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: vendor.category.pinColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vendor.name, style: AppTextStyles.titleLarge),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Chip de categoría con el color del pin.
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: vendor.category.pinColor
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  vendor.category.icon,
                                  size: 14,
                                  color: vendor.category.pinColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  vendor.category.label,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: vendor.category.pinColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (vendor.isVerified)
                            const VerifiedBadge(compact: true),
                          if (!vendorLocation.isOnline)
                            Text(
                              'Fuera de línea',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.errorRed,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // --- Rating + distancia ---
            Row(
              children: [
                StarRating(rating: vendor.rating, size: 18),
                const SizedBox(width: 6),
                Text(
                  '${vendor.rating.toStringAsFixed(1)} '
                  '(${vendor.totalRatings})',
                  style: AppTextStyles.bodySmall,
                ),
                const Spacer(),
                if (vendorLocation.distanceMeters != null) ...[
                  const Icon(
                    Icons.place_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    Formatters.formatDistance(
                      vendorLocation.distanceMeters!,
                    ),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ],
            ),

            // --- Mejor precio de hoy ---
            if (vendorLocation.lowestPriceToday != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accentAmber.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('Desde ', style: AppTextStyles.bodyMedium),
                    PriceTag(
                      price: vendorLocation.lowestPriceToday!,
                      size: PriceTagSize.medium,
                    ),
                    const Text(' hoy', style: AppTextStyles.bodyMedium),
                    if (vendorLocation.lowestPriceProductName != null) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          vendorLocation.lowestPriceProductName!,
                          style: AppTextStyles.bodySmall,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            if (vendor.description != null) ...[
              const SizedBox(height: 12),
              Text(vendor.description!, style: AppTextStyles.bodyMedium),
            ],

            const SizedBox(height: 20),

            // --- Acciones ---
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Ruta del perfil del comprador: /buyer/vendor/:id
                      context.pushNamed(
                        RouteNames.buyerVendorProfile,
                        pathParameters: {'id': vendor.id},
                      );
                    },
                    icon: const Icon(Icons.storefront, size: 18),
                    label: const Text('Ver productos'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    side: const BorderSide(color: AppColors.primaryGreen),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => _call(vendor.phone),
                  child: const Icon(Icons.call, size: 20),
                ),
                if (vendor.whatsapp != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.successGreen,
                      side: const BorderSide(color: AppColors.successGreen),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => _openWhatsApp(vendor.whatsapp!),
                    child: const Icon(Icons.chat, size: 20),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
