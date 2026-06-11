import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/core_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../bloc/reputation_bloc.dart';
import '../providers/reputation_provider.dart';

/// Pantalla para calificar a un vendedor (ruta `/shared/rating/:vendorId`).
///
/// Flujo: el comprador elige estrellas (obligatorio), escribe un
/// comentario opcional y envía. Al éxito: snackbar + pop.
class RatingScreen extends ConsumerStatefulWidget {
  const RatingScreen({super.key, required this.vendorId});

  final String vendorId;

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  double _stars = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// Etiqueta descriptiva según las estrellas elegidas.
  String get _starsLabel {
    if (_stars <= 0) return 'Toca las estrellas para calificar';
    if (_stars <= 1) return 'Muy mala experiencia';
    if (_stars <= 2) return 'Mala experiencia';
    if (_stars <= 3) return 'Regular';
    if (_stars <= 4) return 'Buena experiencia';
    return '¡Excelente!';
  }

  void _submit(BuildContext context) {
    context.read<ReputationBloc>().add(
          RatingSubmitted(
            vendorId: widget.vendorId,
            stars: _stars,
            comment: _commentController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReputationBloc>(
      create: (_) => ReputationBloc(
        getVendorRatings: ref.read(getVendorRatingsUsecaseProvider),
        submitRating: ref.read(submitRatingUsecaseProvider),
        reportFraud: ref.read(reportFraudUsecaseProvider),
        activityLogger: ref.read(activityLoggerProvider),
      ),
      child: BlocConsumer<ReputationBloc, ReputationState>(
        listener: (context, state) {
          if (state is RatingSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Gracias por tu calificación!'),
                backgroundColor: AppColors.successGreen,
              ),
            );
            context.pop();
          } else if (state is ReputationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state is ReputationSubmitting;
          return Scaffold(
            appBar: AppBar(title: const Text('Calificar vendedor')),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      '¿Cómo fue tu experiencia con este vendedor?',
                      style: AppTextStyles.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: StarRating(
                        rating: _stars,
                        interactive: !isSubmitting,
                        size: 48,
                        onChanged: (value) => setState(() => _stars = value),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _starsLabel,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _commentController,
                      enabled: !isSubmitting,
                      maxLines: 4,
                      maxLength: 280,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Comentario (opcional)',
                        hintText:
                            'Cuéntanos cómo te fue: precios, trato, calidad…',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: (_stars >= 1 && !isSubmitting)
                          ? () => _submit(context)
                          : null,
                      child: isSubmitting
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Enviar calificación'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
