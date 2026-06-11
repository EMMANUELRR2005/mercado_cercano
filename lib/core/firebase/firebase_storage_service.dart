import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../errors/app_exception.dart';

/// Subida de imágenes a Firebase Storage con compresión automática.
///
/// IMPORTANTE (plan de facturación): Cloud Storage para Firebase exige
/// plan Blaze para crear el bucket por defecto. Mientras el proyecto
/// siga en Spark, toda subida lanzará [ServerException]; los callers
/// degradan con gracia (placeholder / sin foto) para no romper flujos.
class FirebaseStorageService {
  FirebaseStorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  /// Compresión estándar de la app: máx 800 px de ancho, calidad 85.
  static const int _maxWidth = 800;
  static const int _quality = 85;

  /// Foto de un producto → `products/{vendorId}/{timestamp}.jpg`.
  Future<String> uploadProductPhoto(File image, String vendorId) {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    return _upload(image, 'products/$vendorId/$fileName');
  }

  /// Foto del negocio → `vendors/{vendorId}/profile.jpg`.
  Future<String> uploadVendorPhoto(File image, String vendorId) {
    return _upload(image, 'vendors/$vendorId/profile.jpg');
  }

  /// Borra una foto a partir de su download URL (ignora si no existe).
  Future<void> deletePhoto(String photoUrl) async {
    try {
      await _storage.refFromURL(photoUrl).delete();
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') return;
      throw ServerException(
        'No se pudo eliminar la foto (${e.code}).',
      );
    } on ArgumentError {
      // URL que no pertenece a Storage (placeholder/local): nada que borrar.
    }
  }

  // -------------------------------------------------------------------
  // Internos
  // -------------------------------------------------------------------

  Future<String> _upload(File image, String path) async {
    final compressed = await _compress(image);
    try {
      final ref = _storage.ref(path);
      await ref.putFile(
        compressed,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      // 'object-not-found'/'no-default-bucket' aparece cuando el bucket
      // aún no existe (plan Spark): el caller degrada con placeholder.
      throw ServerException(
        'No se pudo subir la foto (${e.code}). Intenta de nuevo.',
      );
    }
  }

  /// Comprime a JPEG (máx [_maxWidth] px de ancho, calidad [_quality]).
  /// Si la compresión falla, sube el archivo original.
  Future<File> _compress(File image) async {
    try {
      final targetPath =
          '${image.path}_c${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        targetPath,
        minWidth: _maxWidth,
        minHeight: 1,
        quality: _quality,
        format: CompressFormat.jpeg,
      );
      return result != null ? File(result.path) : image;
    } catch (e) {
      if (kDebugMode) debugPrint('Compresión falló, subiendo original: $e');
      return image;
    }
  }
}
