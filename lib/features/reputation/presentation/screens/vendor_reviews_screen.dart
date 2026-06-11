import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/core_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../domain/entities/rating_entity.dart';
import '../bloc/reputation_bloc.dart';
import '../providers/reputation_provider.dart';

/// Lista de reseñas de un vendedor con su promedio arriba.
class VendorReviewsScreen extends ConsumerWidget {
  const VendorReviewsScreen({super.key, required this.vendorId});

  final String vendorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BlocProvider<ReputationBloc>(
      create: (_) => ReputationBloc(
        getVendorRatings: ref.read(getVendorRatingsUsecaseProvider),
        submitRating: ref.read(submitRatingUsecaseProvider),
        reportFraud: ref.read(reportFraudUsecaseProvider),
        activityLogger: ref.read(activityLoggerProvider),
      )..add(VendorRatingsRequested(vendorId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Reseñas del vendedor')),
        body: BlocBuilder<ReputationBloc, ReputationState>(
          builder: (context, state) {
            return switch (state) {
              ReputationError(:final message) => ErrorStateWidget(
                  message: message,
                  onRetry: () => context
                      .read<ReputationBloc>()
                      .add(VendorRatingsRequested(vendorId)),
                ),
              VendorRatingsLoaded(:final ratings, :final average) =>
                ratings.isEmpty
                    ? const EmptyStateWidget(
                        title: 'Aún no hay reseñas',
                        subtitle:
                            'Sé la primera persona en calificar a este vendedor.',
                        icon: Icons.star_border,
                      )
                    : _ReviewsList(ratings: ratings, average: average),
              _ => const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primaryGreen),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _ReviewsList extends StatelessWidget {
  const _ReviewsList({required this.ratings, required this.average});

  final List<RatingEntity> ratings;
  final double average;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: ratings.length + 1,
      separatorBuilder: (_, index) =>
          index == 0 ? const SizedBox(height: 16) : const Divider(height: 24),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _AverageHeader(average: average, count: ratings.length);
        }
        return _ReviewTile(rating: ratings[index - 1]);
      },
    );
  }
}

/// Encabezado con el promedio grande y el total de reseñas.
class _AverageHeader extends StatelessWidget {
  const _AverageHeader({required this.average, required this.count});

  final double average;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            average.toStringAsFixed(1),
            style: AppTextStyles.displayMedium
                .copyWith(color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StarRating(rating: average, size: 22),
              const SizedBox(height: 4),
              Text(
                count == 1 ? '1 reseña' : '$count reseñas',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Una reseña individual: estrellas, comentario y fecha relativa.
class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.rating});

  final RatingEntity rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StarRating(rating: rating.stars, size: 18),
            const Spacer(),
            Text(
              Formatters.formatRelativeDate(rating.createdAt),
              style: AppTextStyles.labelMedium,
            ),
          ],
        ),
        if (rating.comment != null && rating.comment!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(rating.comment!, style: AppTextStyles.bodyMedium),
        ],
      ],
    );
  }
}
