import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/core_providers.dart';
import '../../data/datasources/reputation_remote_datasource.dart';
import '../../data/repositories/reputation_repository_impl.dart';
import '../../domain/repositories/reputation_repository.dart';
import '../../domain/usecases/get_vendor_ratings_usecase.dart';
import '../../domain/usecases/report_fraud_usecase.dart';
import '../../domain/usecases/submit_rating_usecase.dart';
import '../bloc/reputation_bloc.dart';

/// DI manual con Riverpod 3 (`Provider<T>`, sin codegen) para reputation.

/// Datasource remoto: mock o real según `AppConstants.useMockData`.
final reputationRemoteDatasourceProvider =
    Provider<ReputationRemoteDatasource>((ref) {
  if (AppConstants.useMockData) {
    return MockReputationRemoteDatasource();
  }
  return ReputationRemoteDatasourceImpl(ref.watch(dioClientProvider));
});

/// Repositorio de reputación.
final reputationRepositoryProvider = Provider<ReputationRepository>((ref) {
  return ReputationRepositoryImpl(
    ref.watch(reputationRemoteDatasourceProvider),
  );
});

/// Caso de uso: obtener calificaciones de un vendedor.
final getVendorRatingsUsecaseProvider = Provider<GetVendorRatingsUsecase>(
  (ref) => GetVendorRatingsUsecase(ref.watch(reputationRepositoryProvider)),
);

/// Caso de uso: enviar calificación.
final submitRatingUsecaseProvider = Provider<SubmitRatingUsecase>(
  (ref) => SubmitRatingUsecase(ref.watch(reputationRepositoryProvider)),
);

/// Caso de uso: reportar fraude.
final reportFraudUsecaseProvider = Provider<ReportFraudUsecase>(
  (ref) => ReportFraudUsecase(ref.watch(reputationRepositoryProvider)),
);

/// Fábrica del BLoC de reputación.
///
/// Es `autoDispose` para cerrar el bloc cuando ya nadie lo escucha.
/// Las pantallas lo usan así:
/// `BlocProvider.value(value: ref.watch(reputationBlocProvider))` o
/// creando uno propio con los usecases de arriba.
final reputationBlocProvider = Provider.autoDispose<ReputationBloc>((ref) {
  final bloc = ReputationBloc(
    getVendorRatings: ref.watch(getVendorRatingsUsecaseProvider),
    submitRating: ref.watch(submitRatingUsecaseProvider),
    reportFraud: ref.watch(reportFraudUsecaseProvider),
  );
  ref.onDispose(bloc.close);
  return bloc;
});
