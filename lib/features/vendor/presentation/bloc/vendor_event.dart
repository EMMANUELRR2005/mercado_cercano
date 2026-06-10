part of 'vendor_bloc.dart';

// ---------------------------------------------------------------------------
// Eventos del catálogo del vendedor
// ---------------------------------------------------------------------------

/// Eventos del [VendorProductsBloc].
sealed class VendorProductsEvent {
  const VendorProductsEvent();
}

/// Cargar (o recargar) los productos del vendedor.
final class MyProductsRequested extends VendorProductsEvent {
  const MyProductsRequested();
}

/// Publicar un producto nuevo a partir del borrador del flujo de 3 toques.
final class ProductCreated extends VendorProductsEvent {
  const ProductCreated(this.draft);

  final ProductDraft draft;
}

/// Guardar cambios de un producto existente.
final class ProductUpdated extends VendorProductsEvent {
  const ProductUpdated(this.product);

  final ProductEntity product;
}

/// Marcar un producto como agotado.
final class ProductMarkedSoldOut extends VendorProductsEvent {
  const ProductMarkedSoldOut(this.productId);

  final String productId;
}

/// Renovar un solo producto: extiende su vigencia 24 h desde ahora.
final class ProductRenewed extends VendorProductsEvent {
  const ProductRenewed(this.productId);

  final String productId;
}

/// Renovar todos los productos activos (+24 h de vigencia).
final class RenewAllRequested extends VendorProductsEvent {
  const RenewAllRequested();
}

// ---------------------------------------------------------------------------
// Eventos de estadísticas
// ---------------------------------------------------------------------------

/// Eventos del [VendorStatsBloc].
sealed class VendorStatsEvent {
  const VendorStatsEvent();
}

/// Cargar las métricas del negocio.
final class StatsRequested extends VendorStatsEvent {
  const StatsRequested();
}
