import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/route_names.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../shared/domain/entities/product_entity.dart';
import '../../../../../shared/domain/entities/vendor_entity.dart';
import '../../../../../shared/widgets/widgets.dart';
import '../../../domain/entities/vendor_location_entity.dart';
import '../../providers/map_provider.dart';

/// Bottom sheet con el detalle de un vendedor al tocar su pin.
///
/// Arranca al 45% de la pantalla y se expande hasta el 85% arrastrando;
/// el catálogo se carga EN VIVO desde Firestore (con shimmer mientras
/// llega el primer snapshot).
class VendorInfoBottomSheet extends ConsumerStatefulWidget {
  const VendorInfoBottomSheet({super.key, required this.vendorLocation});

  final VendorLocationEntity vendorLocation;

  /// Muestra el sheet: blanco, esquinas superiores de 20px, drag handle
  /// y expandible al arrastrar.
  static Future<void> show(
    BuildContext context,
    VendorLocationEntity vendorLocation,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      // El contenedor interno pinta el fondo blanco con el radius.
      backgroundColor: Colors.transparent,
      builder: (_) => VendorInfoBottomSheet(vendorLocation: vendorLocation),
    );
  }

  @override
  ConsumerState<VendorInfoBottomSheet> createState() =>
      _VendorInfoBottomSheetState();
}

class _VendorInfoBottomSheetState extends ConsumerState<VendorInfoBottomSheet> {
  /// Catálogo en vivo del vendedor; se suscribe una sola vez.
  late final Stream<List<ProductEntity>> _productsStream;

  @override
  void initState() {
    super.initState();
    // countViews: los productos del preview suman una vista (una sola
    // vez por sesión por producto).
    _productsStream = ref
        .read(vendorProductsServiceProvider)
        .watch(widget.vendorLocation.vendor.id, countViews: true);
  }

  // -----------------------------------------------------------------
  // Acciones de contacto y navegación
  // -----------------------------------------------------------------

