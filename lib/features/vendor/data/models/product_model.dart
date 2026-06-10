import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/product_entity.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Modelo de producto de la capa de datos (espejo del JSON de la API).
///
/// `category` viaja como String para tolerar valores desconocidos del
/// backend; [toEntity] lo mapea al enum del dominio.
@freezed
abstract class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required String id,
    required String vendorId,
    required String name,
    required String category,
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
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Construye el modelo a partir de la entidad de dominio compartida.
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      vendorId: entity.vendorId,
      name: entity.name,
      category: entity.category.name,
      price: entity.price,
      photoUrl: entity.photoUrl,
      isAvailable: entity.isAvailable,
      expiresAt: entity.expiresAt,
      createdAt: entity.createdAt,
      viewCount: entity.viewCount,
      clickCount: entity.clickCount,
      isFeatured: entity.isFeatured,
      description: entity.description,
      unit: entity.unit,
    );
  }

  /// Convierte el modelo de datos a la entidad de dominio compartida.
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      vendorId: vendorId,
      name: name,
      category: ProductCategory.values.firstWhere(
        (c) => c.name == category,
        orElse: () => ProductCategory.other,
      ),
      price: price,
      photoUrl: photoUrl,
      isAvailable: isAvailable,
      expiresAt: expiresAt,
      createdAt: createdAt,
      viewCount: viewCount,
      clickCount: clickCount,
      isFeatured: isFeatured,
      description: description,
      unit: unit,
    );
  }
}
