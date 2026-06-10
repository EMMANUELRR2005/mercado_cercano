import 'dart:math' as math;

import '../../../../core/errors/app_exception.dart';
import '../models/price_alert_model.dart';
import '../models/price_history_model.dart';
import '../models/price_index_model.dart';
import 'price_remote_datasource.dart';

/// Implementación MOCK del índice de precios (AppConstants.useMockData).
///
/// - Índice con 15 productos de la canasta básica con precios realistas
///   de Guatemala (2026).
/// - Historial de 90 días: tomate, papa y pollo con variación suave +
///   promedio de zona; el resto con serie sintética determinista
///   (seed derivado del nombre, así el gráfico no cambia entre visitas).
/// - Alertas en memoria: crear, activar/desactivar y eliminar funcionan
///   de verdad durante la sesión.
class PriceMockDatasource implements PriceRemoteDatasource {
  PriceMockDatasource();

  static const _delay = Duration(milliseconds: 500);

  static const String _zone = 'Zona 1, Ciudad de Guatemala';

  /// Canasta básica con precios realistas de mercado cantonal (Q, 2026).
  static const List<PriceIndexModel> _index = [
    PriceIndexModel(
      productName: 'Tomate',
      unit: 'lb',
      averagePrice: 5.50,
      minPrice: 3.00,
      maxPrice: 8.00,
      reportCount: 142,
      changeVsYesterday: -2.3,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Papa',
      unit: 'lb',
      averagePrice: 5.00,
      minPrice: 4.00,
      maxPrice: 6.00,
      reportCount: 118,
      changeVsYesterday: 1.2,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Cebolla',
      unit: 'lb',
      averagePrice: 5.50,
      minPrice: 4.00,
      maxPrice: 7.00,
      reportCount: 96,
      changeVsYesterday: 3.1,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Pollo',
      unit: 'lb',
      averagePrice: 25.00,
      minPrice: 22.00,
      maxPrice: 28.00,
      reportCount: 150,
      changeVsYesterday: -0.8,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Frijol negro',
      unit: 'lb',
      averagePrice: 7.00,
      minPrice: 6.00,
      maxPrice: 8.00,
      reportCount: 87,
      changeVsYesterday: 0.0,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Maíz',
      unit: 'lb',
      averagePrice: 4.00,
      minPrice: 3.00,
      maxPrice: 5.00,
      reportCount: 64,
      changeVsYesterday: -1.5,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Huevos',
      unit: 'cartón',
      averagePrice: 60.00,
      minPrice: 55.00,
      maxPrice: 65.00,
      reportCount: 133,
      changeVsYesterday: 2.4,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Queso fresco',
      unit: 'lb',
      averagePrice: 35.00,
      minPrice: 30.00,
      maxPrice: 40.00,
      reportCount: 41,
      changeVsYesterday: 0.5,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Plátano',
      unit: 'unidad',
      averagePrice: 2.00,
      minPrice: 1.50,
      maxPrice: 2.50,
      reportCount: 75,
      changeVsYesterday: -4.2,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Aguacate',
      unit: 'unidad',
      averagePrice: 6.00,
      minPrice: 4.00,
      maxPrice: 8.00,
      reportCount: 58,
      changeVsYesterday: 5.6,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Arroz',
      unit: 'lb',
      averagePrice: 6.00,
      minPrice: 5.00,
      maxPrice: 7.00,
      reportCount: 92,
      changeVsYesterday: 0.3,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Azúcar',
      unit: 'lb',
      averagePrice: 4.50,
      minPrice: 4.00,
      maxPrice: 5.00,
      reportCount: 70,
      changeVsYesterday: 0.0,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Café',
      unit: 'lb',
      averagePrice: 47.50,
      minPrice: 40.00,
      maxPrice: 55.00,
      reportCount: 26,
      changeVsYesterday: 1.8,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Chile pimiento',
      unit: 'unidad',
      averagePrice: 4.50,
      minPrice: 3.00,
      maxPrice: 6.00,
      reportCount: 33,
      changeVsYesterday: -3.0,
      zone: _zone,
    ),
    PriceIndexModel(
      productName: 'Limón',
      unit: 'unidad',
      averagePrice: 0.75,
      minPrice: 0.50,
      maxPrice: 1.00,
      reportCount: 10,
      changeVsYesterday: -6.5,
      zone: _zone,
    ),
  ];

  /// Productos con historial "curado" (variación suave + promedio de zona).
  static const Set<String> _curatedHistory = {'tomate', 'papa', 'pollo'};

  /// Contador para ids de alertas nuevas.
  int _alertSeq = 3;

