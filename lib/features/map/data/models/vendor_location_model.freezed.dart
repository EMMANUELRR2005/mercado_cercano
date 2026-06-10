// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_location_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VendorLocationModel {

 VendorEntity get vendor; double get latitude; double get longitude; bool get isOnline; double? get lowestPriceToday; String? get lowestPriceProductName; double? get distanceMeters;
/// Create a copy of VendorLocationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorLocationModelCopyWith<VendorLocationModel> get copyWith => _$VendorLocationModelCopyWithImpl<VendorLocationModel>(this as VendorLocationModel, _$identity);

  /// Serializes this VendorLocationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorLocationModel&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.lowestPriceToday, lowestPriceToday) || other.lowestPriceToday == lowestPriceToday)&&(identical(other.lowestPriceProductName, lowestPriceProductName) || other.lowestPriceProductName == lowestPriceProductName)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vendor,latitude,longitude,isOnline,lowestPriceToday,lowestPriceProductName,distanceMeters);

@override
String toString() {
  return 'VendorLocationModel(vendor: $vendor, latitude: $latitude, longitude: $longitude, isOnline: $isOnline, lowestPriceToday: $lowestPriceToday, lowestPriceProductName: $lowestPriceProductName, distanceMeters: $distanceMeters)';
}


}

/// @nodoc
abstract mixin class $VendorLocationModelCopyWith<$Res>  {
  factory $VendorLocationModelCopyWith(VendorLocationModel value, $Res Function(VendorLocationModel) _then) = _$VendorLocationModelCopyWithImpl;
@useResult
$Res call({
 VendorEntity vendor, double latitude, double longitude, bool isOnline, double? lowestPriceToday, String? lowestPriceProductName, double? distanceMeters
});


$VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class _$VendorLocationModelCopyWithImpl<$Res>
    implements $VendorLocationModelCopyWith<$Res> {
  _$VendorLocationModelCopyWithImpl(this._self, this._then);

  final VendorLocationModel _self;
  final $Res Function(VendorLocationModel) _then;

/// Create a copy of VendorLocationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vendor = null,Object? latitude = null,Object? longitude = null,Object? isOnline = null,Object? lowestPriceToday = freezed,Object? lowestPriceProductName = freezed,Object? distanceMeters = freezed,}) {
  return _then(_self.copyWith(
vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,lowestPriceToday: freezed == lowestPriceToday ? _self.lowestPriceToday : lowestPriceToday // ignore: cast_nullable_to_non_nullable
as double?,lowestPriceProductName: freezed == lowestPriceProductName ? _self.lowestPriceProductName : lowestPriceProductName // ignore: cast_nullable_to_non_nullable
as String?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of VendorLocationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<$Res> get vendor {
  
  return $VendorEntityCopyWith<$Res>(_self.vendor, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}
}


/// Adds pattern-matching-related methods to [VendorLocationModel].
extension VendorLocationModelPatterns on VendorLocationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorLocationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorLocationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorLocationModel value)  $default,){
final _that = this;
switch (_that) {
case _VendorLocationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorLocationModel value)?  $default,){
final _that = this;
switch (_that) {
case _VendorLocationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VendorEntity vendor,  double latitude,  double longitude,  bool isOnline,  double? lowestPriceToday,  String? lowestPriceProductName,  double? distanceMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorLocationModel() when $default != null:
return $default(_that.vendor,_that.latitude,_that.longitude,_that.isOnline,_that.lowestPriceToday,_that.lowestPriceProductName,_that.distanceMeters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VendorEntity vendor,  double latitude,  double longitude,  bool isOnline,  double? lowestPriceToday,  String? lowestPriceProductName,  double? distanceMeters)  $default,) {final _that = this;
switch (_that) {
case _VendorLocationModel():
return $default(_that.vendor,_that.latitude,_that.longitude,_that.isOnline,_that.lowestPriceToday,_that.lowestPriceProductName,_that.distanceMeters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VendorEntity vendor,  double latitude,  double longitude,  bool isOnline,  double? lowestPriceToday,  String? lowestPriceProductName,  double? distanceMeters)?  $default,) {final _that = this;
switch (_that) {
case _VendorLocationModel() when $default != null:
return $default(_that.vendor,_that.latitude,_that.longitude,_that.isOnline,_that.lowestPriceToday,_that.lowestPriceProductName,_that.distanceMeters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorLocationModel extends VendorLocationModel {
  const _VendorLocationModel({required this.vendor, required this.latitude, required this.longitude, this.isOnline = true, this.lowestPriceToday, this.lowestPriceProductName, this.distanceMeters}): super._();
  factory _VendorLocationModel.fromJson(Map<String, dynamic> json) => _$VendorLocationModelFromJson(json);

@override final  VendorEntity vendor;
@override final  double latitude;
@override final  double longitude;
@override@JsonKey() final  bool isOnline;
@override final  double? lowestPriceToday;
@override final  String? lowestPriceProductName;
@override final  double? distanceMeters;

/// Create a copy of VendorLocationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorLocationModelCopyWith<_VendorLocationModel> get copyWith => __$VendorLocationModelCopyWithImpl<_VendorLocationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorLocationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorLocationModel&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.lowestPriceToday, lowestPriceToday) || other.lowestPriceToday == lowestPriceToday)&&(identical(other.lowestPriceProductName, lowestPriceProductName) || other.lowestPriceProductName == lowestPriceProductName)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vendor,latitude,longitude,isOnline,lowestPriceToday,lowestPriceProductName,distanceMeters);

@override
String toString() {
  return 'VendorLocationModel(vendor: $vendor, latitude: $latitude, longitude: $longitude, isOnline: $isOnline, lowestPriceToday: $lowestPriceToday, lowestPriceProductName: $lowestPriceProductName, distanceMeters: $distanceMeters)';
}


}

/// @nodoc
abstract mixin class _$VendorLocationModelCopyWith<$Res> implements $VendorLocationModelCopyWith<$Res> {
  factory _$VendorLocationModelCopyWith(_VendorLocationModel value, $Res Function(_VendorLocationModel) _then) = __$VendorLocationModelCopyWithImpl;
@override @useResult
$Res call({
 VendorEntity vendor, double latitude, double longitude, bool isOnline, double? lowestPriceToday, String? lowestPriceProductName, double? distanceMeters
});


@override $VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class __$VendorLocationModelCopyWithImpl<$Res>
    implements _$VendorLocationModelCopyWith<$Res> {
  __$VendorLocationModelCopyWithImpl(this._self, this._then);

  final _VendorLocationModel _self;
  final $Res Function(_VendorLocationModel) _then;

/// Create a copy of VendorLocationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vendor = null,Object? latitude = null,Object? longitude = null,Object? isOnline = null,Object? lowestPriceToday = freezed,Object? lowestPriceProductName = freezed,Object? distanceMeters = freezed,}) {
  return _then(_VendorLocationModel(
vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,lowestPriceToday: freezed == lowestPriceToday ? _self.lowestPriceToday : lowestPriceToday // ignore: cast_nullable_to_non_nullable
as double?,lowestPriceProductName: freezed == lowestPriceProductName ? _self.lowestPriceProductName : lowestPriceProductName // ignore: cast_nullable_to_non_nullable
as String?,distanceMeters: freezed == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of VendorLocationModel
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
