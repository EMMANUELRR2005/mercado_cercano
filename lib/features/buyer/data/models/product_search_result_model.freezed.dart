// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_search_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductSearchResultModel {

 ProductEntity get product; VendorEntity get vendor; double get distanceKm;
/// Create a copy of ProductSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSearchResultModelCopyWith<ProductSearchResultModel> get copyWith => _$ProductSearchResultModelCopyWithImpl<ProductSearchResultModel>(this as ProductSearchResultModel, _$identity);

  /// Serializes this ProductSearchResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSearchResultModel&&(identical(other.product, product) || other.product == product)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,product,vendor,distanceKm);

@override
String toString() {
  return 'ProductSearchResultModel(product: $product, vendor: $vendor, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class $ProductSearchResultModelCopyWith<$Res>  {
  factory $ProductSearchResultModelCopyWith(ProductSearchResultModel value, $Res Function(ProductSearchResultModel) _then) = _$ProductSearchResultModelCopyWithImpl;
@useResult
$Res call({
 ProductEntity product, VendorEntity vendor, double distanceKm
});


$ProductEntityCopyWith<$Res> get product;$VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class _$ProductSearchResultModelCopyWithImpl<$Res>
    implements $ProductSearchResultModelCopyWith<$Res> {
  _$ProductSearchResultModelCopyWithImpl(this._self, this._then);

  final ProductSearchResultModel _self;
  final $Res Function(ProductSearchResultModel) _then;

/// Create a copy of ProductSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? vendor = null,Object? distanceKm = null,}) {
  return _then(_self.copyWith(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductEntity,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of ProductSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductEntityCopyWith<$Res> get product {
  
  return $ProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of ProductSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<$Res> get vendor {
  
  return $VendorEntityCopyWith<$Res>(_self.vendor, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductSearchResultModel].
extension ProductSearchResultModelPatterns on ProductSearchResultModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSearchResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSearchResultModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSearchResultModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductSearchResultModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSearchResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSearchResultModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductEntity product,  VendorEntity vendor,  double distanceKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSearchResultModel() when $default != null:
return $default(_that.product,_that.vendor,_that.distanceKm);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductEntity product,  VendorEntity vendor,  double distanceKm)  $default,) {final _that = this;
switch (_that) {
case _ProductSearchResultModel():
return $default(_that.product,_that.vendor,_that.distanceKm);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductEntity product,  VendorEntity vendor,  double distanceKm)?  $default,) {final _that = this;
switch (_that) {
case _ProductSearchResultModel() when $default != null:
return $default(_that.product,_that.vendor,_that.distanceKm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductSearchResultModel extends ProductSearchResultModel {
  const _ProductSearchResultModel({required this.product, required this.vendor, required this.distanceKm}): super._();
  factory _ProductSearchResultModel.fromJson(Map<String, dynamic> json) => _$ProductSearchResultModelFromJson(json);

@override final  ProductEntity product;
@override final  VendorEntity vendor;
@override final  double distanceKm;

/// Create a copy of ProductSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSearchResultModelCopyWith<_ProductSearchResultModel> get copyWith => __$ProductSearchResultModelCopyWithImpl<_ProductSearchResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductSearchResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSearchResultModel&&(identical(other.product, product) || other.product == product)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,product,vendor,distanceKm);

@override
String toString() {
  return 'ProductSearchResultModel(product: $product, vendor: $vendor, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class _$ProductSearchResultModelCopyWith<$Res> implements $ProductSearchResultModelCopyWith<$Res> {
  factory _$ProductSearchResultModelCopyWith(_ProductSearchResultModel value, $Res Function(_ProductSearchResultModel) _then) = __$ProductSearchResultModelCopyWithImpl;
@override @useResult
$Res call({
 ProductEntity product, VendorEntity vendor, double distanceKm
});


@override $ProductEntityCopyWith<$Res> get product;@override $VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class __$ProductSearchResultModelCopyWithImpl<$Res>
    implements _$ProductSearchResultModelCopyWith<$Res> {
  __$ProductSearchResultModelCopyWithImpl(this._self, this._then);

  final _ProductSearchResultModel _self;
  final $Res Function(_ProductSearchResultModel) _then;

/// Create a copy of ProductSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? vendor = null,Object? distanceKm = null,}) {
  return _then(_ProductSearchResultModel(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductEntity,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of ProductSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductEntityCopyWith<$Res> get product {
  
  return $ProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of ProductSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<$Res> get vendor {
  
  return $VendorEntityCopyWith<$Res>(_self.vendor, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}
}


/// @nodoc
mixin _$VendorDetailModel {

 VendorEntity get vendor; List<ProductEntity> get products; double? get distanceKm;
/// Create a copy of VendorDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorDetailModelCopyWith<VendorDetailModel> get copyWith => _$VendorDetailModelCopyWithImpl<VendorDetailModel>(this as VendorDetailModel, _$identity);

  /// Serializes this VendorDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorDetailModel&&(identical(other.vendor, vendor) || other.vendor == vendor)&&const DeepCollectionEquality().equals(other.products, products)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vendor,const DeepCollectionEquality().hash(products),distanceKm);

@override
String toString() {
  return 'VendorDetailModel(vendor: $vendor, products: $products, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class $VendorDetailModelCopyWith<$Res>  {
  factory $VendorDetailModelCopyWith(VendorDetailModel value, $Res Function(VendorDetailModel) _then) = _$VendorDetailModelCopyWithImpl;
@useResult
$Res call({
 VendorEntity vendor, List<ProductEntity> products, double? distanceKm
});


$VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class _$VendorDetailModelCopyWithImpl<$Res>
    implements $VendorDetailModelCopyWith<$Res> {
  _$VendorDetailModelCopyWithImpl(this._self, this._then);

  final VendorDetailModel _self;
  final $Res Function(VendorDetailModel) _then;

/// Create a copy of VendorDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vendor = null,Object? products = null,Object? distanceKm = freezed,}) {
  return _then(_self.copyWith(
vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductEntity>,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of VendorDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<$Res> get vendor {
  
  return $VendorEntityCopyWith<$Res>(_self.vendor, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}
}


/// Adds pattern-matching-related methods to [VendorDetailModel].
extension VendorDetailModelPatterns on VendorDetailModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorDetailModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _VendorDetailModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _VendorDetailModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VendorEntity vendor,  List<ProductEntity> products,  double? distanceKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorDetailModel() when $default != null:
return $default(_that.vendor,_that.products,_that.distanceKm);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VendorEntity vendor,  List<ProductEntity> products,  double? distanceKm)  $default,) {final _that = this;
switch (_that) {
case _VendorDetailModel():
return $default(_that.vendor,_that.products,_that.distanceKm);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VendorEntity vendor,  List<ProductEntity> products,  double? distanceKm)?  $default,) {final _that = this;
switch (_that) {
case _VendorDetailModel() when $default != null:
return $default(_that.vendor,_that.products,_that.distanceKm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorDetailModel extends VendorDetailModel {
  const _VendorDetailModel({required this.vendor, required final  List<ProductEntity> products, this.distanceKm}): _products = products,super._();
  factory _VendorDetailModel.fromJson(Map<String, dynamic> json) => _$VendorDetailModelFromJson(json);

@override final  VendorEntity vendor;
 final  List<ProductEntity> _products;
@override List<ProductEntity> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@override final  double? distanceKm;

/// Create a copy of VendorDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorDetailModelCopyWith<_VendorDetailModel> get copyWith => __$VendorDetailModelCopyWithImpl<_VendorDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorDetailModel&&(identical(other.vendor, vendor) || other.vendor == vendor)&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vendor,const DeepCollectionEquality().hash(_products),distanceKm);

@override
String toString() {
  return 'VendorDetailModel(vendor: $vendor, products: $products, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class _$VendorDetailModelCopyWith<$Res> implements $VendorDetailModelCopyWith<$Res> {
  factory _$VendorDetailModelCopyWith(_VendorDetailModel value, $Res Function(_VendorDetailModel) _then) = __$VendorDetailModelCopyWithImpl;
@override @useResult
$Res call({
 VendorEntity vendor, List<ProductEntity> products, double? distanceKm
});


@override $VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class __$VendorDetailModelCopyWithImpl<$Res>
    implements _$VendorDetailModelCopyWith<$Res> {
  __$VendorDetailModelCopyWithImpl(this._self, this._then);

  final _VendorDetailModel _self;
  final $Res Function(_VendorDetailModel) _then;

/// Create a copy of VendorDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vendor = null,Object? products = null,Object? distanceKm = freezed,}) {
  return _then(_VendorDetailModel(
vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductEntity>,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of VendorDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<$Res> get vendor {
  
  return $VendorEntityCopyWith<$Res>(_self.vendor, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}
}

// dart format on
