import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/firebase/activity_logger.dart';
import '../../domain/entities/rating_entity.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/usecases/get_vendor_ratings_usecase.dart';
import '../../domain/usecases/report_fraud_usecase.dart';
import '../../domain/usecases/submit_rating_usecase.dart';

part 'reputation_event.dart';
part 'reputation_state.dart';

/// BLoC de reputación: calificaciones y reportes de fraude.
class ReputationBloc extends Bloc<ReputationEvent, ReputationState> {
  // Parámetros nombrados privados (Dart 3.12): el caller usa
  // `getVendorRatings:`, `submitRating:` y `reportFraud:`.
  ReputationBloc({
    required this._getVendorRatings,
    required this._submitRating,
    required this._reportFraud,
    this._activityLogger,
  }) : super(const ReputationInitial()) {
    on<VendorRatingsRequested>(_onVendorRatingsRequested);
    on<RatingSubmitted>(_onRatingSubmitted);
    on<FraudReported>(_onFraudReported);
  }

  final GetVendorRatingsUsecase _getVendorRatings;
  final SubmitRatingUsecase _submitRating;
  final ReportFraudUsecase _reportFraud;

  /// Auditoría best-effort (calificaciones).
  final ActivityLogger? _activityLogger;

  Future<void> _onVendorRatingsRequested(
    VendorRatingsRequested event,
    Emitter<ReputationState> emit,
  ) async {
    emit(const ReputationLoading());
    final (failure, ratings) = await _getVendorRatings(event.vendorId);
    if (failure != null) {
      emit(ReputationError(failure.message));
      return;
    }
    final list = ratings ?? const <RatingEntity>[];
    // Promedio simple de estrellas; 0 si aún no hay reseñas.
    final average = list.isEmpty
        ? 0.0
        : list.fold<double>(0, (sum, r) => sum + r.stars) / list.length;
    emit(VendorRatingsLoaded(ratings: list, average: average));
  }

  Future<void> _onRatingSubmitted(
    RatingSubmitted event,
    Emitter<ReputationState> emit,
  ) async {
    emit(const ReputationSubmitting());
    final (failure, rating) = await _submitRating(
      vendorId: event.vendorId,
      stars: event.stars,
      comment: event.comment,
    );
    if (failure != null) {
      emit(ReputationError(failure.message));
      return;
    }
    emit(RatingSubmitSuccess(rating!));
    unawaited(_activityLogger?.log(
      ActivityAction.ratingSubmitted,
      metadata: {'vendorId': event.vendorId, 'stars': event.stars},
    ));
  }

  Future<void> _onFraudReported(
    FraudReported event,
    Emitter<ReputationState> emit,
  ) async {
    emit(const ReputationSubmitting());
    final (failure, report) = await _reportFraud(
      vendorId: event.vendorId,
      reason: event.reason,
      description: event.description,
    );
    if (failure != null) {
      emit(ReputationError(failure.message));
      return;
    }
    emit(FraudReportSuccess(report!));
  }
}
