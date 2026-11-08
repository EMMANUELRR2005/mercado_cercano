import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mercado_cercano/core/utils/formatters.dart';

/// El formato de precio debe ser SIEMPRE estilo Guatemala (punto decimal,
/// coma de miles, 2 decimales) e independiente del idioma de la app.
void main() {
  group('formatQuetzal', () {
    test('punto decimal y exactamente 2 decimales', () {
      expect(Formatters.formatQuetzal(5), 'Q 5.00');
      expect(Formatters.formatQuetzal(5.5), 'Q 5.50');
    });

    test('coma como separador de miles', () {
      expect(Formatters.formatQuetzal(1234.5), 'Q 1,234.50');
      expect(Formatters.formatQuetzal(1000000), 'Q 1,000,000.00');
    });

    test('NO depende del idioma de la app: con locale "es" sigue con punto',
        () {
      final original = Intl.defaultLocale;
      Intl.defaultLocale = 'es'; // como si la UI estuviera en español
      try {
        expect(Formatters.formatQuetzal(5), 'Q 5.00');
        expect(Formatters.formatQuetzal(1234.5), 'Q 1,234.50');
      } finally {
        Intl.defaultLocale = original;
      }
    });
  });

  group('formatQuetzalCompact', () {
    test('sin decimales forzados, con coma de miles', () {
      expect(Formatters.formatQuetzalCompact(5), 'Q 5');
      expect(Formatters.formatQuetzalCompact(1234), 'Q 1,234');
    });
  });
}
