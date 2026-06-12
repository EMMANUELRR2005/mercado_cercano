import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Resultado de la búsqueda de un lugar o dirección.
class PlaceResult {
  const PlaceResult({required this.label, required this.position});

  /// Dirección legible (calle, colonia/zona, ciudad).
  final String label;

  final LatLng position;
}

/// Búsqueda de direcciones/lugares con el geocoder NATIVO de la
/// plataforma (paquete `geocoding`): no requiere API key ni facturación.
class PlaceSearchService {
  /// Geocodifica [query]. Si no devuelve nada y la consulta no menciona
  /// el país, reintenta sesgada a Guatemala (mercado de la app).
  Future<List<PlaceResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    var locations = await _locationsFor(trimmed);
    if (locations.isEmpty && !trimmed.toLowerCase().contains('guatemala')) {
      locations = await _locationsFor('$trimmed, Guatemala');
    }

    final results = <PlaceResult>[];
    for (final location in locations.take(5)) {
      final position = LatLng(location.latitude, location.longitude);
      results.add(
        PlaceResult(
          label: await describe(position) ?? trimmed,
          position: position,
        ),
      );
    }
    return results;
  }

  /// Dirección legible de una coordenada (reverse geocoding), o null si
  /// el geocoder no la conoce. Best-effort: nunca lanza.
  Future<String?> describe(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final parts = [p.street, p.subLocality, p.locality]
          .whereType<String>()
          .where((part) => part.trim().isNotEmpty)
          .toList();
      return parts.isEmpty ? null : parts.join(', ');
    } catch (_) {
      return null;
    }
  }

  /// El geocoder lanza cuando no encuentra resultados: lo tratamos como
  /// lista vacía para poder reintentar/avisar.
  Future<List<Location>> _locationsFor(String query) async {
    try {
      return await locationFromAddress(query);
    } catch (_) {
      return const [];
    }
  }
}
