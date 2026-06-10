import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_entity.dart';

part 'vendor_entity.freezed.dart';
part 'vendor_entity.g.dart';

/// Vendedor del comercio informal.
///
/// `address`, `latitude` y `longitude` son opcionales por privacidad:
/// el vendedor decide si comparte su ubicación exacta.
@freezed
abstract class VendorEntity with _$VendorEntity {
  const factory VendorEntity({
    required String id,
    required String name,
    required String phone,
    required ProductCategory category,
    required double rating,
    required int totalRatings,
    required bool isVerified,
    String? photoUrl,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? whatsapp,
  }) = _VendorEntity;

  factory VendorEntity.fromJson(Map<String, dynamic> json) =>
      _$VendorEntityFromJson(json);
}
