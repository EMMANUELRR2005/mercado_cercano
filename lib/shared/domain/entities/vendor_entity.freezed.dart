// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorEntity {

 String get id; String get name; String get phone; ProductCategory get category; double get rating; int get totalRatings; bool get isVerified; String? get photoUrl; String? get description; String? get address; double? get latitude; double? get longitude; String? get whatsapp;
/// Create a copy of VendorEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<VendorEntity> get copyWith => _$VendorEntityCopyWithImpl<VendorEntity>(this as VendorEntity, _$identity);

  /// Serializes this VendorEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.category, category) || other.category == category)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalRatings, totalRatings) || other.totalRatings == totalRatings)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.whatsapp, whatsapp) || other.whatsapp == whatsapp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,category,rating,totalRatings,isVerified,photoUrl,description,address,latitude,longitude,whatsapp);

@override
String toString() {
  return 'VendorEntity(id: $id, name: $name, phone: $phone, category: $category, rating: $rating, totalRatings: $totalRatings, isVerified: $isVerified, photoUrl: $photoUrl, description: $description, address: $address, latitude: $latitude, longitude: $longitude, whatsapp: $whatsapp)';
}


}

/// @nodoc
abstract mixin class $VendorEntityCopyWith<$Res>  {
  factory $VendorEntityCopyWith(VendorEntity value, $Res Function(VendorEntity) _then) = _$VendorEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phone, ProductCategory category, double rating, int totalRatings, bool isVerified, String? photoUrl, String? description, String? address, double? latitude, double? longitude, String? whatsapp
});




}
/// @nodoc
class _$VendorEntityCopyWithImpl<$Res>
    implements $VendorEntityCopyWith<$Res> {
  _$VendorEntityCopyWithImpl(this._self, this._then);

  final VendorEntity _self;
  final $Res Function(VendorEntity) _then;

/// Create a copy of VendorEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? category = null,Object? rating = null,Object? totalRatings = null,Object? isVerified = null,Object? photoUrl = freezed,Object? description = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? whatsapp = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalRatings: null == totalRatings ? _self.totalRatings : totalRatings // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,whatsapp: freezed == whatsapp ? _self.whatsapp : whatsapp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VendorEntity].
extension VendorEntityPatterns on VendorEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorEntity value)  $default,){
final _that = this;
switch (_that) {
case _VendorEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorEntity value)?  $default,){
final _that = this;
switch (_that) {
case _VendorEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  ProductCategory category,  double rating,  int totalRatings,  bool isVerified,  String? photoUrl,  String? description,  String? address,  double? latitude,  double? longitude,  String? whatsapp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorEntity() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.category,_that.rating,_that.totalRatings,_that.isVerified,_that.photoUrl,_that.description,_that.address,_that.latitude,_that.longitude,_that.whatsapp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  ProductCategory category,  double rating,  int totalRatings,  bool isVerified,  String? photoUrl,  String? description,  String? address,  double? latitude,  double? longitude,  String? whatsapp)  $default,) {final _that = this;
switch (_that) {
case _VendorEntity():
return $default(_that.id,_that.name,_that.phone,_that.category,_that.rating,_that.totalRatings,_that.isVerified,_that.photoUrl,_that.description,_that.address,_that.latitude,_that.longitude,_that.whatsapp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phone,  ProductCategory category,  double rating,  int totalRatings,  bool isVerified,  String? photoUrl,  String? description,  String? address,  double? latitude,  double? longitude,  String? whatsapp)?  $default,) {final _that = this;
switch (_that) {
case _VendorEntity() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.category,_that.rating,_that.totalRatings,_that.isVerified,_that.photoUrl,_that.description,_that.address,_that.latitude,_that.longitude,_that.whatsapp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorEntity implements VendorEntity {
  const _VendorEntity({required this.id, required this.name, required this.phone, required this.category, required this.rating, required this.totalRatings, required this.isVerified, this.photoUrl, this.description, this.address, this.latitude, this.longitude, this.whatsapp});
  factory _VendorEntity.fromJson(Map<String, dynamic> json) => _$VendorEntityFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phone;
@override final  ProductCategory category;
@override final  double rating;
@override final  int totalRatings;
@override final  bool isVerified;
@override final  String? photoUrl;
@override final  String? description;
@override final  String? address;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? whatsapp;

/// Create a copy of VendorEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorEntityCopyWith<_VendorEntity> get copyWith => __$VendorEntityCopyWithImpl<_VendorEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.category, category) || other.category == category)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalRatings, totalRatings) || other.totalRatings == totalRatings)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.whatsapp, whatsapp) || other.whatsapp == whatsapp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,category,rating,totalRatings,isVerified,photoUrl,description,address,latitude,longitude,whatsapp);

@override
String toString() {
  return 'VendorEntity(id: $id, name: $name, phone: $phone, category: $category, rating: $rating, totalRatings: $totalRatings, isVerified: $isVerified, photoUrl: $photoUrl, description: $description, address: $address, latitude: $latitude, longitude: $longitude, whatsapp: $whatsapp)';
}


}

/// @nodoc
abstract mixin class _$VendorEntityCopyWith<$Res> implements $VendorEntityCopyWith<$Res> {
  factory _$VendorEntityCopyWith(_VendorEntity value, $Res Function(_VendorEntity) _then) = __$VendorEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phone, ProductCategory category, double rating, int totalRatings, bool isVerified, String? photoUrl, String? description, String? address, double? latitude, double? longitude, String? whatsapp
});




}
/// @nodoc
class __$VendorEntityCopyWithImpl<$Res>
    implements _$VendorEntityCopyWith<$Res> {
  __$VendorEntityCopyWithImpl(this._self, this._then);

  final _VendorEntity _self;
  final $Res Function(_VendorEntity) _then;

/// Create a copy of VendorEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? category = null,Object? rating = null,Object? totalRatings = null,Object? isVerified = null,Object? photoUrl = freezed,Object? description = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? whatsapp = freezed,}) {
  return _then(_VendorEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalRatings: null == totalRatings ? _self.totalRatings : totalRatings // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,whatsapp: freezed == whatsapp ? _self.whatsapp : whatsapp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
