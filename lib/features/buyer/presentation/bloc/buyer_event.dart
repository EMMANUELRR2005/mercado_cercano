part of 'buyer_bloc.dart';

/// Eventos del flujo del comprador.
sealed class BuyerEvent {
  const BuyerEvent();
}

/// Carga la home: índice de precios del día + vendedores cercanos.
class BuyerHomeRequested extends BuyerEvent {
  const BuyerHomeRequested();
}

/// Busca productos con texto y/o filtros.
class BuyerSearchRequested extends BuyerEvent {
  const BuyerSearchRequested({
    this.query,
    this.filters = const SearchFilters(),
  });

  final String? query;
  final SearchFilters filters;
}

/// Solicita el detalle de un producto.
class BuyerProductDetailRequested extends BuyerEvent {
  const BuyerProductDetailRequested(this.productId);

  final String productId;
}

/// Solicita el perfil + catálogo de un vendedor.
class BuyerVendorDetailRequested extends BuyerEvent {
  const BuyerVendorDetailRequested(this.vendorId);

  final String vendorId;
}

/// El comprador reporta un precio observado.
class BuyerPriceReported extends BuyerEvent {
  const BuyerPriceReported({
    required this.productName,
    required this.price,
    required this.unit,
    required this.zone,
  });

  final String productName;
  final double price;
  final String unit;
  final String zone;
}
