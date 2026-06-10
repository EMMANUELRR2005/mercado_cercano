// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModel {

 String get id; String get vendorId; String get name; String get category; double get price; String get photoUrl; bool get isAvailable; DateTime get expiresAt; DateTime get createdAt; int get viewCount; int get clickCount; bool? get isFeatured; String? get description; String? get unit;
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModelCopyWith<ProductModel> get copyWith => _$ProductModelCopyWithImpl<ProductModel>(this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.price, price) || other.price == price)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.clickCount, clickCount) || other.clickCount == clickCount)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.description, description) || other.description == description)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,name,category,price,photoUrl,isAvailable,expiresAt,createdAt,viewCount,clickCount,isFeatured,description,unit);

@override
String toString() {
  return 'ProductModel(id: $id, vendorId: $vendorId, name: $name, category: $category, price: $price, photoUrl: $photoUrl, isAvailable: $isAvailable, expiresAt: $expiresAt, createdAt: $createdAt, viewCount: $viewCount, clickCount: $clickCount, isFeatured: $isFeatured, description: $description, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res>  {
  factory $ProductModelCopyWith(ProductModel value, $Res Function(ProductModel) _then) = _$ProductModelCopyWithImpl;
@useResult
$Res call({
 String id, String vendorId, String name, String category, double price, String photoUrl, bool isAvailable, DateTime expiresAt, DateTime createdAt, int viewCount, int clickCount, bool? isFeatured, String? description, String? unit
});




}
/// @nodoc
class _$ProductModelCopyWithImpl<$Res>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vendorId = null,Object? name = null,Object? category = null,Object? price = null,Object? photoUrl = null,Object? isAvailable = null,Object? expiresAt = null,Object? createdAt = null,Object? viewCount = null,Object? clickCount = null,Object? isFeatured = freezed,Object? description = freezed,Object? unit = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,clickCount: null == clickCount ? _self.clickCount : clickCount // ignore: cast_nullable_to_non_nullable
as int,isFeatured: freezed == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String vendorId,  String name,  String category,  double price,  String photoUrl,  bool isAvailable,  DateTime expiresAt,  DateTime createdAt,  int viewCount,  int clickCount,  bool? isFeatured,  String? description,  String? unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.vendorId,_that.name,_that.category,_that.price,_that.photoUrl,_that.isAvailable,_that.expiresAt,_that.createdAt,_that.viewCount,_that.clickCount,_that.isFeatured,_that.description,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String vendorId,  String name,  String category,  double price,  String photoUrl,  bool isAvailable,  DateTime expiresAt,  DateTime createdAt,  int viewCount,  int clickCount,  bool? isFeatured,  String? description,  String? unit)  $default,) {final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that.id,_that.vendorId,_that.name,_that.category,_that.price,_that.photoUrl,_that.isAvailable,_that.expiresAt,_that.createdAt,_that.viewCount,_that.clickCount,_that.isFeatured,_that.description,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String vendorId,  String name,  String category,  double price,  String photoUrl,  bool isAvailable,  DateTime expiresAt,  DateTime createdAt,  int viewCount,  int clickCount,  bool? isFeatured,  String? description,  String? unit)?  $default,) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.vendorId,_that.name,_that.category,_that.price,_that.photoUrl,_that.isAvailable,_that.expiresAt,_that.createdAt,_that.viewCount,_that.clickCount,_that.isFeatured,_that.description,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductModel extends ProductModel {
  const _ProductModel({required this.id, required this.vendorId, required this.name, required this.category, required this.price, required this.photoUrl, required this.isAvailable, required this.expiresAt, required this.createdAt, required this.viewCount, required this.clickCount, this.isFeatured, this.description, this.unit}): super._();
  factory _ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

@override final  String id;
@override final  String vendorId;
@override final  String name;
@override final  String category;
@override final  double price;
@override final  String photoUrl;
@override final  bool isAvailable;
@override final  DateTime expiresAt;
@override final  DateTime createdAt;
@override final  int viewCount;
@override final  int clickCount;
@override final  bool? isFeatured;
@override final  String? description;
@override final  String? unit;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModelCopyWith<_ProductModel> get copyWith => __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.price, price) || other.price == price)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.clickCount, clickCount) || other.clickCount == clickCount)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.description, description) || other.description == description)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,name,category,price,photoUrl,isAvailable,expiresAt,createdAt,viewCount,clickCount,isFeatured,description,unit);

@override
String toString() {
  return 'ProductModel(id: $id, vendorId: $vendorId, name: $name, category: $category, price: $price, photoUrl: $photoUrl, isAvailable: $isAvailable, expiresAt: $expiresAt, createdAt: $createdAt, viewCount: $viewCount, clickCount: $clickCount, isFeatured: $isFeatured, description: $description, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res> implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(_ProductModel value, $Res Function(_ProductModel) _then) = __$ProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String vendorId, String name, String category, double price, String photoUrl, bool isAvailable, DateTime expiresAt, DateTime createdAt, int viewCount, int clickCount, bool? isFeatured, String? description, String? unit
});




}
/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vendorId = null,Object? name = null,Object? category = null,Object? price = null,Object? photoUrl = null,Object? isAvailable = null,Object? expiresAt = null,Object? createdAt = null,Object? viewCount = null,Object? clickCount = null,Object? isFeatured = freezed,Object? description = freezed,Object? unit = freezed,}) {
  return _then(_ProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,clickCount: null == clickCount ? _self.clickCount : clickCount // ignore: cast_nullable_to_non_nullable
as int,isFeatured: freezed == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
