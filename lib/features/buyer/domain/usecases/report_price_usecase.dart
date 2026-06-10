import '../../../../core/errors/failure.dart';
import '../repositories/buyer_repository.dart';

/// Reporta un precio observado en el mercado (crowdsourcing).
class ReportPriceUsecase {
  const ReportPriceUsecase(this._repository);

  final BuyerRepository _repository;

  Future<(Failure?, bool?)> call({
    required String productName,
    required double price,
    required String unit,
    required String zone,
  }) {
    return _repository.reportPrice(
      productName: productName,
      price: price,
      unit: unit,
      zone: zone,
    );
  }
}
