import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/entities/product_entity.dart';
import '../../../../shared/domain/entities/vendor_entity.dart';

part 'vendor_model.freezed.dart';
part 'vendor_model.g.dart';

/// Modelo de vendedor de la capa de datos (espejo del JSON de la API).
///
/// `category` viaja como String para tolerar valores desconocidos del
/// backend; [toEntity] lo mapea al enum del dominio.
@freezed
abstract class VendorModel with _$VendorModel {
  const VendorModel._();

  const factory VendorModel({
    required String id,
    required String name,
    required String phone,
    required String category,
    required double rating,
    required int totalRatings,
    required bool isVerified,
    String? photoUrl,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? whatsapp,
  }) = _VendorModel;

  factory VendorModel.fromJson(Map<String, dynamic> json) =>
      _$VendorModelFromJson(json);

  /// Construye el modelo a partir de la entidad de dominio compartida.
  factory VendorModel.fromEntity(VendorEntity entity) {
    return VendorModel(
      id: entity.id,
      name: entity.name,
      phone: entity.phone,
      category: entity.category.name,
      rating: entity.rating,
      totalRatings: entity.totalRatings,
      isVerified: entity.isVerified,
      photoUrl: entity.photoUrl,
      description: entity.description,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      whatsapp: entity.whatsapp,
    );
  }

  /// Convierte el modelo de datos a la entidad de dominio compartida.
  VendorEntity toEntity() {
    return VendorEntity(
      id: id,
      name: name,
      phone: phone,
      category: ProductCategory.values.firstWhere(
        (c) => c.name == category,
        orElse: () => ProductCategory.other,
      ),
      rating: rating,
      totalRatings: totalRatings,
      isVerified: isVerified,
      photoUrl: photoUrl,
      description: description,
      address: address,
      latitude: latitude,
      longitude: longitude,
      whatsapp: whatsapp,
    );
  }
}
