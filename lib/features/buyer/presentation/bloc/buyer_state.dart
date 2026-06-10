part of 'buyer_bloc.dart';

/// Estados del flujo del comprador.
sealed class BuyerState {
  const BuyerState();
}

/// Estado inicial, sin datos.
class BuyerInitial extends BuyerState {
  const BuyerInitial();
}

/// Cargando datos.
class BuyerLoading extends BuyerState {
  const BuyerLoading();
}

/// Home cargada: índice del día + vendedores cercanos.
class BuyerHomeLoaded extends BuyerState {
  const BuyerHomeLoaded({required this.priceIndex, required this.vendors});

  /// Precios promedio HOY en la zona (para el carrusel horizontal).
  final List<PriceIndex> priceIndex;

  /// Vendedores cercanos ordenados por distancia.
  final List<NearbyVendor> vendors;
}

/// Resultados de búsqueda cargados.
class BuyerSearchLoaded extends BuyerState {
  const BuyerSearchLoaded({
    required this.results,
    required this.filters,
    this.query,
  });

  final List<SearchResult> results;
  final SearchFilters filters;
  final String? query;
}

/// Detalle de producto cargado.
class BuyerProductDetailLoaded extends BuyerState {
  const BuyerProductDetailLoaded(this.result);

  final SearchResult result;
}

/// Perfil + catálogo de un vendedor cargado.
class BuyerVendorDetailLoaded extends BuyerState {
  const BuyerVendorDetailLoaded(this.detail);

  final VendorDetail detail;
}

/// Enviando un reporte de precio.
class BuyerReportSubmitting extends BuyerState {
  const BuyerReportSubmitting();
}

/// El reporte de precio fue aceptado.
class BuyerReportSuccess extends BuyerState {
  const BuyerReportSuccess();
}

/// Error con mensaje listo para mostrar en UI (en español).
class BuyerError extends BuyerState {
  const BuyerError(this.message);

  final String message;
}
