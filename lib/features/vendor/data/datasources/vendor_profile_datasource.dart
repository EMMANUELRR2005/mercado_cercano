import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/firebase/firestore_service.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/vendor_profile.dart';

/// Datasource del perfil público del negocio (`vendors/{uid}`).
abstract class VendorProfileDatasource {
  /// Perfil actual del vendedor, o `null` si nunca lo configuró.
  Future<VendorProfile?> getMyProfile();

  /// Guarda el perfil. Si [localPhotoPath] no es null, sube la foto
  /// primero (en modo real va a Storage `vendors/{uid}/profile.jpg`).
  Future<VendorProfile> saveProfile(
    VendorProfile profile, {
    String? localPhotoPath,
  });
}

/// Mock en memoria para el modo demo (`useMockData`): la "subida" de la
/// foto conserva la ruta local del archivo elegido.
class MockVendorProfileDatasource implements VendorProfileDatasource {
  VendorProfile? _profile;

  @override
  Future<VendorProfile?> getMyProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _profile;
  }

  @override
  Future<VendorProfile> saveProfile(
    VendorProfile profile, {
    String? localPhotoPath,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _profile = profile.copyWith(
      photoUrl: localPhotoPath ?? profile.photoUrl,
      setupCompleted: true,
    );
    return _profile!;
  }
}

/// Implementación real: Firestore (`vendors/{uid}`) + Firebase Storage
/// para la foto del negocio.
class FirestoreVendorProfileDatasource implements VendorProfileDatasource {
  FirestoreVendorProfileDatasource(this._firestore, this._secureStorage);

  final FirestoreService _firestore;
  final SecureStorageService _secureStorage;

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

    // Foto del negocio → Storage en `vendors/{uid}/profile.jpg`.
    var photoUrl = profile.photoUrl;
    if (localPhotoPath != null) {
      try {
        final ref =
            FirebaseStorage.instance.ref('vendors/$uid/profile.jpg');
        await ref.putFile(File(localPhotoPath));
        photoUrl = await ref.getDownloadURL();
      } on FirebaseException catch (e) {
        throw ServerException(
          'No se pudo subir la foto (${e.code}). Intenta de nuevo.',
        );
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
