// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportEntity {

 String get id; String get vendorId; String get reason; DateTime get createdAt; String? get description;
/// Create a copy of ReportEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportEntityCopyWith<ReportEntity> get copyWith => _$ReportEntityCopyWithImpl<ReportEntity>(this as ReportEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,vendorId,reason,createdAt,description);

@override
String toString() {
  return 'ReportEntity(id: $id, vendorId: $vendorId, reason: $reason, createdAt: $createdAt, description: $description)';
}


}

/// @nodoc
abstract mixin class $ReportEntityCopyWith<$Res>  {
  factory $ReportEntityCopyWith(ReportEntity value, $Res Function(ReportEntity) _then) = _$ReportEntityCopyWithImpl;
@useResult
$Res call({
 String id, String vendorId, String reason, DateTime createdAt, String? description
});




}
/// @nodoc
class _$ReportEntityCopyWithImpl<$Res>
    implements $ReportEntityCopyWith<$Res> {
  _$ReportEntityCopyWithImpl(this._self, this._then);

  final ReportEntity _self;
  final $Res Function(ReportEntity) _then;

/// Create a copy of ReportEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? vendorId = null,Object? reason = null,Object? createdAt = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportEntity].
extension ReportEntityPatterns on ReportEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportEntity value)  $default,){
final _that = this;
switch (_that) {
case _ReportEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ReportEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String vendorId,  String reason,  DateTime createdAt,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportEntity() when $default != null:
return $default(_that.id,_that.vendorId,_that.reason,_that.createdAt,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String vendorId,  String reason,  DateTime createdAt,  String? description)  $default,) {final _that = this;
switch (_that) {
case _ReportEntity():
return $default(_that.id,_that.vendorId,_that.reason,_that.createdAt,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String vendorId,  String reason,  DateTime createdAt,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _ReportEntity() when $default != null:
return $default(_that.id,_that.vendorId,_that.reason,_that.createdAt,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _ReportEntity implements ReportEntity {
  const _ReportEntity({required this.id, required this.vendorId, required this.reason, required this.createdAt, this.description});
  

@override final  String id;
@override final  String vendorId;
@override final  String reason;
@override final  DateTime createdAt;
@override final  String? description;

/// Create a copy of ReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportEntityCopyWith<_ReportEntity> get copyWith => __$ReportEntityCopyWithImpl<_ReportEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.vendorId, vendorId) || other.vendorId == vendorId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,vendorId,reason,createdAt,description);

@override
String toString() {
  return 'ReportEntity(id: $id, vendorId: $vendorId, reason: $reason, createdAt: $createdAt, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ReportEntityCopyWith<$Res> implements $ReportEntityCopyWith<$Res> {
  factory _$ReportEntityCopyWith(_ReportEntity value, $Res Function(_ReportEntity) _then) = __$ReportEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String vendorId, String reason, DateTime createdAt, String? description
});




}
/// @nodoc
class __$ReportEntityCopyWithImpl<$Res>
    implements _$ReportEntityCopyWith<$Res> {
  __$ReportEntityCopyWithImpl(this._self, this._then);

  final _ReportEntity _self;
  final $Res Function(_ReportEntity) _then;

/// Create a copy of ReportEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? vendorId = null,Object? reason = null,Object? createdAt = null,Object? description = freezed,}) {
  return _then(_ReportEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,vendorId: null == vendorId ? _self.vendorId : vendorId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
