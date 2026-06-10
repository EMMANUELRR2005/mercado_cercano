// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductEntity {

 String get id; String get vendorId; String get name; ProductCategory get category; double get price; String get photoUrl; bool get isAvailable; DateTime get expiresAt; DateTime get createdAt; int get viewCount; int get clickCount; bool? get isFeatured; String? get description; String? get unit;
/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductEntityCopyWith<ProductEntity> get copyWith => _$ProductEntityCopyWithImpl<ProductEntity>(this as ProductEntity, _$identity);

  /// Serializes this ProductEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.price, price) || other.price == price)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.clickCount, clickCount) || other.clickCount == clickCount)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.description, description) || other.description == description)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,name,category,price,photoUrl,isAvailable,expiresAt,createdAt,viewCount,clickCount,isFeatured,description,unit);

@override
String toString() {
  return 'ProductEntity(id: $id, vendorId: $vendorId, name: $name, category: $category, price: $price, photoUrl: $photoUrl, isAvailable: $isAvailable, expiresAt: $expiresAt, createdAt: $createdAt, viewCount: $viewCount, clickCount: $clickCount, isFeatured: $isFeatured, description: $description, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $ProductEntityCopyWith<$Res>  {
  factory $ProductEntityCopyWith(ProductEntity value, $Res Function(ProductEntity) _then) = _$ProductEntityCopyWithImpl;
@useResult
$Res call({
 String id, String vendorId, String name, ProductCategory category, double price, String photoUrl, bool isAvailable, DateTime expiresAt, DateTime createdAt, int viewCount, int clickCount, bool? isFeatured, String? description, String? unit
});




}
/// @nodoc
class _$ProductEntityCopyWithImpl<$Res>
    implements $ProductEntityCopyWith<$Res> {
  _$ProductEntityCopyWithImpl(this._self, this._then);

  final ProductEntity _self;
  final $Res Function(ProductEntity) _then;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vendorId = null,Object? name = null,Object? category = null,Object? price = null,Object? photoUrl = null,Object? isAvailable = null,Object? expiresAt = null,Object? createdAt = null,Object? viewCount = null,Object? clickCount = null,Object? isFeatured = freezed,Object? description = freezed,Object? unit = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [ProductEntity].
extension ProductEntityPatterns on ProductEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String vendorId,  String name,  ProductCategory category,  double price,  String photoUrl,  bool isAvailable,  DateTime expiresAt,  DateTime createdAt,  int viewCount,  int clickCount,  bool? isFeatured,  String? description,  String? unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String vendorId,  String name,  ProductCategory category,  double price,  String photoUrl,  bool isAvailable,  DateTime expiresAt,  DateTime createdAt,  int viewCount,  int clickCount,  bool? isFeatured,  String? description,  String? unit)  $default,) {final _that = this;
switch (_that) {
case _ProductEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String vendorId,  String name,  ProductCategory category,  double price,  String photoUrl,  bool isAvailable,  DateTime expiresAt,  DateTime createdAt,  int viewCount,  int clickCount,  bool? isFeatured,  String? description,  String? unit)?  $default,) {final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
return $default(_that.id,_that.vendorId,_that.name,_that.category,_that.price,_that.photoUrl,_that.isAvailable,_that.expiresAt,_that.createdAt,_that.viewCount,_that.clickCount,_that.isFeatured,_that.description,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductEntity implements ProductEntity {
  const _ProductEntity({required this.id, required this.vendorId, required this.name, required this.category, required this.price, required this.photoUrl, required this.isAvailable, required this.expiresAt, required this.createdAt, required this.viewCount, required this.clickCount, this.isFeatured, this.description, this.unit});
  factory _ProductEntity.fromJson(Map<String, dynamic> json) => _$ProductEntityFromJson(json);

@override final  String id;
@override final  String vendorId;
@override final  String name;
@override final  ProductCategory category;
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

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductEntityCopyWith<_ProductEntity> get copyWith => __$ProductEntityCopyWithImpl<_ProductEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.price, price) || other.price == price)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.clickCount, clickCount) || other.clickCount == clickCount)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.description, description) || other.description == description)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,vendorId,name,category,price,photoUrl,isAvailable,expiresAt,createdAt,viewCount,clickCount,isFeatured,description,unit);

@override
String toString() {
  return 'ProductEntity(id: $id, vendorId: $vendorId, name: $name, category: $category, price: $price, photoUrl: $photoUrl, isAvailable: $isAvailable, expiresAt: $expiresAt, createdAt: $createdAt, viewCount: $viewCount, clickCount: $clickCount, isFeatured: $isFeatured, description: $description, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$ProductEntityCopyWith<$Res> implements $ProductEntityCopyWith<$Res> {
  factory _$ProductEntityCopyWith(_ProductEntity value, $Res Function(_ProductEntity) _then) = __$ProductEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String vendorId, String name, ProductCategory category, double price, String photoUrl, bool isAvailable, DateTime expiresAt, DateTime createdAt, int viewCount, int clickCount, bool? isFeatured, String? description, String? unit
});




}
/// @nodoc
class __$ProductEntityCopyWithImpl<$Res>
    implements _$ProductEntityCopyWith<$Res> {
  __$ProductEntityCopyWithImpl(this._self, this._then);

  final _ProductEntity _self;
  final $Res Function(_ProductEntity) _then;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vendorId = null,Object? name = null,Object? category = null,Object? price = null,Object? photoUrl = null,Object? isAvailable = null,Object? expiresAt = null,Object? createdAt = null,Object? viewCount = null,Object? clickCount = null,Object? isFeatured = freezed,Object? description = freezed,Object? unit = freezed,}) {
  return _then(_ProductEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
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
