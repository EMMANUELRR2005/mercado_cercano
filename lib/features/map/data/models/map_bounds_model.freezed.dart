// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_bounds_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapBoundsModel {

 double get southWestLat; double get southWestLng; double get northEastLat; double get northEastLng;
/// Create a copy of MapBoundsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapBoundsModelCopyWith<MapBoundsModel> get copyWith => _$MapBoundsModelCopyWithImpl<MapBoundsModel>(this as MapBoundsModel, _$identity);

  /// Serializes this MapBoundsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapBoundsModel&&(identical(other.southWestLat, southWestLat) || other.southWestLat == southWestLat)&&(identical(other.southWestLng, southWestLng) || other.southWestLng == southWestLng)&&(identical(other.northEastLat, northEastLat) || other.northEastLat == northEastLat)&&(identical(other.northEastLng, northEastLng) || other.northEastLng == northEastLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,southWestLat,southWestLng,northEastLat,northEastLng);

@override
String toString() {
  return 'MapBoundsModel(southWestLat: $southWestLat, southWestLng: $southWestLng, northEastLat: $northEastLat, northEastLng: $northEastLng)';
}


}

/// @nodoc
abstract mixin class $MapBoundsModelCopyWith<$Res>  {
  factory $MapBoundsModelCopyWith(MapBoundsModel value, $Res Function(MapBoundsModel) _then) = _$MapBoundsModelCopyWithImpl;
@useResult
$Res call({
 double southWestLat, double southWestLng, double northEastLat, double northEastLng
});




}
/// @nodoc
class _$MapBoundsModelCopyWithImpl<$Res>
    implements $MapBoundsModelCopyWith<$Res> {
  _$MapBoundsModelCopyWithImpl(this._self, this._then);

  final MapBoundsModel _self;
  final $Res Function(MapBoundsModel) _then;

/// Create a copy of MapBoundsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? southWestLat = null,Object? southWestLng = null,Object? northEastLat = null,Object? northEastLng = null,}) {
  return _then(_self.copyWith(
southWestLat: null == southWestLat ? _self.southWestLat : southWestLat // ignore: cast_nullable_to_non_nullable
as double,southWestLng: null == southWestLng ? _self.southWestLng : southWestLng // ignore: cast_nullable_to_non_nullable
as double,northEastLat: null == northEastLat ? _self.northEastLat : northEastLat // ignore: cast_nullable_to_non_nullable
as double,northEastLng: null == northEastLng ? _self.northEastLng : northEastLng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MapBoundsModel].
extension MapBoundsModelPatterns on MapBoundsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapBoundsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapBoundsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapBoundsModel value)  $default,){
final _that = this;
switch (_that) {
case _MapBoundsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapBoundsModel value)?  $default,){
final _that = this;
switch (_that) {
case _MapBoundsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double southWestLat,  double southWestLng,  double northEastLat,  double northEastLng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapBoundsModel() when $default != null:
return $default(_that.southWestLat,_that.southWestLng,_that.northEastLat,_that.northEastLng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double southWestLat,  double southWestLng,  double northEastLat,  double northEastLng)  $default,) {final _that = this;
switch (_that) {
case _MapBoundsModel():
return $default(_that.southWestLat,_that.southWestLng,_that.northEastLat,_that.northEastLng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double southWestLat,  double southWestLng,  double northEastLat,  double northEastLng)?  $default,) {final _that = this;
switch (_that) {
case _MapBoundsModel() when $default != null:
return $default(_that.southWestLat,_that.southWestLng,_that.northEastLat,_that.northEastLng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MapBoundsModel extends MapBoundsModel {
  const _MapBoundsModel({required this.southWestLat, required this.southWestLng, required this.northEastLat, required this.northEastLng}): super._();
  factory _MapBoundsModel.fromJson(Map<String, dynamic> json) => _$MapBoundsModelFromJson(json);

@override final  double southWestLat;
@override final  double southWestLng;
@override final  double northEastLat;
@override final  double northEastLng;

/// Create a copy of MapBoundsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapBoundsModelCopyWith<_MapBoundsModel> get copyWith => __$MapBoundsModelCopyWithImpl<_MapBoundsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapBoundsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapBoundsModel&&(identical(other.southWestLat, southWestLat) || other.southWestLat == southWestLat)&&(identical(other.southWestLng, southWestLng) || other.southWestLng == southWestLng)&&(identical(other.northEastLat, northEastLat) || other.northEastLat == northEastLat)&&(identical(other.northEastLng, northEastLng) || other.northEastLng == northEastLng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,southWestLat,southWestLng,northEastLat,northEastLng);

@override
String toString() {
  return 'MapBoundsModel(southWestLat: $southWestLat, southWestLng: $southWestLng, northEastLat: $northEastLat, northEastLng: $northEastLng)';
}


}

/// @nodoc
abstract mixin class _$MapBoundsModelCopyWith<$Res> implements $MapBoundsModelCopyWith<$Res> {
  factory _$MapBoundsModelCopyWith(_MapBoundsModel value, $Res Function(_MapBoundsModel) _then) = __$MapBoundsModelCopyWithImpl;
@override @useResult
$Res call({
 double southWestLat, double southWestLng, double northEastLat, double northEastLng
});




}
/// @nodoc
class __$MapBoundsModelCopyWithImpl<$Res>
    implements _$MapBoundsModelCopyWith<$Res> {
  __$MapBoundsModelCopyWithImpl(this._self, this._then);

  final _MapBoundsModel _self;
  final $Res Function(_MapBoundsModel) _then;

/// Create a copy of MapBoundsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? southWestLat = null,Object? southWestLng = null,Object? northEastLat = null,Object? northEastLng = null,}) {
  return _then(_MapBoundsModel(
southWestLat: null == southWestLat ? _self.southWestLat : southWestLat // ignore: cast_nullable_to_non_nullable
as double,southWestLng: null == southWestLng ? _self.southWestLng : southWestLng // ignore: cast_nullable_to_non_nullable
as double,northEastLat: null == northEastLat ? _self.northEastLat : northEastLat // ignore: cast_nullable_to_non_nullable
as double,northEastLng: null == northEastLng ? _self.northEastLng : northEastLng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
