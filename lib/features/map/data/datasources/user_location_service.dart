import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_constants.dart';

/// Servicio de ubicación del comprador.
///
/// PRIVACIDAD: la ubicación del comprador nunca se persiste — solo en
/// memoria. No se escribe en storage, base de datos ni se envía a
/// analytics; únicamente se usa para centrar el mapa y calcular
/// distancias durante la sesión.
abstract class UserLocationService {
  /// Ubicación actual. Si el permiso fue denegado o el GPS está apagado,
  /// hace fallback silencioso a Ciudad de Guatemala y enciende
  /// [locationDenied].
  Future<LatLng> getCurrentLocation();

  /// Stream de ubicación en vivo (mismo fallback que [getCurrentLocation]).
  Stream<LatLng> watchLocation();

  /// True si la última petición no obtuvo ubicación real (permiso
  /// denegado o servicio apagado). El bloc lo expone en su estado para
  /// mostrar un chip informativo.
  bool get locationDenied;
}

/// Implementación con geolocator. Sin persistencia de ningún tipo.
class UserLocationServiceImpl implements UserLocationService {
  UserLocationServiceImpl();

  /// Fallback: centro de Ciudad de Guatemala.
  static const LatLng _fallback = LatLng(
    AppConstants.guatemalaCityLat,
    AppConstants.guatemalaCityLng,
  );

  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 25,
  );

  bool _locationDenied = false;

  @override
  bool get locationDenied => _locationDenied;

  /// Verifica servicio y permisos; pide permiso si aún no se decidió.
  Future<bool> _hasPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (_) {
      // Plataforma sin soporte de geolocalización: tratamos como denegado.
      return false;
    }
  }

  @override
  Future<LatLng> getCurrentLocation() async {
    // PRIVACIDAD: la ubicación del comprador nunca se persiste — solo en
    // memoria.
    if (!await _hasPermission()) {
      _locationDenied = true;
      return _fallback;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: _settings,
      );
      _locationDenied = false;
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      // Fallback silencioso: el mapa funciona igual centrado en la capital.
      _locationDenied = true;
      return _fallback;
    }
  }

  @override
  Stream<LatLng> watchLocation() async* {
    // PRIVACIDAD: la ubicación del comprador nunca se persiste — solo en
    // memoria.
    if (!await _hasPermission()) {
      _locationDenied = true;
      yield _fallback;
      return;
    }

    _locationDenied = false;
    yield* Geolocator.getPositionStream(locationSettings: _settings)
        .map((p) => LatLng(p.latitude, p.longitude));
  }
}
