import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../entities/map_filters_entity.dart';
import '../entities/vendor_location_entity.dart';
import '../repositories/map_repository.dart';

/// Obtiene los vendedores cercanos a un punto, aplicando los filtros
/// locales (categoría y solo verificados) sobre el resultado del radio.
class GetVendorsNearbyUsecase {
  const GetVendorsNearbyUsecase(this._repository);

  final MapRepository _repository;

  Future<List<VendorLocationEntity>> call({
    required LatLng center,
    required MapFiltersEntity filters,
  }) async {
    final vendors = await _repository.getVendorsNearby(
      lat: center.latitude,
      lng: center.longitude,
      radiusKm: filters.radiusKm,
    );

    // Filtros de cliente: categoría y "solo verificados".
    return vendors.where((v) {
      if (filters.category != null && v.vendor.category != filters.category) {
        return false;
      }
      if (filters.onlyVerified && !v.vendor.isVerified) return false;
      return true;
    }).toList();
  }
}
