part of 'vendor_bloc.dart';

// ---------------------------------------------------------------------------
// Estados del catálogo del vendedor
// ---------------------------------------------------------------------------

/// Estados del [VendorProductsBloc].
sealed class VendorProductsState {
  const VendorProductsState();
}

/// Estado inicial: aún no se pidió nada.
final class VendorProductsInitial extends VendorProductsState {
  const VendorProductsInitial();
}

/// Cargando la lista por primera vez (sin datos previos que mostrar).
final class VendorProductsLoading extends VendorProductsState {
  const VendorProductsLoading();
}

/// Falló la carga inicial: no hay lista que mostrar.
final class VendorProductsError extends VendorProductsState {
  const VendorProductsError(this.message);

  /// Mensaje user-friendly en español (viene de un `Failure`).
  final String message;
}

/// Base de los estados "con lista": la UI siempre puede renderizar
/// [products] aunque haya una acción en curso o un error puntual.
sealed class VendorProductsReady extends VendorProductsState {
  const VendorProductsReady(this.products);

  final List<ProductEntity> products;
}

/// Lista cargada y en reposo.
final class VendorProductsLoaded extends VendorProductsReady {
  const VendorProductsLoaded(super.products);
}

/// Hay una acción en curso (publicar, editar, agotar, renovar).
final class VendorProductActionInProgress extends VendorProductsReady {
  const VendorProductActionInProgress(super.products);
}

/// La última acción terminó bien.
final class VendorProductActionSuccess extends VendorProductsReady {
  const VendorProductActionSuccess(
    super.products, {
    required this.message,
    this.createdProduct,
  });

  /// Mensaje de éxito en español para snackbar.
  final String message;

  /// Producto recién publicado (solo en [ProductCreated]); la pantalla
  /// de publicación lo usa para disparar la animación de éxito.
  final ProductEntity? createdProduct;
}

/// La última acción falló, pero la lista previa sigue disponible.
final class VendorProductActionFailure extends VendorProductsReady {
  const VendorProductActionFailure(super.products, {required this.message});

  /// Mensaje user-friendly en español (viene de un `Failure`).
  final String message;
}

// ---------------------------------------------------------------------------
// Estados de estadísticas
// ---------------------------------------------------------------------------

/// Estados del [VendorStatsBloc].
sealed class VendorStatsState {
  const VendorStatsState();
}

final class VendorStatsInitial extends VendorStatsState {
  const VendorStatsInitial();
}

final class VendorStatsLoading extends VendorStatsState {
  const VendorStatsLoading();
}

final class VendorStatsLoaded extends VendorStatsState {
  const VendorStatsLoaded(this.stats);

  final VendorStatsEntity stats;
}

final class VendorStatsError extends VendorStatsState {
  const VendorStatsError(this.message);

  /// Mensaje user-friendly en español (viene de un `Failure`).
  final String message;
}
