import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/firebase/firebase_storage_service.dart';
import '../../../../core/firebase/firestore_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/vendor_profile.dart';

/// Datasource del perfil público del negocio (`vendors/{uid}`).
abstract class VendorProfileDatasource {
  /// Perfil actual del vendedor, o `null` si nunca lo configuró.
  Future<VendorProfile?> getMyProfile();

  /// Guarda el perfil. Si [localPhotoPath] no es null, sube la foto
  /// primero a Storage (`vendors/{uid}/profile.jpg`, con compresión).
  Future<VendorProfile> saveProfile(
    VendorProfile profile, {
    String? localPhotoPath,
  });
}

/// Implementación real: Firestore (`vendors/{uid}`) + Firebase Storage
/// para la foto del negocio.
class FirestoreVendorProfileDatasource implements VendorProfileDatasource {
  FirestoreVendorProfileDatasource(
    this._firestore,
    this._secureStorage,
    this._storage,
  );

  final FirestoreService _firestore;
  final SecureStorageService _secureStorage;
  final FirebaseStorageService _storage;

  static const _vendors = 'vendors';

  Future<String> _uid() async {
    final id = await _secureStorage.getUserId();
    if (id == null || id.isEmpty) {
      throw const AuthException('La sesión expiró. Inicia sesión de nuevo.');
    }
    return id;
  }

  @override
  Future<VendorProfile?> getMyProfile() async {
    final uid = await _uid();
    final doc = await _firestore.getDocument(_vendors, uid);
    if (doc == null) return null;

    final coordinates = doc['coordinates'];
    return VendorProfile(
      businessName: (doc['businessName'] as String?) ?? '',
      photoUrl: doc['photoUrl'] as String?,
      latitude: coordinates is GeoPoint ? coordinates.latitude : null,
      longitude: coordinates is GeoPoint ? coordinates.longitude : null,
      neighborhood: doc['neighborhood'] as String?,
      locationReference: doc['locationReference'] as String?,
      setupCompleted: (doc['setupCompleted'] as bool?) ?? false,
    );
  }

  @override
  Future<VendorProfile> saveProfile(
    VendorProfile profile, {
    String? localPhotoPath,
  }) async {
    final uid = await _uid();

    // Foto del negocio → Storage (comprimida). Degradación: si Storage
    // no está disponible (plan Spark sin bucket), el perfil se guarda
    // SIN foto en vez de romper el flujo de configuración.
    var photoUrl = profile.photoUrl;
    if (localPhotoPath != null) {
      try {
        photoUrl =
            await _storage.uploadVendorPhoto(File(localPhotoPath), uid);
      } on AppException {
        photoUrl = profile.photoUrl;
      }
    }

    // `createdAt` solo se escribe la primera vez (merge no debe pisarlo).
    final exists = await _firestore.getDocument(_vendors, uid) != null;

    await _firestore.setDocument(
      _vendors,
      {
        'userId': uid,
        'businessName': profile.businessName,
        'photoUrl': ?photoUrl,
        if (profile.latitude != null && profile.longitude != null)
          'coordinates':
              GeoPoint(profile.latitude!, profile.longitude!),
        'neighborhood': profile.neighborhood ?? '',
        'zone': profile.neighborhood ?? '',
        'locationReference': ?profile.locationReference,
        'setupCompleted': true,
        'isActive': true,
        if (!exists) 'createdAt': FieldValue.serverTimestamp(),
      },
      id: uid,
      merge: true,
    );

    return profile.copyWith(photoUrl: photoUrl, setupCompleted: true);
  }
}