  /// Alertas en memoria (estado mutable real del mock).
  final List<PriceAlertModel> _alerts = [
    PriceAlertModel(
      id: 'alert_001',
      productName: 'Tomate',
      targetPrice: 4.00,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    PriceAlertModel(
      id: 'alert_002',
      productName: 'Pollo',
      targetPrice: 23.00,
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    PriceAlertModel(
      id: 'alert_003',
      productName: 'Huevos',
      targetPrice: 55.00,
      isActive: false,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Future<List<PriceIndexModel>> getIndexByZone({String? zone}) async {
    await Future<void>.delayed(_delay);
    // El mock solo conoce la Zona 1; ignora el parámetro.
    return List.unmodifiable(_index);
  }

  @override
  Future<PriceHistoryModel> getPriceHistory(String productName) async {
    await Future<void>.delayed(_delay);

    final normalized = productName.trim().toLowerCase();
    final index = _index.where(
      (i) => i.productName.toLowerCase() == normalized,
    );
    // Si el producto no está en la canasta, generamos igual una serie
    // sintética alrededor de Q10 para no romper la pantalla.
    final base = index.isNotEmpty ? index.first.averagePrice : 10.0;
    final unit = index.isNotEmpty ? index.first.unit : 'lb';
    final displayName =
        index.isNotEmpty ? index.first.productName : productName.trim();

    return PriceHistoryModel(
      productName: displayName,
      unit: unit,
      points: _curatedHistory.contains(normalized)
          ? _smoothSeries(base: base, name: normalized)
          : _syntheticSeries(base: base, name: normalized),
    );
  }

  /// Serie de 90 días con variación suave (ondas senoidales + ruido
  /// determinista) y promedio de zona, para tomate, papa y pollo.
  static List<PricePointModel> _smoothSeries({
    required double base,
    required String name,
  }) {
    final random = math.Random(name.hashCode);
    final today = _dayOnly(DateTime.now());
    final points = <PricePointModel>[];

    for (var i = 89; i >= 0; i--) {
      final t = (89 - i).toDouble();
      // Tendencia estacional lenta + ciclo semanal corto + ruido leve.
      final wave = 0.08 * math.sin(t / 9) + 0.04 * math.sin(t / 3.5);
      final noise = (random.nextDouble() - 0.5) * 0.03;
      final price = base * (1 + wave + noise);
      // El promedio de zona se mueve más lento que el precio puntual.
      final zoneAvg = base * (1 + 0.05 * math.sin(t / 11));
      points.add(
        PricePointModel(
          date: today.subtract(Duration(days: i)),
          price: _round2(price),
          zoneAverage: _round2(zoneAvg),
        ),
      );
    }
    return points;
  }

  /// Serie sintética determinista para el resto de productos:
  /// caminata aleatoria con seed por nombre (siempre la misma serie).
  static List<PricePointModel> _syntheticSeries({
    required double base,
    required String name,
  }) {
    final random = math.Random(name.hashCode);
    final today = _dayOnly(DateTime.now());
    final points = <PricePointModel>[];

    var price = base;
    for (var i = 89; i >= 0; i--) {
      // Paso de la caminata: ±2% con regreso suave hacia el precio base.
      final step = (random.nextDouble() - 0.5) * 0.04 * base;
      price = price + step + (base - price) * 0.08;
      points.add(
        PricePointModel(
          date: today.subtract(Duration(days: i)),
          price: _round2(price.clamp(base * 0.7, base * 1.3)),
          zoneAverage: _round2(base),
        ),
      );
    }
    return points;
  }

  @override
  Future<PriceAlertModel> createAlert({
    required String productName,
    required double targetPrice,
  }) async {
    await Future<void>.delayed(_delay);
    if (productName.trim().isEmpty) {
      throw const ValidationException('El nombre del producto es requerido');
    }
    if (targetPrice <= 0) {
      throw const ValidationException('El precio objetivo debe ser mayor a 0');
    }
    _alertSeq++;
    final alert = PriceAlertModel(
      id: 'alert_${_alertSeq.toString().padLeft(3, '0')}',
      productName: productName.trim(),
      targetPrice: _round2(targetPrice),
      isActive: true,
      createdAt: DateTime.now(),
    );
    _alerts.insert(0, alert);
    return alert;
  }

  @override
  Future<List<PriceAlertModel>> getMyAlerts() async {
    await Future<void>.delayed(_delay);
    return List.unmodifiable(_alerts);
  }

  @override
  Future<PriceAlertModel> toggleAlert(String alertId) async {
    await Future<void>.delayed(_delay);
    final i = _alerts.indexWhere((a) => a.id == alertId);
    if (i < 0) {
      throw const ValidationException('La alerta no existe', statusCode: 404);
    }
    final updated = _alerts[i].copyWith(isActive: !_alerts[i].isActive);
    _alerts[i] = updated;
    return updated;
  }

  @override
  Future<void> deleteAlert(String alertId) async {
    await Future<void>.delayed(_delay);
    final i = _alerts.indexWhere((a) => a.id == alertId);
    if (i < 0) {
      throw const ValidationException('La alerta no existe', statusCode: 404);
    }
    _alerts.removeAt(i);
  }

  static DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static double _round2(double v) => (v * 100).roundToDouble() / 100;
}
