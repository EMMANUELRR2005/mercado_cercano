// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_search_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductSearchResultModel _$ProductSearchResultModelFromJson(
  Map<String, dynamic> json,
) => _ProductSearchResultModel(
  product: ProductEntity.fromJson(json['product'] as Map<String, dynamic>),
  vendor: VendorEntity.fromJson(json['vendor'] as Map<String, dynamic>),
  distanceKm: (json['distanceKm'] as num).toDouble(),
);

Map<String, dynamic> _$ProductSearchResultModelToJson(
  _ProductSearchResultModel instance,
) => <String, dynamic>{
  'product': instance.product,
  'vendor': instance.vendor,
  'distanceKm': instance.distanceKm,
};

_VendorDetailModel _$VendorDetailModelFromJson(Map<String, dynamic> json) =>
    _VendorDetailModel(
      vendor: VendorEntity.fromJson(json['vendor'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$VendorDetailModelToJson(_VendorDetailModel instance) =>
    <String, dynamic>{
      'vendor': instance.vendor,
      'products': instance.products,
      'distanceKm': instance.distanceKm,
    };
