import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../errors/app_exception.dart';

/// Guardado de imágenes con compresión automática.
///
/// Intenta primero Firebase Storage; si el bucket no está disponible
/// (plan Spark: Cloud Storage exige Blaze para crear el bucket por
/// defecto), la imagen se guarda DENTRO de Firestore como data URI
/// base64 (`data:image/jpeg;base64,…`) con compresión extra para
/// respetar el límite de 1 MB por documento. Los data URIs se muestran
/// en la app con `AppImage`/`appImageProvider`.
class FirebaseStorageService {
  FirebaseStorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  /// Compresión estándar de la app: máx 800 px de ancho, calidad 85.
  static const int _maxWidth = 800;
  static const int _quality = 85;

  /// Compresión agresiva para imágenes embebidas en Firestore: el doc
  /// completo debe quedar muy por debajo del límite de 1 MB.
  static const int _embeddedMaxWidth = 480;
  static const int _embeddedQuality = 60;

  /// Tope del base64 embebido (~700 KB) para no acercarse al límite
  /// de 1 MB por documento de Firestore.
  static const int _maxEmbeddedChars = 700000;

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
      // aún no existe (plan Spark): la foto se guarda en Firestore.
      if (kDebugMode) {
        debugPrint('Storage no disponible (${e.code}): guardando en base64.');
      }
      return _encodeAsDataUri(image);
    }
  }

  /// Codifica la imagen como data URI base64 para guardarla dentro del
  /// documento de Firestore (fallback sin Storage).
  Future<String> _encodeAsDataUri(File image) async {
    final compressed = await _compress(
      image,
      maxWidth: _embeddedMaxWidth,
      quality: _embeddedQuality,
    );
    final encoded = base64Encode(await compressed.readAsBytes());
    if (encoded.length > _maxEmbeddedChars) {
      throw const ServerException(
        'La foto es demasiado grande para guardarla. Intenta con otra.',
      );
    }
    return 'data:image/jpeg;base64,$encoded';
  }

  /// Comprime a JPEG (máx [maxWidth] px de ancho, calidad [quality]).
  /// Si la compresión falla, devuelve el archivo original.
  Future<File> _compress(
    File image, {
    int maxWidth = _maxWidth,
    int quality = _quality,
  }) async {
    try {
      final targetPath =
          '${image.path}_c${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path,
        targetPath,
        minWidth: maxWidth,
        minHeight: 1,
        quality: quality,
        format: CompressFormat.jpeg,
      );
      return result != null ? File(result.path) : image;
    } catch (e) {
      if (kDebugMode) debugPrint('Compresión falló, subiendo original: $e');
      return image;
    }
  }
}
