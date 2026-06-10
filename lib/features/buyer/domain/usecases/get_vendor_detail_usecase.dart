import '../../../../core/errors/failure.dart';
import '../entities/search_filters.dart';
import '../repositories/buyer_repository.dart';

/// Obtiene el perfil de un vendedor con su catálogo.
class GetVendorDetailUsecase {
  const GetVendorDetailUsecase(this._repository);

  final BuyerRepository _repository;

  Future<(Failure?, VendorDetail?)> call(String vendorId) {
    return _repository.getVendorDetail(vendorId);
  }
}
