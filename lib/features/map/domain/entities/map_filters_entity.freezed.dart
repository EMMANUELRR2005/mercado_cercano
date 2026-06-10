// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_filters_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapFiltersEntity {

 double get radiusKm; ProductCategory? get category; bool get onlyVerified;
/// Create a copy of MapFiltersEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapFiltersEntityCopyWith<MapFiltersEntity> get copyWith => _$MapFiltersEntityCopyWithImpl<MapFiltersEntity>(this as MapFiltersEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapFiltersEntity&&(identical(other.radiusKm, radiusKm) || other.radiusKm == radiusKm)&&(identical(other.category, category) || other.category == category)&&(identical(other.onlyVerified, onlyVerified) || other.onlyVerified == onlyVerified));
}


@override
int get hashCode => Object.hash(runtimeType,radiusKm,category,onlyVerified);

@override
String toString() {
  return 'MapFiltersEntity(radiusKm: $radiusKm, category: $category, onlyVerified: $onlyVerified)';
}


}

/// @nodoc
abstract mixin class $MapFiltersEntityCopyWith<$Res>  {
  factory $MapFiltersEntityCopyWith(MapFiltersEntity value, $Res Function(MapFiltersEntity) _then) = _$MapFiltersEntityCopyWithImpl;
@useResult
$Res call({
 double radiusKm, ProductCategory? category, bool onlyVerified
});




}
/// @nodoc
class _$MapFiltersEntityCopyWithImpl<$Res>
    implements $MapFiltersEntityCopyWith<$Res> {
  _$MapFiltersEntityCopyWithImpl(this._self, this._then);

  final MapFiltersEntity _self;
  final $Res Function(MapFiltersEntity) _then;

/// Create a copy of MapFiltersEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? radiusKm = null,Object? category = freezed,Object? onlyVerified = null,}) {
  return _then(_self.copyWith(
radiusKm: null == radiusKm ? _self.radiusKm : radiusKm // ignore: cast_nullable_to_non_nullable
as double,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory?,onlyVerified: null == onlyVerified ? _self.onlyVerified : onlyVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MapFiltersEntity].
extension MapFiltersEntityPatterns on MapFiltersEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapFiltersEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapFiltersEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapFiltersEntity value)  $default,){
final _that = this;
switch (_that) {
case _MapFiltersEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapFiltersEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MapFiltersEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double radiusKm,  ProductCategory? category,  bool onlyVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapFiltersEntity() when $default != null:
return $default(_that.radiusKm,_that.category,_that.onlyVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double radiusKm,  ProductCategory? category,  bool onlyVerified)  $default,) {final _that = this;
switch (_that) {
case _MapFiltersEntity():
return $default(_that.radiusKm,_that.category,_that.onlyVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double radiusKm,  ProductCategory? category,  bool onlyVerified)?  $default,) {final _that = this;
switch (_that) {
case _MapFiltersEntity() when $default != null:
return $default(_that.radiusKm,_that.category,_that.onlyVerified);case _:
  return null;

}
}

}

/// @nodoc


class _MapFiltersEntity implements MapFiltersEntity {
  const _MapFiltersEntity({this.radiusKm = 5.0, this.category, this.onlyVerified = false});
  

@override@JsonKey() final  double radiusKm;
@override final  ProductCategory? category;
@override@JsonKey() final  bool onlyVerified;

/// Create a copy of MapFiltersEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapFiltersEntityCopyWith<_MapFiltersEntity> get copyWith => __$MapFiltersEntityCopyWithImpl<_MapFiltersEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapFiltersEntity&&(identical(other.radiusKm, radiusKm) || other.radiusKm == radiusKm)&&(identical(other.category, category) || other.category == category)&&(identical(other.onlyVerified, onlyVerified) || other.onlyVerified == onlyVerified));
}


@override
int get hashCode => Object.hash(runtimeType,radiusKm,category,onlyVerified);

@override
String toString() {
  return 'MapFiltersEntity(radiusKm: $radiusKm, category: $category, onlyVerified: $onlyVerified)';
}


}

/// @nodoc
abstract mixin class _$MapFiltersEntityCopyWith<$Res> implements $MapFiltersEntityCopyWith<$Res> {
  factory _$MapFiltersEntityCopyWith(_MapFiltersEntity value, $Res Function(_MapFiltersEntity) _then) = __$MapFiltersEntityCopyWithImpl;
@override @useResult
$Res call({
 double radiusKm, ProductCategory? category, bool onlyVerified
});




}
/// @nodoc
class __$MapFiltersEntityCopyWithImpl<$Res>
    implements _$MapFiltersEntityCopyWith<$Res> {
  __$MapFiltersEntityCopyWithImpl(this._self, this._then);

  final _MapFiltersEntity _self;
  final $Res Function(_MapFiltersEntity) _then;

/// Create a copy of MapFiltersEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? radiusKm = null,Object? category = freezed,Object? onlyVerified = null,}) {
  return _then(_MapFiltersEntity(
radiusKm: null == radiusKm ? _self.radiusKm : radiusKm // ignore: cast_nullable_to_non_nullable
as double,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory?,onlyVerified: null == onlyVerified ? _self.onlyVerified : onlyVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
