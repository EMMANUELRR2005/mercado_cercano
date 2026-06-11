import 'package:cloud_firestore/cloud_firestore.dart';

import '../errors/app_exception.dart';

/// Acceso genérico a Cloud Firestore (proyecto mercado-cercano-28190).
///
/// Convención de errores del proyecto: los datasources LANZAN
/// `AppException`; el BLoC las convierte en `Failure` (mensaje en español)
/// vía `error_handler.dart`. Por eso aquí cada operación envuelve
/// `FirebaseException` en la `AppException` correspondiente — el mapeo
/// a `Failure` ocurre una sola vez, en la capa de presentación.
///
/// Colecciones del proyecto: `users`, `vendors`, `products`,
/// `price_reports`, `ratings`, `price_alerts`.
class FirestoreService {
  FirestoreService._(this._db);

  /// Instancia singleton.
  static final FirestoreService instance =
      FirestoreService._(FirebaseFirestore.instance);

  /// Fábrica para tests (permite inyectar un Firestore falso).
  factory FirestoreService.withInstance(FirebaseFirestore db) =>
      FirestoreService._(db);

  final FirebaseFirestore _db;

  /// Acceso crudo (para queries compuestas de los datasources).
  FirebaseFirestore get db => _db;

  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _db.collection(path);

  /// Lee un documento; devuelve `null` si no existe.
  Future<Map<String, dynamic>?> getDocument(
    String collection,
    String id,
  ) async {
    return _guard(() async {
      final doc = await _db.collection(collection).doc(id).get();
      if (!doc.exists) return null;
      return {...doc.data()!, 'id': doc.id};
    });
  }

  /// Crea o reemplaza un documento. Si [id] es null, Firestore genera uno;
  /// devuelve el id final. Con [merge] combina con lo existente.
  Future<String> setDocument(
    String collection,
    Map<String, dynamic> data, {
    String? id,
    bool merge = false,
  }) async {
    return _guard(() async {
      final ref = id != null
          ? _db.collection(collection).doc(id)
          : _db.collection(collection).doc();
      await ref.set(data, SetOptions(merge: merge));
      return ref.id;
    });
  }

  /// Actualiza campos de un documento existente.
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) {
    return _guard(() => _db.collection(collection).doc(id).update(data));
  }

  /// Elimina un documento.
  Future<void> deleteDocument(String collection, String id) {
    return _guard(() => _db.collection(collection).doc(id).delete());
  }

  /// Lee una colección completa o filtrada. [queryBuilder] permite
  /// componer `where`/`orderBy`/`limit` sobre la colección.
  Future<List<Map<String, dynamic>>> getCollection(
    String collection, {
    Query<Map<String, dynamic>> Function(
      Query<Map<String, dynamic>> query,
    )? queryBuilder,
  }) async {
    return _guard(() async {
      Query<Map<String, dynamic>> query = _db.collection(collection);
      if (queryBuilder != null) query = queryBuilder(query);
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    });
  }

  /// Stream en tiempo real de una colección (para catálogos y mapa).
  /// Los errores del stream también llegan como `AppException`.
  Stream<List<Map<String, dynamic>>> streamCollection(
    String collection, {
    Query<Map<String, dynamic>> Function(
      Query<Map<String, dynamic>> query,
    )? queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = _db.collection(collection);
    if (queryBuilder != null) query = queryBuilder(query);
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList(),
    ).handleError((Object error) => throw _map(error));
  }

  // -------------------------------------------------------------------
  // Manejo de errores
  // -------------------------------------------------------------------

  Future<T> _guard<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on FirebaseException catch (e) {
      throw _map(e);
    }
  }

  AppException _map(Object error) {
    if (error is AppException) return error;
    if (error is! FirebaseException) {
      return const ServerException(
        'Ocurrió un error inesperado con la base de datos.',
      );
    }
    return switch (error.code) {
      'permission-denied' => const AuthException(
          'No tienes permiso para realizar esta acción. '
          'Inicia sesión de nuevo.',
        ),
      'unavailable' || 'deadline-exceeded' => const NetworkException(
          'Sin conexión con el servidor. Revisa tu internet.',
        ),
      'not-found' => const ServerException('El registro no existe.'),
      'already-exists' => const ServerException('El registro ya existe.'),
      'resource-exhausted' => const ServerException(
          'Se alcanzó el límite de uso. Intenta más tarde.',
        ),
      _ => ServerException('Error de base de datos (${error.code}).'),
    };
  }
}
