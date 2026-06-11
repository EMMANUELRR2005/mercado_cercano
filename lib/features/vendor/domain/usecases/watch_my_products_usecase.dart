import '../../../../shared/domain/entities/product_entity.dart';
import '../repositories/vendor_repository.dart';

/// Caso de uso: observar el catálogo del vendedor en tiempo real.
///
/// El stream re-emite la lista completa con cada cambio (publicar,
/// editar, agotar, renovar — propio u ocurrido en otro dispositivo).
class WatchMyProductsUsecase {
  const WatchMyProductsUsecase(this._repository);

  final VendorRepository _repository;

  Stream<List<ProductEntity>> call() => _repository.watchMyProducts();
}
