import 'package:flutter/material.dart';

import 'formatters.dart';

/// Extensiones sobre [String].
extension StringX on String {
  /// "tomate" → "Tomate".
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// Extensiones sobre [DateTime].
extension DateTimeX on DateTime {
  /// `true` si la fecha es hoy.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Tiempo transcurrido en español: "Hace 5 min", "Ayer", etc.
  String get timeAgo => Formatters.formatRelativeDate(this);
}

/// Extensiones sobre [double].
extension DoubleX on double {
  /// `12.5 → "Q 12.50"`.
  String toQuetzal() => Formatters.formatQuetzal(this);
}

/// Atajos sobre [BuildContext] para tema, media query y snackbars.
extension BuildContextX on BuildContext {
  // --- Theme ---
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // --- MediaQuery ---
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  bool get isKeyboardOpen => viewInsets.bottom > 0;

  // --- SnackBars ---
  /// Muestra un snackbar simple. Si [isError] es true se pinta en rojo.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? colorScheme.error : null,
        ),
      );
  }
}
