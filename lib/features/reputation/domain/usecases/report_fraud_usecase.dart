import '../../../../core/errors/failure.dart';
import '../entities/report_entity.dart';
import '../repositories/reputation_repository.dart';

/// Reporta un posible fraude de un vendedor.
class ReportFraudUsecase {
  const ReportFraudUsecase(this._repository);

  final ReputationRepository _repository;

  Future<(Failure?, ReportEntity?)> call({
    required String vendorId,
    required String reason,
    String? description,
  }) {
    if (reason.trim().isEmpty) {
      return Future.value(
        (const ValidationFailure('Indica el motivo del reporte.'), null),
      );
    }
    return _repository.reportFraud(
      vendorId: vendorId,
      reason: reason.trim(),
      description: (description != null && description.trim().isNotEmpty)
          ? description.trim()
          : null,
    );
  }
}
