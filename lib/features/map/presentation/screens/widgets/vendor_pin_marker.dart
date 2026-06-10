import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../shared/domain/entities/product_entity.dart';

/// Genera los pines custom del mapa por categoría de producto.
///
/// Dibuja con Canvas/PictureRecorder un pin circular del `pinColor` de
/// la categoría con su ícono al centro, y lo cachea por categoría para
/// no redibujar en cada rebuild de markers.
class VendorPinMarker {
  VendorPinMarker._();

  /// Caché por categoría: el dibujo solo ocurre una vez por sesión.
  static final Map<ProductCategory, BitmapDescriptor> _cache = {};

  /// Construye (o devuelve del caché) el pin de una categoría.
  ///
  /// Si el dibujo falla (p. ej. en tests o plataformas sin Skia),
  /// hace fallback al marker default con el hue del color de categoría.
  static Future<BitmapDescriptor> buildPin(ProductCategory category) async {
    final cached = _cache[category];
    if (cached != null) return cached;

    try {
      final descriptor = await _drawPin(category);
      _cache[category] = descriptor;
      return descriptor;
    } catch (_) {
      return BitmapDescriptor.defaultMarkerWithHue(
        HSVColor.fromColor(category.pinColor).hue,
      );
    }
  }

  static Future<BitmapDescriptor> _drawPin(ProductCategory category) async {
    const double size = 110;
    const double circleRadius = size * 0.32;
    const Offset circleCenter = Offset(size / 2, circleRadius + 6);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final fill = Paint()
      ..color = category.pinColor
      ..isAntiAlias = true;

    // Puntero del pin (triángulo hacia abajo).
    final pointer = Path()
      ..moveTo(size / 2 - circleRadius * 0.55, circleCenter.dy + circleRadius * 0.6)
      ..lineTo(size / 2, size - 4)
      ..lineTo(size / 2 + circleRadius * 0.55, circleCenter.dy + circleRadius * 0.6)
      ..close();
    canvas.drawPath(pointer, fill);

    // Círculo principal con borde blanco.
    canvas.drawCircle(
      circleCenter,
      circleRadius + 3.5,
      Paint()
        ..color = Colors.white
        ..isAntiAlias = true,
    );
    canvas.drawCircle(circleCenter, circleRadius, fill);

    // Ícono de la categoría al centro (glifo de MaterialIcons).
    final icon = category.icon;
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: circleRadius * 1.1,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      circleCenter - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    final image = await recorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) {
      throw StateError('No se pudo rasterizar el pin');
    }

    return BitmapDescriptor.bytes(
      bytes.buffer.asUint8List(),
      // Tamaño lógico en pantalla (dp): el bitmap se escala con nitidez.
      width: 44,
      height: 44,
    );
  }
}
