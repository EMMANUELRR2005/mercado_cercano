// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RatingEntity {

 String get id; String get vendorId; String get buyerId; double get stars; DateTime get createdAt; String? get comment;
/// Create a copy of RatingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RatingEntityCopyWith<RatingEntity> get copyWith => _$RatingEntityCopyWithImpl<RatingEntity>(this as RatingEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.stars, stars) || other.stars == stars)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.comment, comment) || other.comment == comment));
}


@override
int get hashCode => Object.hash(runtimeType,id,vendorId,buyerId,stars,createdAt,comment);

@override
String toString() {
  return 'RatingEntity(id: $id, vendorId: $vendorId, buyerId: $buyerId, stars: $stars, createdAt: $createdAt, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $RatingEntityCopyWith<$Res>  {
  factory $RatingEntityCopyWith(RatingEntity value, $Res Function(RatingEntity) _then) = _$RatingEntityCopyWithImpl;
@useResult
$Res call({
 String id, String vendorId, String buyerId, double stars, DateTime createdAt, String? comment
});




}
/// @nodoc
class _$RatingEntityCopyWithImpl<$Res>
    implements $RatingEntityCopyWith<$Res> {
  _$RatingEntityCopyWithImpl(this._self, this._then);

  final RatingEntity _self;
  final $Res Function(RatingEntity) _then;

/// Create a copy of RatingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vendorId = null,Object? buyerId = null,Object? stars = null,Object? createdAt = null,Object? comment = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,stars: null == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RatingEntity].
extension RatingEntityPatterns on RatingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RatingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RatingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RatingEntity value)  $default,){
final _that = this;
switch (_that) {
case _RatingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RatingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RatingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String vendorId,  String buyerId,  double stars,  DateTime createdAt,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RatingEntity() when $default != null:
return $default(_that.id,_that.vendorId,_that.buyerId,_that.stars,_that.createdAt,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String vendorId,  String buyerId,  double stars,  DateTime createdAt,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _RatingEntity():
return $default(_that.id,_that.vendorId,_that.buyerId,_that.stars,_that.createdAt,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String vendorId,  String buyerId,  double stars,  DateTime createdAt,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _RatingEntity() when $default != null:
return $default(_that.id,_that.vendorId,_that.buyerId,_that.stars,_that.createdAt,_that.comment);case _:
  return null;

}
}

}

/// @nodoc


class _RatingEntity implements RatingEntity {
  const _RatingEntity({required this.id, required this.vendorId, required this.buyerId, required this.stars, required this.createdAt, this.comment});
  

@override final  String id;
@override final  String vendorId;
@override final  String buyerId;
@override final  double stars;
@override final  DateTime createdAt;
@override final  String? comment;

/// Create a copy of RatingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RatingEntityCopyWith<_RatingEntity> get copyWith => __$RatingEntityCopyWithImpl<_RatingEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RatingEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.stars, stars) || other.stars == stars)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.comment, comment) || other.comment == comment));
}


@override
int get hashCode => Object.hash(runtimeType,id,vendorId,buyerId,stars,createdAt,comment);

@override
String toString() {
  return 'RatingEntity(id: $id, vendorId: $vendorId, buyerId: $buyerId, stars: $stars, createdAt: $createdAt, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$RatingEntityCopyWith<$Res> implements $RatingEntityCopyWith<$Res> {
  factory _$RatingEntityCopyWith(_RatingEntity value, $Res Function(_RatingEntity) _then) = __$RatingEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String vendorId, String buyerId, double stars, DateTime createdAt, String? comment
});




}
/// @nodoc
class __$RatingEntityCopyWithImpl<$Res>
    implements _$RatingEntityCopyWith<$Res> {
  __$RatingEntityCopyWithImpl(this._self, this._then);

  final _RatingEntity _self;
  final $Res Function(_RatingEntity) _then;

/// Create a copy of RatingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vendorId = null,Object? buyerId = null,Object? stars = null,Object? createdAt = null,Object? comment = freezed,}) {
  return _then(_RatingEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,stars: null == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
