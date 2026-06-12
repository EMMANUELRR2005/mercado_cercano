// Limpieza ÚNICA de datos de prueba en Firestore (mercado-cercano-28190).
//
// Elimina TODOS los documentos de: products, vendors, price_reports,
// ratings, price_alerts y activity_logs. NO toca `users` (conserva las
// cuentas reales ya registradas).
//
// Script de Dart puro (no requiere Flutter): usa la API REST de
// Firestore con un token OAuth de gcloud (acceso admin vía IAM, no
// sujeto a las reglas de seguridad).
//
// Uso:
//   GCLOUD_TOKEN=$(gcloud auth print-access-token) \
//     dart run lib/scripts/clear_firestore.dart
//
// Pide escribir CONFIRMAR antes de borrar nada.
//
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

const _projectId = 'mercado-cercano-28190';
const _base = 'https://firestore.googleapis.com/v1/projects/$_projectId'
    '/databases/(default)/documents';

/// Colecciones a vaciar. `users` queda explícitamente FUERA.
const _collections = [
  'products',
  'vendors',
  'price_reports',
  'ratings',
  'price_alerts',
  'activity_logs',
];

Future<void> main() async {
  final token = Platform.environment['GCLOUD_TOKEN'];
  if (token == null || token.isEmpty) {
    stderr.writeln(
      'Falta el token. Ejecuta:\n'
      '  GCLOUD_TOKEN=\$(gcloud auth print-access-token) '
      'dart run lib/scripts/clear_firestore.dart',
    );
    exit(1);
  }

  final client = HttpClient();

  // -------------------------------------------------------------------
  // 1. Inventario: listar qué se va a borrar.
  // -------------------------------------------------------------------
  print('Contando documentos a eliminar…\n');
  final docsByCollection = <String, List<String>>{};
  var total = 0;
  for (final collection in _collections) {
    final names = await _listDocumentNames(client, token, collection);
    docsByCollection[collection] = names;
    total += names.length;
    print('  • $collection: ${names.length} documentos');
  }
  print('  • users: SE CONSERVA (cuentas reales)\n');

  if (total == 0) {
    print('No hay nada que eliminar. Las colecciones ya están vacías.');
    client.close();
    return;
  }

  // -------------------------------------------------------------------
  // 2. Confirmación explícita.
  // -------------------------------------------------------------------
  print('⚠️  Se eliminarán $total documentos de forma PERMANENTE.');
  stdout.write('Escribe CONFIRMAR para continuar: ');
  final answer = stdin.readLineSync()?.trim();
  if (answer != 'CONFIRMAR') {
    print('Cancelado. No se eliminó nada.');
    client.close();
    exit(0);
  }

  // -------------------------------------------------------------------
  // 3. Borrado con progreso.
  // -------------------------------------------------------------------
  var deleted = 0;
  var failed = 0;
  for (final entry in docsByCollection.entries) {
    final collection = entry.key;
    final names = entry.value;
    if (names.isEmpty) continue;
    stdout.write('Borrando $collection (${names.length})… ');
    var collectionDeleted = 0;
    for (final name in names) {
      final request = await client
          .deleteUrl(Uri.parse('https://firestore.googleapis.com/v1/$name'));
      request.headers.set('Authorization', 'Bearer $token');
      final response = await request.close();
      await response.drain<void>();
      if (response.statusCode == 200) {
        deleted++;
        collectionDeleted++;
        // Progreso cada 10 documentos.
        if (collectionDeleted % 10 == 0) stdout.write('.');
      } else {
        failed++;
      }
    }
    print(' ✓ $collectionDeleted eliminados');
  }

  client.close();
  print('\nListo: $deleted documentos eliminados'
      '${failed > 0 ? ' ($failed fallaron)' : ''}.');
  print('La colección `users` quedó intacta.');
}

/// Lista los nombres (paths completos) de todos los docs de [collection],
/// paginando de 300 en 300.
Future<List<String>> _listDocumentNames(
  HttpClient client,
  String token,
  String collection,
) async {
  final names = <String>[];
  String? pageToken;
  do {
    final uri = Uri.parse(
      '$_base/$collection?pageSize=300&mask.fieldPaths=__name__'
      '${pageToken != null ? '&pageToken=$pageToken' : ''}',
    );
    final request = await client.getUrl(uri);
    request.headers.set('Authorization', 'Bearer $token');
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      stderr.writeln('Error listando $collection: $body');
      exit(1);
    }
    final json = jsonDecode(body) as Map<String, dynamic>;
    final docs = (json['documents'] as List<dynamic>?) ?? const [];
    for (final doc in docs) {
      names.add((doc as Map<String, dynamic>)['name'] as String);
    }
    pageToken = json['nextPageToken'] as String?;
  } while (pageToken != null);
  return names;
}
