import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';
import 'firestore_service.dart';

/// Acciones auditables de la app (colección `activity_logs`).
enum ActivityAction {
  login,
  logout,
  productCreated,
  productRenewed,
  productSoldOut,
  priceReported,
  ratingSubmitted,
  roleChanged,
  vendorSetupCompleted,
}

/// Registro de actividad en Firestore para auditoría.
///
/// Best-effort SIEMPRE: un fallo del log jamás interrumpe la acción del
/// usuario (se traga el error y solo se imprime en debug). En modo demo
/// (`useMockData`) no escribe nada.
class ActivityLogger {
  ActivityLogger(this._firestore, this._secureStorage);

  final FirestoreService _firestore;
  final SecureStorageService _secureStorage;

  static const _collection = 'activity_logs';

  Future<void> log(
    ActivityAction action, {
    Map<String, dynamic> metadata = const {},
  }) async {
    if (AppConstants.useMockData) return;
    try {
      final userId = await _secureStorage.getUserId();
      if (userId == null || userId.isEmpty) return;
      await _firestore.setDocument(_collection, {
        'userId': userId,
        'action': _actionName(action),
        'timestamp': FieldValue.serverTimestamp(),
        'metadata': {
          ...metadata,
          'platform': Platform.operatingSystem,
        },
      });
    } catch (e) {
      // Auditoría best-effort: nunca interrumpe el flujo del usuario.
      if (kDebugMode) debugPrint('ActivityLogger: $e');
    }
  }

  /// snake_case estable para consultas en la consola.
  String _actionName(ActivityAction action) => switch (action) {
        ActivityAction.login => 'login',
        ActivityAction.logout => 'logout',
        ActivityAction.productCreated => 'product_created',
        ActivityAction.productRenewed => 'product_renewed',
        ActivityAction.productSoldOut => 'product_sold_out',
        ActivityAction.priceReported => 'price_reported',
        ActivityAction.ratingSubmitted => 'rating_submitted',
        ActivityAction.roleChanged => 'role_changed',
        ActivityAction.vendorSetupCompleted => 'vendor_setup_completed',
      };
}
