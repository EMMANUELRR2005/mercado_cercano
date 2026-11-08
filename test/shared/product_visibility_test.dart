import 'package:flutter_test/flutter_test.dart';
import 'package:mercado_cercano/shared/domain/entities/product_entity.dart';

/// Regla ÚNICA de visibilidad del comprador (vigente + disponible).
///
/// La comparten Inicio, Búsqueda, el sheet del pin del mapa y el perfil
/// del vendedor: un producto debe aparecer (u ocultarse) igual en todos.
void main() {
  final now = DateTime(2026, 6, 18, 12);

  ProductEntity product({
    required bool isAvailable,
    required DateTime expiresAt,
  }) {
    return ProductEntity(
      id: 'p1',
      vendorId: 'v1',
      name: 'Tomate',
      category: ProductCategory.fruitsVegetables,
      price: 5,
      photoUrl: '',
      isAvailable: isAvailable,
      expiresAt: expiresAt,
      createdAt: now.subtract(const Duration(hours: 1)),
      viewCount: 0,
      clickCount: 0,
    );
  }

  group('isVigente', () {
    test('vigente si expiresAt es futuro', () {
      final p = product(
        isAvailable: true,
        expiresAt: now.add(const Duration(hours: 1)),
      );
      expect(p.isVigente(now), isTrue);
    });

    test('NO vigente si ya venció', () {
      final p = product(
        isAvailable: true,
        expiresAt: now.subtract(const Duration(minutes: 1)),
      );
      expect(p.isVigente(now), isFalse);
    });
  });

  group('isVisibleToBuyer', () {
    test('visible: vigente Y disponible', () {
      final p = product(
        isAvailable: true,
        expiresAt: now.add(const Duration(hours: 2)),
      );
      expect(p.isVisibleToBuyer(now), isTrue);
    });

    test('oculto si está agotado (no disponible), aunque siga vigente', () {
      final p = product(
        isAvailable: false,
        expiresAt: now.add(const Duration(hours: 2)),
      );
      expect(p.isVisibleToBuyer(now), isFalse);
    });

    test('oculto si venció, aunque esté disponible', () {
      final p = product(
        isAvailable: true,
        expiresAt: now.subtract(const Duration(hours: 1)),
      );
      expect(p.isVisibleToBuyer(now), isFalse);
    });

    test('oculto si venció Y está agotado', () {
      final p = product(
        isAvailable: false,
        expiresAt: now.subtract(const Duration(hours: 1)),
      );
      expect(p.isVisibleToBuyer(now), isFalse);
    });
  });
}
