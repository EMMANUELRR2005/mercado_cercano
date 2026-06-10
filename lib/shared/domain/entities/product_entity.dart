import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';
part 'product_entity.g.dart';

/// Categorías de productos del comercio informal.
enum ProductCategory {
  fruitsVegetables,
  meats,
  preparedFood,
  grains,
  dairy,
  clothing,
  services,
  other,
}

/// Etiquetas, íconos y colores de pin por categoría.
extension ProductCategoryX on ProductCategory {
  /// Nombre legible en español.
  String get label {
    switch (this) {
      case ProductCategory.fruitsVegetables:
        return 'Frutas y verduras';
      case ProductCategory.meats:
        return 'Carnes';
      case ProductCategory.preparedFood:
        return 'Comida preparada';
      case ProductCategory.grains:
        return 'Granos';
      case ProductCategory.dairy:
        return 'Lácteos';
      case ProductCategory.clothing:
        return 'Ropa';
      case ProductCategory.services:
        return 'Servicios';
      case ProductCategory.other:
        return 'Otros';
    }
  }

  /// Ícono representativo de la categoría.
  IconData get icon {
    switch (this) {
      case ProductCategory.fruitsVegetables:
        return Icons.eco;
      case ProductCategory.meats:
        return Icons.set_meal;
      case ProductCategory.preparedFood:
        return Icons.restaurant;
      case ProductCategory.grains:
        return Icons.grain;
      case ProductCategory.dairy:
        return Icons.icecream;
      case ProductCategory.clothing:
        return Icons.checkroom;
      case ProductCategory.services:
        return Icons.handyman;
      case ProductCategory.other:
        return Icons.category;
    }
  }

  /// Color del pin en el mapa para esta categoría.
  Color get pinColor {
    switch (this) {
      case ProductCategory.fruitsVegetables:
        return const Color(0xFF2D8F54);
      case ProductCategory.meats:
        return const Color(0xFFDC2626);
      case ProductCategory.preparedFood:
        return const Color(0xFFF59E0B);
      case ProductCategory.grains:
        return const Color(0xFFB45309);
      case ProductCategory.dairy:
        return const Color(0xFF3B82F6);
      case ProductCategory.clothing:
        return const Color(0xFF8B5CF6);
      case ProductCategory.services:
        return const Color(0xFF0D9488);
      case ProductCategory.other:
        return const Color(0xFF6B7280);
    }
  }
}

/// Producto publicado por un vendedor.
///
/// Los productos vencen a las `AppConstants.productExpiryHours` horas
/// de publicados (`expiresAt`) para garantizar precios frescos.
@freezed
abstract class ProductEntity with _$ProductEntity {
  const factory ProductEntity({
    required String id,
    required String vendorId,
    required String name,
    required ProductCategory category,
    required double price,
    required String photoUrl,
    required bool isAvailable,
    required DateTime expiresAt,
    required DateTime createdAt,
    required int viewCount,
    required int clickCount,
    bool? isFeatured,
    String? description,
    String? unit,
  }) = _ProductEntity;

  factory ProductEntity.fromJson(Map<String, dynamic> json) =>
      _$ProductEntityFromJson(json);
}
