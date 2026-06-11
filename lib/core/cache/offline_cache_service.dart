import 'package:hive_flutter/hive_flutter.dart';

/// Caché offline con Hive (cache-aside, con TTL por box).
///
/// Boxes y TTL:
/// - `products_cache`    → 30 minutos (últimos productos vistos)
/// - `price_index_cache` → 1 hora (índice de precios)
/// - `user_cache`        → 1 hora (perfil del usuario)
///
/// Patrón de uso en los datasources/repositorios:
/// 1. Lectura exitosa del backend → `put(...)`.
/// 2. Lectura fallida por red → `get(...)`; si hay datos vigentes, la
///    pantalla los muestra (con el OfflineBanner arriba); si no, se
///    relanza el error original.
///
/// `Hive.initFlutter()` ya corre en main; los boxes se abren lazy aquí.
class OfflineCacheService {
  OfflineCacheService();

  static const String productsBox = 'products_cache';
  static const String priceIndexBox = 'price_index_cache';
  static const String userBox = 'user_cache';

  static const Map<String, Duration> _ttlByBox = {
    productsBox: Duration(minutes: 30),
    priceIndexBox: Duration(hours: 1),
    userBox: Duration(hours: 1),
  };

  final Map<String, Box<dynamic>> _openBoxes = {};

  Future<Box<dynamic>> _box(String name) async {
    final cached = _openBoxes[name];
    if (cached != null && cached.isOpen) return cached;
    final box = await Hive.openBox<dynamic>(name);
    _openBoxes[name] = box;
    return box;
  }

  /// Guarda [data] (estructura JSON: Map/List/escalares) con timestamp.
  Future<void> put(String boxName, String key, Object data) async {
    try {
      final box = await _box(boxName);
      await box.put(key, {
        'data': data,
        'savedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // El caché es best-effort: nunca rompe el flujo principal.
    }
  }

  /// Lee [key]; devuelve `null` si no existe o si el TTL del box venció.
  Future<T?> get<T>(String boxName, String key) async {
    try {
      final box = await _box(boxName);
      final raw = box.get(key);
      if (raw is! Map) return null;

      final savedAt = DateTime.tryParse(raw['savedAt'] as String? ?? '');
      final ttl = _ttlByBox[boxName] ?? const Duration(minutes: 30);
      if (savedAt == null ||
          DateTime.now().difference(savedAt) > ttl) {
        await box.delete(key);
        return null;
      }
      return raw['data'] as T?;
    } catch (_) {
      return null;
    }
  }

  /// Limpia un box completo (p. ej. al cerrar sesión).
  Future<void> clear(String boxName) async {
    try {
      final box = await _box(boxName);
      await box.clear();
    } catch (_) {
      // best-effort
    }
  }
}
