import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/domain/entities/vendor_entity.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../domain/entities/search_filters.dart';
import '../bloc/buyer_bloc.dart';
import '../providers/buyer_provider.dart';

/// Perfil público de un vendedor: datos, contacto y catálogo vigente.
class VendorProfileScreen extends ConsumerStatefulWidget {
  const VendorProfileScreen({super.key, required this.vendorId});

  final String vendorId;

  @override
  ConsumerState<VendorProfileScreen> createState() =>
      _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> {
  late final BuyerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = createBuyerBloc(ref)
      ..add(BuyerVendorDetailRequested(widget.vendorId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _launch(BuildContext context, Uri uri) async {
    // En simulador puede no haber app de teléfono/WhatsApp instalada.
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la aplicación')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendedor')),
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
                    _bloc.add(BuyerVendorDetailRequested(widget.vendorId)),
              ),
            BuyerVendorDetailLoaded(:final detail) => _ProfileContent(
                detail: detail,
                onCall: (phone) => _launch(context, Uri.parse('tel:$phone')),
                onWhatsApp: (number) => _launch(
                  context,
                  Uri.parse('https://wa.me/502$number'),
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.detail,
    required this.onCall,
    required this.onWhatsApp,
  });

  final VendorDetail detail;
  final ValueChanged<String> onCall;
  final ValueChanged<String> onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final VendorEntity vendor = detail.vendor;
    // El número de WhatsApp puede diferir del teléfono de contacto.
    final whatsapp =
        (vendor.whatsapp ?? vendor.phone).replaceAll(RegExp(r'\D'), '');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primaryGreenLight,
              foregroundImage: appImageProvider(vendor.photoUrl),
              child: Text(
                vendor.name.isNotEmpty ? vendor.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendor.name, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      StarRating(rating: vendor.rating),
                      const SizedBox(width: 6),
                      Text(
                        '${vendor.rating.toStringAsFixed(1)} '
                        '(${vendor.totalRatings})',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CategoryChip(category: vendor.category),
                      if (vendor.isVerified) const VerifiedBadge(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (detail.distanceKm != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.place,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                'A ${Formatters.formatDistance(detail.distanceKm! * 1000)} '
                'de ti',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
        if (vendor.description != null) ...[
          const SizedBox(height: 12),
          Text(vendor.description!, style: AppTextStyles.bodyMedium),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => onCall(vendor.phone),
                icon: const Icon(Icons.call),
                label: const Text('Llamar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                ),
                onPressed: () => onWhatsApp(whatsapp),
                icon: const Icon(Icons.chat),
                label: const Text('WhatsApp'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.pushNamed(
                  RouteNames.rating,
                  pathParameters: {'vendorId': vendor.id},
                ),
                icon: const Icon(Icons.star_border),
                label: const Text('Calificar'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Productos de hoy (${detail.products.length})',
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: 8),
        if (detail.products.isEmpty)
          const EmptyStateWidget(
            icon: Icons.inventory_2_outlined,
            title: 'Sin productos publicados hoy',
            subtitle: 'Vuelve más tarde para ver su catálogo.',
          )
        else
          ...detail.products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ProductCard(
                product: product,
                onTap: () => context.pushNamed(
                  RouteNames.buyerProductDetail,
                  pathParameters: {'id': product.id},
                ),
              ),
            ),
          ),
      ],
    );
  }
}
