import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/datasources/user_location_service.dart';

/// Resultado de pedir la ubicación: posición (real o fallback) y si el
/// permiso fue denegado / GPS apagado.
typedef UserLocationResult = ({LatLng position, bool denied});

/// Obtiene la ubicación actual del comprador.
///
/// PRIVACIDAD: la ubicación del comprador nunca se persiste — solo en
/// memoria. Si no hay permiso, devuelve Ciudad de Guatemala con
/// `denied: true` para que la UI muestre el chip informativo.
class GetUserLocationUsecase {
  const GetUserLocationUsecase(this._service);

  final UserLocationService _service;

  Future<UserLocationResult> call() async {
    final position = await _service.getCurrentLocation();
    return (position: position, denied: _service.locationDenied);
  }
}
