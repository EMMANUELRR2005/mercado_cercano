import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/firebase/firestore_service.dart';
import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/entities/vendor_entity.dart';
import '../../domain/entities/vendor_location_entity.dart';
import '../models/vendor_location_model.dart';
import 'map_remote_datasource.dart';
import 'map_websocket_datasource.dart';

/// Implementación REAL del mapa contra Cloud Firestore
/// (`AppConstants.useFirestore`). Cumple los dos contratos:
///
/// - [MapRemoteDatasource]: carga puntual de vendedores activos.
/// - [MapWebsocketDatasource]: con Firestore no hace falta WebSocket —
///   el `snapshots()` de la colección `vendors` ES el canal en tiempo
///   real; cada cambio se traduce a eventos `VendorLocationUpdated` /
///   `VendorWentOffline`.
class MapFirestoreDatasource
    implements MapRemoteDatasource, MapWebsocketDatasource {
  MapFirestoreDatasource(this._firestore);

  final FirestoreService _firestore;

  static const _vendors = 'vendors';
  static const _products = 'products';

  /// Cache del precio más bajo por vendedor (evita releer `products` en
  /// cada snapshot; el costo es 1 query por vendedor cada [_priceTtl]).
  final Map<String, ({double? price, String? name, DateTime at})>
      _lowestPriceCache = {};
  static const _priceTtl = Duration(minutes: 5);

  // -------------------------------------------------------------------
  // Carga puntual (MapRemoteDatasource)
  // -------------------------------------------------------------------

  @override
  Future<List<VendorLocationModel>> getVendorsNearby({
    required double lat,
    required double lng,
    required double radiusKm,
  }) async {
    final docs = await _firestore.getCollection(
      _vendors,
      queryBuilder: (q) => q.where('isActive', isEqualTo: true),
    );

    final result = <VendorLocationModel>[];
    for (final doc in docs) {
      final model = await _modelFromDoc(doc);
      if (model == null) continue;

      // Filtro por radio en cliente (Firestore no tiene queries
      // geoespaciales nativas; con geohashing se optimizaría a futuro).
      final distance = Geolocator.distanceBetween(
        lat,
        lng,
        model.latitude,
        model.longitude,
      );
      if (distance > radiusKm * 1000) continue;
      result.add(model.copyWith(distanceMeters: distance));
    }
    return result;
  }

  // -------------------------------------------------------------------
  // Tiempo real (MapWebsocketDatasource sobre snapshots)
  // -------------------------------------------------------------------

  @override
  Stream<VendorRealtimeEvent> watchVendors() async* {
    await for (final docs in _firestore.streamCollection(
      _vendors,
      queryBuilder: (q) => q.where('isActive', isEqualTo: true),
    )) {
      // Cada snapshot re-emite el estado de todos los vendedores; el
      // bloc hace upsert por id, así que basta con eventos de update.
      for (final doc in docs) {
        final model = await _modelFromDoc(doc);
        if (model == null) continue;
        yield VendorLocationUpdated(model.toEntity());
      }
    }
  }

  @override
  void dispose() {
    // El stream de snapshots se cancela con la suscripción del bloc;
    // no hay conexión propia que cerrar.
    _lowestPriceCache.clear();
  }

  // -------------------------------------------------------------------
  // Mapeo Firestore → modelo
  // -------------------------------------------------------------------

  /// Construye el modelo desde un doc de `vendors`; null si el doc no
  /// tiene coordenadas (no se puede pintar en el mapa).
  Future<VendorLocationModel?> _modelFromDoc(
    Map<String, dynamic> doc,
  ) async {
    final coordinates = doc['coordinates'];
    if (coordinates is! GeoPoint) return null;

    final vendorId = doc['id'] as String;
    final lowest = await _lowestPriceOf(vendorId);

    final neighborhood = doc['neighborhood'] as String?;
    final zone = doc['zone'] as String?;
    final address = [
      if (neighborhood != null && neighborhood.isNotEmpty) neighborhood,
      if (zone != null && zone.isNotEmpty) zone,
    ].join(', ');

    return VendorLocationModel(
      vendor: VendorEntity(
        id: vendorId,
        name: (doc['businessName'] as String?) ?? 'Vendedor',
        phone: (doc['phone'] as String?) ?? '',
        whatsapp: doc['whatsapp'] as String?,
        category: _categoryFromName(doc['category'] as String?),
        rating: ((doc['rating'] as num?) ?? 0).toDouble(),
        totalRatings: ((doc['totalRatings'] as num?) ?? 0).toInt(),
        isVerified: (doc['isVerified'] as bool?) ?? false,
        photoUrl: doc['photoUrl'] as String?,
        description: doc['description'] as String?,
        address: address.isEmpty ? null : address,
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      ),
      latitude: coordinates.latitude,
      longitude: coordinates.longitude,
      isOnline: (doc['isActive'] as bool?) ?? true,
      lowestPriceToday: lowest.price,
      lowestPriceProductName: lowest.name,
    );
  }

  /// Precio más bajo disponible HOY del vendedor (con cache de 5 min).
  Future<({double? price, String? name})> _lowestPriceOf(
    String vendorId,
  ) async {
    final cached = _lowestPriceCache[vendorId];
    if (cached != null &&
        DateTime.now().difference(cached.at) < _priceTtl) {
      return (price: cached.price, name: cached.name);
    }

    double? lowestPrice;
    String? lowestName;
    try {
      final docs = await _firestore.getCollection(
        _products,
        queryBuilder: (q) => q
            .where('vendorId', isEqualTo: vendorId)
            .where('isAvailable', isEqualTo: true),
      );
      for (final doc in docs) {
        final price = ((doc['price'] as num?) ?? 0).toDouble();
        if (price <= 0) continue;
        if (lowestPrice == null || price < lowestPrice) {
          lowestPrice = price;
          lowestName = doc['name'] as String?;
        }
      }
    } catch (_) {
      // El precio del pin es decorativo: un fallo aquí no debe tumbar
      // la carga del mapa.
    }

    _lowestPriceCache[vendorId] =
        (price: lowestPrice, name: lowestName, at: DateTime.now());
    return (price: lowestPrice, name: lowestName);
  }

  ProductCategory _categoryFromName(String? name) {
    return ProductCategory.values.firstWhere(
      (c) => c.name == name,
      orElse: () => ProductCategory.other,
    );
  }
}