  /// Abre la app de mapas nativa con la ruta a pie hacia el vendedor.
  ///
  /// iOS: Apple Maps primero, Google Maps de respaldo.
  /// Android: Google Maps primero, Waze de respaldo.
  Future<void> _openNavigation(double lat, double lng) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=$lat,$lng&travelmode=walking',
    );
    final appleMapsUrl = Uri.parse('maps://?daddr=$lat,$lng&dirflg=w');
    final wazeUrl = Uri.parse('waze://?ll=$lat,$lng&navigate=yes');

    // iOS: Apple Maps primero.
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        await canLaunchUrl(appleMapsUrl)) {
      await launchUrl(appleMapsUrl);
      return;
    }
    // Universal: la URL https abre la app de Google Maps si está
    // instalada, o el navegador con la ruta trazada si no.
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      return;
    }
    // Último recurso: Waze.
    if (await canLaunchUrl(wazeUrl)) {
      await launchUrl(wazeUrl);
    }
  }

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

  void _openVendorProfile() {
    Navigator.of(context).pop();
    // Ruta del perfil del comprador: /buyer/vendor/:id
    context.pushNamed(
      RouteNames.buyerVendorProfile,
      pathParameters: {'id': widget.vendorLocation.vendor.id},
    );
  }

  // -----------------------------------------------------------------
  // Build
  // -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final vendorLocation = widget.vendorLocation;
    final vendor = vendorLocation.vendor;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.45,
      minChildSize: 0.30,
      maxChildSize: 0.85,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle para cerrar/expandir deslizando (siempre visible).
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  _buildHeader(vendor, vendorLocation),
                  const SizedBox(height: 12),
                  _buildRatingAndDistance(vendor, vendorLocation),
                  if (vendorLocation.lowestPriceToday != null) ...[
                    const SizedBox(height: 12),
                    _buildLowestPrice(vendorLocation),
                  ],
                  if (vendor.description != null) ...[
                    const SizedBox(height: 12),
                    Text(vendor.description!,
                        style: AppTextStyles.bodyMedium),
                  ],
                  const SizedBox(height: 16),
                  _buildProductsPreview(),
                  const SizedBox(height: 16),
                  _buildActionButtons(vendor),
                  const SizedBox(height: 8),
                  // Catálogo completo en el perfil del vendedor.
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                    ),
                    onPressed: _openVendorProfile,
                    icon: const Text('Ver todos los productos'),
                    label: const Icon(Icons.arrow_forward, size: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Encabezado: avatar 60px + nombre + categoría/insignias ---

  Widget _buildHeader(VendorEntity vendor, VendorLocationEntity vendorLocation) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
          foregroundImage: appImageProvider(vendor.photoUrl),
          child: Text(
            vendor.name.isNotEmpty ? vendor.name[0].toUpperCase() : '?',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vendor.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Chip verde de la categoría principal.
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          vendor.category.icon,
                          size: 14,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vendor.category.label,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (vendor.isVerified) const VerifiedBadge(compact: true),
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
    );
  }

  // --- Calificación + distancia ---

  Widget _buildRatingAndDistance(
    VendorEntity vendor,
    VendorLocationEntity vendorLocation,
  ) {
    return Row(
      children: [
        StarRating(rating: vendor.rating, size: 18),
        const SizedBox(width: 6),
        Text(
          '${vendor.rating.toStringAsFixed(1)} · '
          '${vendor.totalRatings} reseñas',
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
            'A ${Formatters.formatDistance(vendorLocation.distanceMeters!)}'
            ' de ti',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ],
    );
  }

  // --- Mejor precio de hoy ---

  Widget _buildLowestPrice(VendorLocationEntity vendorLocation) {
    return Container(
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
    );
  }

  // --- Primeros 3 productos en vivo (shimmer mientras cargan) ---

  Widget _buildProductsPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Productos de hoy', style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: StreamBuilder<List<ProductEntity>>(
            stream: _productsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const _ProductsShimmer();
              }
              final products = snapshot.data ?? const <ProductEntity>[];
              if (products.isEmpty) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sin productos publicados hoy.',
                    style: AppTextStyles.bodySmall,
                  ),
                );
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length > 3 ? 3 : products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) =>
                    _ProductMiniCard(product: products[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- Fila de acciones: Cómo llegar | Llamar | WhatsApp ---

  Widget _buildActionButtons(VendorEntity vendor) {
    final vendorLocation = widget.vendorLocation;
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => _openNavigation(
              vendorLocation.latitude,
              vendorLocation.longitude,
            ),
            icon: const Icon(Icons.directions, size: 18),
            label: const Text('Cómo llegar', maxLines: 1),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              side: const BorderSide(color: AppColors.primaryGreen),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () => _call(vendor.phone),
            icon: const Icon(Icons.call, size: 18),
            label: const Text('Llamar', maxLines: 1),
          ),
        ),
        if (vendor.whatsapp != null) ...[
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
            onPressed: () => _openWhatsApp(vendor.whatsapp!),
            child: const Icon(Icons.chat, size: 20),
          ),
        ],
      ],
    );
  }
}

/// Mini tarjeta de producto del preview: foto 40px + nombre + precio.
class _ProductMiniCard extends StatelessWidget {
  const _ProductMiniCard({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 40,
              height: 40,
              child: AppImage(
                imageUrl: product.photoUrl,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Container(
                  color: AppColors.divider,
                  child: Icon(
                    product.category.icon,
                    size: 20,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 96),
                child: Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelMedium,
                ),
              ),
              Text(
                Formatters.formatQuetzal(product.price),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.accentAmber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shimmer manual (sin paquetes): tres placeholders grises que pulsan
/// mientras llega el primer snapshot del catálogo.
class _ProductsShimmer extends StatefulWidget {
  const _ProductsShimmer();

  @override
  State<_ProductsShimmer> createState() => _ProductsShimmerState();
}

class _ProductsShimmerState extends State<_ProductsShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat(reverse: true);

  late final Animation<Color?> _color = ColorTween(
    begin: const Color(0xFFE5E7EB),
    end: const Color(0xFFF3F4F6),
  ).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _color,
      builder: (context, _) {
        Widget box(double width, double height, double radius) => Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: _color.value,
                borderRadius: BorderRadius.circular(radius),
              ),
            );
        return Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              box(40, 40, 8),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  box(72, 10, 4),
                  const SizedBox(height: 6),
                  box(48, 10, 4),
                ],
              ),
              if (i < 2) const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }
}
