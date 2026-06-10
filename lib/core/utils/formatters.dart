import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formateadores de presentación (moneda, distancia, fechas).
class Formatters {
  Formatters._();

  static final NumberFormat _quetzalFormat = NumberFormat('#,##0.00', 'es_GT');

  /// Formatea un precio en Quetzales: `12.5 → "Q 12.50"`.
  static String formatQuetzal(double amount) {
    return 'Q ${_quetzalFormat.format(amount)}';
  }

  /// Formatea una distancia en metros: `350 → "350 m"`, `1200 → "1.2 km"`.
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    final km = meters / 1000;
    // Sin decimales innecesarios: "2 km" en vez de "2.0 km".
    final formatted = km.toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), '');
    return '$formatted km';
  }

  /// Fecha relativa en español: "Hace 5 min", "Hace 3 h", "Ayer", "12/03/2026".
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) return 'Hace un momento';
    if (difference.inMinutes < 60) return 'Hace ${difference.inMinutes} min';
    if (difference.inHours < 24) return 'Hace ${difference.inHours} h';

    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Ayer';
    }
    if (difference.inDays < 7) return 'Hace ${difference.inDays} días';

    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Cuenta regresiva de vencimiento de un producto:
  /// `"Vence en 3h 20m"`, `"Vence en 45m"` o `"Vencido"`.
  static String formatExpiryCountdown(DateTime expiresAt) {
    final remaining = expiresAt.difference(DateTime.now());
    if (remaining.isNegative) return 'Vencido';

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;

    if (hours > 0) {
      return 'Vence en ${hours}h ${minutes}m';
    }
    if (minutes > 0) {
      return 'Vence en ${minutes}m';
    }
    return 'Vence en menos de 1m';
  }
}

/// [TextInputFormatter] para campos de precio: solo dígitos, un punto
/// decimal y máximo 2 decimales (ej. "12.50").
class PriceInputFormatter extends TextInputFormatter {
  static final RegExp _pattern = RegExp(r'^\d*\.?\d{0,2}$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Permitir coma como separador y normalizarla a punto.
    final normalized = newValue.text.replaceAll(',', '.');
    if (normalized.isEmpty || _pattern.hasMatch(normalized)) {
      return newValue.copyWith(text: normalized);
    }
    return oldValue;
  }
}
