import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/firebase/firestore_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/price_alert_model.dart';
import '../models/price_history_model.dart';
import '../models/price_index_model.dart';
import 'price_remote_datasource.dart';

/// Implementación REAL del índice de precios contra Cloud Firestore
/// (`AppConstants.useFirestore`).
///
/// El índice se calcula EN CLIENTE agregando la colección
/// `price_reports` (promedio/mín/máx por producto). Estrategia de
/// queries: para evitar índices compuestos (igualdad + rango sobre
/// campos distintos exige uno por combinación), los filtros por fecha
/// se aplican en cliente — el volumen por producto/zona es pequeño
/// (decenas de docs).
class PriceFirestoreDatasource implements PriceRemoteDatasource {
  PriceFirestoreDatasource(this._firestore, this._secureStorage);

  final FirestoreService _firestore;
  final SecureStorageService _secureStorage;

  static const _reports = 'price_reports';
  static const _alerts = 'price_alerts';
  static const _defaultZone = 'Zona 1, Ciudad de Guatemala';

  /// Unidades por defecto de la canasta básica (el reporte no siempre
  /// trae unidad).
  static const _defaultUnits = <String, String>{
    'huevos': 'cartón',
    'plátano': 'unidad',
    'aguacate': 'unidad',
    'limón': 'unidad',
    'chile pimiento': 'unidad',
  };

  // -------------------------------------------------------------------
  // Índice por zona
  // -------------------------------------------------------------------

  @override
  Future<List<PriceIndexModel>> getIndexByZone({String? zone}) async {
    // Una sola query con rango sobre reportedAt (no requiere índice
    // compuesto): últimos 7 días; hoy vs ayer se separa en cliente.
    final since = DateTime.now().subtract(const Duration(days: 7));
    final docs = await _firestore.getCollection(
      _reports,
      queryBuilder: (q) => q.where(
        'reportedAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(since),
      ),
    );

    if (docs.isEmpty) return const [];

    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final startOfYesterday =
        startOfToday.subtract(const Duration(days: 1));

    // Agrupar por producto.
    final byProduct = <String, List<Map<String, dynamic>>>{};
    for (final doc in docs) {
      final name = (doc['productName'] as String?)?.trim();
      if (name == null || name.isEmpty) continue;
      byProduct.putIfAbsent(name, () => []).add(doc);
    }

    final result = <PriceIndexModel>[];
    byProduct.forEach((name, reports) {
      // Reportes "de hoy" con fallback a la semana para que el índice
      // no salga vacío en días sin reportes frescos.
      final todayReports = reports
          .where((r) => !_date(r['reportedAt']).isBefore(startOfToday))
          .toList();
      final current = todayReports.isNotEmpty ? todayReports : reports;

      final prices = current.map((r) => _toDouble(r['price'])).toList();
      final average =
          prices.reduce((a, b) => a + b) / prices.length;

      // Tendencia: promedio de hoy vs promedio de ayer (en %).
      final yesterdayPrices = reports
          .where((r) {
            final date = _date(r['reportedAt']);
            return !date.isBefore(startOfYesterday) &&
                date.isBefore(startOfToday);
          })
          .map((r) => _toDouble(r['price']))
          .toList();
      var change = 0.0;
      if (yesterdayPrices.isNotEmpty) {
        final yesterdayAvg = yesterdayPrices.reduce((a, b) => a + b) /
            yesterdayPrices.length;
        if (yesterdayAvg > 0) {
          change = (average - yesterdayAvg) / yesterdayAvg * 100;
        }
      }

      result.add(PriceIndexModel(
        productName: name,
        unit: _unitOf(name, current),
        averagePrice: _round2(average),
        minPrice: _round2(prices.reduce((a, b) => a < b ? a : b)),
        maxPrice: _round2(prices.reduce((a, b) => a > b ? a : b)),
        reportCount: current.length,
        changeVsYesterday: _round2(change),
        zone: zone ?? _defaultZone,
      ));
    });

    result.sort((a, b) => a.productName.compareTo(b.productName));
    return result;
  }

  // -------------------------------------------------------------------
  // Historial
  // -------------------------------------------------------------------

