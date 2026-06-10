import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstracción del estado de conectividad del dispositivo.
abstract class NetworkInfo {
  /// `true` si hay al menos una interfaz de red activa.
  Future<bool> get isConnected;

  /// Emite `true`/`false` cada vez que cambia la conectividad.
  Stream<bool> get onConnectivityChanged;
}

/// Implementación con connectivity_plus 7.x.
///
/// En v7 la API devuelve listas: `checkConnectivity()` es
/// `Future<List<ConnectivityResult>>` y `onConnectivityChanged` es
/// `Stream<List<ConnectivityResult>>`.
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  @override
  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map(_hasConnection);

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }
}
