import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_bounds_model.freezed.dart';
part 'map_bounds_model.g.dart';

/// Límites visibles del mapa (viewport) para lazy load de vendedores.
///
/// Se envía al backend cuando el usuario mueve la cámara, para cargar
/// solo los vendedores dentro del área visible.
@freezed
abstract class MapBoundsModel with _$MapBoundsModel {
  const MapBoundsModel._();

  const factory MapBoundsModel({
    required double southWestLat,
    required double southWestLng,
    required double northEastLat,
    required double northEastLng,
  }) = _MapBoundsModel;

  factory MapBoundsModel.fromJson(Map<String, dynamic> json) =>
      _$MapBoundsModelFromJson(json);

  /// Crea el modelo a partir de los bounds del controlador de Google Maps.
  factory MapBoundsModel.fromLatLngBounds(LatLngBounds bounds) =>
      MapBoundsModel(
        southWestLat: bounds.southwest.latitude,
        southWestLng: bounds.southwest.longitude,
        northEastLat: bounds.northeast.latitude,
        northEastLng: bounds.northeast.longitude,
      );

  /// Centro geográfico del viewport.
  LatLng get center => LatLng(
        (southWestLat + northEastLat) / 2,
        (southWestLng + northEastLng) / 2,
      );

  /// Indica si una coordenada cae dentro del viewport.
  bool contains(double lat, double lng) =>
      lat >= southWestLat &&
      lat <= northEastLat &&
      lng >= southWestLng &&
      lng <= northEastLng;
}