  @override
  Future<PriceHistoryModel> getPriceHistory(String productName) async {
    // Solo igualdad por nombre (sin rango: evita el índice compuesto);
    // el recorte a 90 días y el orden van en cliente.
    final docs = await _firestore.getCollection(
      _reports,
      queryBuilder: (q) =>
          q.where('productName', isEqualTo: productName.trim()),
    );

    final cutoff = DateTime.now().subtract(const Duration(days: 90));

    // Promedio DIARIO: un punto por día con reportes.
    final byDay = <DateTime, List<double>>{};
    for (final doc in docs) {
      final date = _date(doc['reportedAt']);
      if (date.isBefore(cutoff)) continue;
      final day = DateTime(date.year, date.month, date.day);
      byDay.putIfAbsent(day, () => []).add(_toDouble(doc['price']));
    }

    final points = byDay.entries
        .map((entry) {
          final avg =
              entry.value.reduce((a, b) => a + b) / entry.value.length;
          return PricePointModel(
            date: entry.key,
            price: _round2(avg),
            // Con una sola zona agregada, el promedio de zona coincide
            // con el promedio diario.
            zoneAverage: _round2(avg),
          );
        })
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return PriceHistoryModel(
      productName: productName,
      unit: _unitOf(productName, docs),
      points: points,
    );
  }

  // -------------------------------------------------------------------
  // Alertas
  // -------------------------------------------------------------------

  @override
  Future<List<PriceAlertModel>> getMyAlerts() async {
    final uid = await _uid();
    final docs = await _firestore.getCollection(
      _alerts,
      queryBuilder: (q) => q.where('userId', isEqualTo: uid),
    );
    final alerts = docs.map(_alertFromDoc).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return alerts;
  }

  @override
  Future<PriceAlertModel> createAlert({
    required String productName,
    required double targetPrice,
  }) async {
    final uid = await _uid();
    final now = DateTime.now();
    final id = await _firestore.setDocument(_alerts, {
      'userId': uid,
      'productName': productName.trim(),
      'targetPrice': targetPrice,
      'zone': _defaultZone,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return PriceAlertModel(
      id: id,
      productName: productName.trim(),
      targetPrice: targetPrice,
      isActive: true,
      createdAt: now,
    );
  }

  @override
  Future<PriceAlertModel> toggleAlert(String alertId) async {
    final doc = await _firestore.getDocument(_alerts, alertId);
    if (doc == null) {
      throw const ServerException('La alerta ya no existe.');
    }
    final newValue = !((doc['isActive'] as bool?) ?? true);
    await _firestore.updateDocument(_alerts, alertId, {
      'isActive': newValue,
    });
    return _alertFromDoc({...doc, 'isActive': newValue});
  }

  @override
  Future<void> deleteAlert(String alertId) {
    return _firestore.deleteDocument(_alerts, alertId);
  }

  // -------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------

  Future<String> _uid() async {
    final id = await _secureStorage.getUserId();
    if (id == null || id.isEmpty) {
      throw const AuthException('La sesión expiró. Inicia sesión de nuevo.');
    }
    return id;
  }

  PriceAlertModel _alertFromDoc(Map<String, dynamic> doc) {
    return PriceAlertModel(
      id: doc['id'] as String,
      productName: (doc['productName'] as String?) ?? '',
      targetPrice: _toDouble(doc['targetPrice']),
      isActive: (doc['isActive'] as bool?) ?? true,
      createdAt: _date(doc['createdAt']),
    );
  }

  /// Unidad del producto: la del reporte más reciente que la traiga,
  /// o un valor conocido de la canasta básica, o 'lb'.
  String _unitOf(String productName, List<Map<String, dynamic>> reports) {
    for (final report in reports) {
      final unit = report['unit'] as String?;
      if (unit != null && unit.isNotEmpty) return unit;
    }
    return _defaultUnits[productName.toLowerCase()] ?? 'lb';
  }

  double _toDouble(Object? value) => (value as num?)?.toDouble() ?? 0;

  double _round2(double value) => double.parse(value.toStringAsFixed(2));

  DateTime _date(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
