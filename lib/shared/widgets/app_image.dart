import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Imagen de la app que entiende los tres orígenes posibles de un
/// `photoUrl`:
///
/// - `http(s)://…` — Firebase Storage o cualquier URL (con caché).
/// - `data:image/…;base64,…` — imágenes guardadas DENTRO de Firestore
///   (fallback del plan Spark sin bucket de Storage).
/// - ruta local — archivo recién elegido con el picker.
///
/// La firma de [placeholder]/[errorWidget] replica la de
/// `CachedNetworkImage` para que sea un reemplazo directo.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final BoxFit? fit;
  final Widget Function(BuildContext context, String url)? placeholder;
  final Widget Function(BuildContext context, String url, Object error)?
      errorWidget;

  Widget _fallback(BuildContext context, Object error) {
    return errorWidget?.call(context, imageUrl, error) ??
        placeholder?.call(context, imageUrl) ??
        const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url.isEmpty) return _fallback(context, 'sin foto');

    if (url.startsWith('data:')) {
      final bytes = dataUriBytes(url);
      if (bytes == null) return _fallback(context, 'data URI inválido');
      return Image.memory(
        bytes,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (context, error, _) => _fallback(context, error),
      );
    }

    if (url.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        placeholder: placeholder,
        errorWidget: errorWidget,
      );
    }

    return Image.file(
      File(url),
      fit: fit,
      errorBuilder: (context, error, _) => _fallback(context, error),
    );
  }
}

/// `ImageProvider` con la misma lógica que [AppImage], para los lugares
/// que necesitan un provider (p. ej. `CircleAvatar.foregroundImage`).
/// Devuelve null si [url] es null o vacío.
ImageProvider? appImageProvider(String? url) {
  if (url == null || url.isEmpty) return null;
  if (url.startsWith('data:')) {
    final bytes = dataUriBytes(url);
    return bytes != null ? MemoryImage(bytes) : null;
  }
  if (url.startsWith('http')) return CachedNetworkImageProvider(url);
  return FileImage(File(url));
}

/// Caché de bytes decodificados: evita re-decodificar el base64 en cada
/// rebuild y mantiene estable la clave del `ImageCache` (MemoryImage
/// compara los bytes por identidad).
final Map<String, Uint8List> _dataUriCache = {};
const int _dataUriCacheLimit = 40;

/// Decodifica un data URI base64; null si está malformado.
@visibleForTesting
Uint8List? dataUriBytes(String dataUri) {
  final cached = _dataUriCache[dataUri];
  if (cached != null) return cached;
  final comma = dataUri.indexOf(',');
  if (comma < 0) return null;
  try {
    final bytes = base64Decode(dataUri.substring(comma + 1));
    if (_dataUriCache.length >= _dataUriCacheLimit) _dataUriCache.clear();
    _dataUriCache[dataUri] = bytes;
    return bytes;
  } on FormatException {
    return null;
  }
}
