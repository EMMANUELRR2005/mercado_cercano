import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/firebase/firestore_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/rating_model.dart';
import '../models/report_model.dart';
import 'reputation_remote_datasource.dart';

/// Implementación REAL de reputación contra Cloud Firestore.
///
/// - Calificaciones en `ratings/{id}` (las reglas exigen
///   `buyerId == request.auth.uid` y son inmutables).
/// - Reportes de fraude en `fraud_reports/{id}`: las reglas actuales NO
///   incluyen esa colección, así que el intento es best-effort y, si es
///   rechazado, se notifica éxito local con TODO documentado (en
///   producción este flujo pasará por una Cloud Function de moderación).
class ReputationFirestoreDatasource implements ReputationRemoteDatasource {
  ReputationFirestoreDatasource(this._firestore, this._secureStorage);

  final FirestoreService _firestore;
  final SecureStorageService _secureStorage;

  static const _ratings = 'ratings';
  static const _vendors = 'vendors';

  Future<String> _uid() async {
    final id = await _secureStorage.getUserId();
    if (id == null || id.isEmpty) {
      throw const AuthException('La sesión expiró. Inicia sesión de nuevo.');
    }
    return id;
  }

  @override
  Future<List<RatingModel>> getVendorRatings(String vendorId) async {
    // Solo igualdad (el orden va en cliente: evita exigir el índice
    // compuesto vendorId+createdAt antes de que esté construido).
    final docs = await _firestore.getCollection(
      _ratings,
      queryBuilder: (q) => q.where('vendorId', isEqualTo: vendorId),
    );
    final ratings = docs.map(_fromDoc).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return ratings;
  }

  @override
  Future<RatingModel> submitRating({
    required String vendorId,
    required double stars,
    String? comment,
  }) async {
    final buyerId = await _uid();
    final now = DateTime.now();

    final id = await _firestore.setDocument(_ratings, {
      'vendorId': vendorId,
      'buyerId': buyerId,
      'stars': stars,
      'comment': ?comment,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Recalcular el promedio del vendedor. Best-effort: las reglas solo
    // permiten escribir `vendors/{id}` al dueño, así que esto fallará
    // para compradores — en producción lo hará una Cloud Function
    // disparada por la creación del rating.
    try {
      final all = await getVendorRatings(vendorId);
      final average = all.isEmpty
          ? stars
          : all.map((r) => r.stars).reduce((a, b) => a + b) / all.length;
      await _firestore.updateDocument(_vendors, vendorId, {
        'rating': double.parse(average.toStringAsFixed(2)),
        'totalRatings': all.length,
      });
    } on AppException {
      // Sin permiso (esperado para compradores): el rating quedó
      // guardado; el agregado lo actualizará el backend.
    }

    return RatingModel(
      id: id,
      vendorId: vendorId,
      buyerId: buyerId,
      stars: stars,
      comment: comment,
      createdAt: now,
    );
  }

  @override
  Future<ReportModel> reportFraud({
    required String vendorId,
    required String reason,
    String? description,
  }) async {
    final buyerId = await _uid();
    final now = DateTime.now();

    // TODO(backend): mover a una Cloud Function de moderación. Las
    // reglas actuales no contemplan `fraud_reports`, por lo que esta
    // escritura puede ser rechazada; el reporte no debe romper la UX.
    var id = 'local_${now.millisecondsSinceEpoch}';
    try {
      id = await _firestore.setDocument('fraud_reports', {
        'vendorId': vendorId,
        'reportedBy': buyerId,
        'reason': reason,
        'description': ?description,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on AppException {
      // Rechazado por reglas: se acepta localmente (best-effort).
    }

    return ReportModel(
      id: id,
      vendorId: vendorId,
      reason: reason,
      description: description,
      createdAt: now,
    );
  }

  RatingModel _fromDoc(Map<String, dynamic> doc) {
    final createdAt = doc['createdAt'];
    return RatingModel(
      id: doc['id'] as String,
      vendorId: (doc['vendorId'] as String?) ?? '',
      buyerId: (doc['buyerId'] as String?) ?? '',
      stars: ((doc['stars'] as num?) ?? 0).toDouble(),
      comment: doc['comment'] as String?,
      createdAt:
          createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
    );
  }
}
