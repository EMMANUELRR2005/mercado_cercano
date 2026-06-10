import '../../../../shared/domain/entities/product_entity.dart';

/// Borrador de publicación de producto (lo que llena el vendedor en el
/// flujo de 3 toques antes de crear el [ProductEntity] definitivo).
///
/// `photoUrl` puede ser un placeholder cuando el vendedor publica sin
/// foto (en simulador la cámara puede no estar disponible).
class ProductDraft {
  const ProductDraft({
    required this.name,
    required this.price,
    required this.category,
    required this.photoUrl,
    this.unit,
    this.description,
  });

  final String name;
  final double price;
  final ProductCategory category;
  final String photoUrl;
  final String? unit;
  final String? description;
}
