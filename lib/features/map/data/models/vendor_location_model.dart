import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/vendor_entity.dart';
import '../../domain/entities/vendor_location_entity.dart';

part 'vendor_location_model.freezed.dart';
part 'vendor_location_model.g.dart';

/// Modelo de datos (JSON ↔ API) de la posición de un vendedor en el mapa.
///
/// Es el payload de `GET /vendors/nearby` y de los mensajes
/// `vendor_update` del WebSocket.
@freezed
abstract class VendorLocationModel with _$VendorLocationModel {
  const VendorLocationModel._();

  const factory VendorLocationModel({
    required VendorEntity vendor,
    required double latitude,
    required double longitude,
    @Default(true) bool isOnline,
    double? lowestPriceToday,
    String? lowestPriceProductName,
    double? distanceMeters,
  }) = _VendorLocationModel;

  factory VendorLocationModel.fromJson(Map<String, dynamic> json) =>
      _$VendorLocationModelFromJson(json);

  /// Convierte el modelo de datos a la entidad de dominio.
  VendorLocationEntity toEntity() => VendorLocationEntity(
        vendor: vendor,
        latitude: latitude,
        longitude: longitude,
        isOnline: isOnline,
        lowestPriceToday: lowestPriceToday,
        lowestPriceProductName: lowestPriceProductName,
        distanceMeters: distanceMeters,
      );
}
