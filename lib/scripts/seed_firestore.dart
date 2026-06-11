// Seed de datos de desarrollo para Firestore (mercado-cercano-28190).
//
// Script de Dart puro (no requiere Flutter ni emulador): escribe vía la
// API REST de Firestore con un token OAuth de gcloud, que NO está sujeto
// a las reglas de seguridad (acceso de administrador vía IAM).
//
// Uso:
//   GCLOUD_TOKEN=$(gcloud auth print-access-token) \
//     dart run lib/scripts/seed_firestore.dart
//
// Inserta:
//   - 3 vendedores en mercados reales de Ciudad de Guatemala
//   - 10 productos con precios reales en quetzales
//   - ~45 reportes de precio (90 días) para que el índice y el
//     historial tengan datos reales
//
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

const _projectId = 'mercado-cercano-28190';
const _base = 'https://firestore.googleapis.com/v1/projects/$_projectId'
    '/databases/(default)/documents';

Future<void> main() async {
  final token = Platform.environment['GCLOUD_TOKEN'];
  if (token == null || token.isEmpty) {
    stderr.writeln(
      'Falta el token. Ejecuta:\n'
      '  GCLOUD_TOKEN=\$(gcloud auth print-access-token) '
      'dart run lib/scripts/seed_firestore.dart',
    );
    exit(1);
  }

  final client = HttpClient();
  var created = 0;

  Future<void> put(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('$_base/$collection?documentId=$id');
    final request = await client.postUrl(uri);
    request.headers
      ..set('Authorization', 'Bearer $token')
      ..contentType = ContentType.json;
    request.write(jsonEncode({'fields': _toFields(data)}));
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode == 200) {
      created++;
      print('✓ $collection/$id');
    } else if (response.statusCode == 409) {
      print('• $collection/$id ya existe (omitido)');
    } else {
      stderr.writeln('✗ $collection/$id → ${response.statusCode}: $body');
    }
  }

  final now = DateTime.now().toUtc();

  // ---------------------------------------------------------------------
  // 3 vendedores en mercados reales de Ciudad de Guatemala.
  // Convención: el id del doc en `vendors` es el uid del usuario dueño.
  // ---------------------------------------------------------------------
  final vendors = [
    {
      'id': 'seed_vendor_terminal',
      'businessName': 'Frutas y Verduras Doña María',
      'zone': 'Zona 4',
      'neighborhood': 'Mercado La Terminal',
      'lat': 14.6425,
      'lng': -90.5133,
      'rating': 4.7,
      'totalRatings': 38,
      'isVerified': true,
    },
    {
      'id': 'seed_vendor_central',
      'businessName': 'Carnicería El Buen Precio',
      'zone': 'Zona 1',
      'neighborhood': 'Mercado Central',
      'lat': 14.6407,
      'lng': -90.5132,
      'rating': 4.4,
      'totalRatings': 25,
      'isVerified': true,
    },
    {
      'id': 'seed_vendor_artesanias',
      'businessName': 'Abarrotes San Judas',
      'zone': 'Zona 1',
      'neighborhood': 'Mercado de Artesanías',
      'lat': 14.6391,
      'lng': -90.5125,
      'rating': 4.1,
      'totalRatings': 12,
      'isVerified': false,
    },
  ];

  for (final v in vendors) {
    await put('vendors', v['id']! as String, {
      'userId': v['id'],
      'businessName': v['businessName'],
      'zone': v['zone'],
      'neighborhood': v['neighborhood'],
      'coordinates': GeoPoint(v['lat']! as double, v['lng']! as double),
      'rating': v['rating'],
      'totalRatings': v['totalRatings'],
      'isVerified': v['isVerified'],
      'isActive': true,
      'createdAt': now.subtract(const Duration(days: 120)),
    });
  }

  // ---------------------------------------------------------------------
  // 10 productos con precios reales en quetzales.
  // `products.vendorId` referencia el id del doc del vendedor (= uid).
  // ---------------------------------------------------------------------
  final products = [
    ('Tomate', 'fruitsVegetables', 4.0, 'lb', 'seed_vendor_terminal', true),
    ('Papa', 'fruitsVegetables', 5.0, 'lb', 'seed_vendor_terminal', false),
    ('Cebolla', 'fruitsVegetables', 6.0, 'lb', 'seed_vendor_terminal', false),
    ('Aguacate', 'fruitsVegetables', 5.0, 'unidad', 'seed_vendor_terminal',
        false),
    ('Pollo', 'meats', 25.0, 'lb', 'seed_vendor_central', true),
    ('Carne de res', 'meats', 42.0, 'lb', 'seed_vendor_central', false),
    ('Queso fresco', 'dairy', 35.0, 'lb', 'seed_vendor_central', false),
    ('Frijol negro', 'grains', 7.0, 'lb', 'seed_vendor_artesanias', false),
    ('Huevos', 'dairy', 60.0, 'cartón', 'seed_vendor_artesanias', false),
    ('Café', 'grains', 45.0, 'lb', 'seed_vendor_artesanias', false),
  ];

  for (var i = 0; i < products.length; i++) {
    final (name, category, price, unit, vendorId, featured) = products[i];
    await put('products', 'seed_product_$i', {
      'vendorId': vendorId,
      'name': name,
      'category': category,
      'price': price,
      'photoUrl': 'https://picsum.photos/seed/mc$i/400/300',
      'isAvailable': true,
      'isFeatured': featured,
      'expiresAt': now.add(const Duration(hours: 24)),
      'createdAt': now,
      'viewCount': 15 + i * 7,
      'unit': unit,
    });
  }

  // ---------------------------------------------------------------------
  // Reportes de precio: 90 días de historial para tomate/papa/pollo y
  // reportes recientes del resto (alimentan índice + historial).
  // ---------------------------------------------------------------------
  final random = Random(42);
  final zones = ['Zona 1', 'Zona 4', 'Zona 7'];
  final withHistory = [
    ('Tomate', 'fruitsVegetables', 4.0, 12),
    ('Papa', 'fruitsVegetables', 5.0, 12),
    ('Pollo', 'meats', 25.0, 12),
  ];
  var reportId = 0;
  for (final (name, category, basePrice, count) in withHistory) {
    for (var i = 0; i < count; i++) {
      final daysAgo = (90 / count * i).round();
      // Variación suave de ±12% alrededor del precio base.
      final price = basePrice * (0.88 + random.nextDouble() * 0.24);
      await put('price_reports', 'seed_report_${reportId++}', {
        'productName': name,
        'category': category,
        'price': double.parse(price.toStringAsFixed(2)),
        'zone': zones[i % zones.length],
        'reportedBy': 'seed_script',
        'reportedAt': now.subtract(Duration(days: daysAgo, hours: i)),
        'businessName': vendors[i % 3]['businessName']! as String,
      });
    }
  }
  final recent = [
    ('Cebolla', 'fruitsVegetables', 6.0),
    ('Aguacate', 'fruitsVegetables', 5.0),
    ('Queso fresco', 'dairy', 35.0),
    ('Frijol negro', 'grains', 7.0),
    ('Huevos', 'dairy', 60.0),
    ('Café', 'grains', 45.0),
    ('Carne de res', 'meats', 42.0),
  ];
  for (final (name, category, basePrice) in recent) {
    for (var i = 0; i < 3; i++) {
      final price = basePrice * (0.92 + random.nextDouble() * 0.16);
      await put('price_reports', 'seed_report_${reportId++}', {
        'productName': name,
        'category': category,
        'price': double.parse(price.toStringAsFixed(2)),
        'zone': zones[i % zones.length],
        'reportedBy': 'seed_script',
        'reportedAt': now.subtract(Duration(days: i * 2, hours: i * 3)),
        'businessName': vendors[i % 3]['businessName']! as String,
      });
    }
  }

  client.close();
  print('\nListo: $created documentos creados.');
}

// ---------------------------------------------------------------------
// Conversión de valores Dart → JSON tipado de la API REST de Firestore
// ---------------------------------------------------------------------

/// GeoPoint mínimo para el script (sin dependencia de cloud_firestore).
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

Map<String, dynamic> _toFields(Map<String, dynamic> data) {
  return data.map((key, value) => MapEntry(key, _toValue(value)));
}

Map<String, dynamic> _toValue(dynamic value) {
  return switch (value) {
    null => {'nullValue': null},
    bool b => {'booleanValue': b},
    int i => {'integerValue': '$i'},
    double d => {'doubleValue': d},
    String s => {'stringValue': s},
    DateTime t => {'timestampValue': t.toUtc().toIso8601String()},
    GeoPoint g => {
        'geoPointValue': {'latitude': g.latitude, 'longitude': g.longitude},
      },
    List<dynamic> l => {
        'arrayValue': {'values': l.map(_toValue).toList()},
      },
    Map<String, dynamic> m => {
        'mapValue': {'fields': _toFields(m)},
      },
    _ => throw ArgumentError('Tipo no soportado: ${value.runtimeType}'),
  };
}
