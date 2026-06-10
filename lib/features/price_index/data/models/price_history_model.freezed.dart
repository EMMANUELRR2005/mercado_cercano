// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PricePointModel {

 DateTime get date; double get price; double? get zoneAverage;
/// Create a copy of PricePointModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PricePointModelCopyWith<PricePointModel> get copyWith => _$PricePointModelCopyWithImpl<PricePointModel>(this as PricePointModel, _$identity);

  /// Serializes this PricePointModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PricePointModel&&(identical(other.date, date) || other.date == date)&&(identical(other.price, price) || other.price == price)&&(identical(other.zoneAverage, zoneAverage) || other.zoneAverage == zoneAverage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,price,zoneAverage);

@override
String toString() {
  return 'PricePointModel(date: $date, price: $price, zoneAverage: $zoneAverage)';
}


}

/// @nodoc
abstract mixin class $PricePointModelCopyWith<$Res>  {
  factory $PricePointModelCopyWith(PricePointModel value, $Res Function(PricePointModel) _then) = _$PricePointModelCopyWithImpl;
@useResult
$Res call({
 DateTime date, double price, double? zoneAverage
});




}
/// @nodoc
class _$PricePointModelCopyWithImpl<$Res>
    implements $PricePointModelCopyWith<$Res> {
  _$PricePointModelCopyWithImpl(this._self, this._then);

  final PricePointModel _self;
  final $Res Function(PricePointModel) _then;

/// Create a copy of PricePointModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? price = null,Object? zoneAverage = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,zoneAverage: freezed == zoneAverage ? _self.zoneAverage : zoneAverage // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [PricePointModel].
extension PricePointModelPatterns on PricePointModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PricePointModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PricePointModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PricePointModel value)  $default,){
final _that = this;
switch (_that) {
case _PricePointModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PricePointModel value)?  $default,){
final _that = this;
switch (_that) {
case _PricePointModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double price,  double? zoneAverage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PricePointModel() when $default != null:
return $default(_that.date,_that.price,_that.zoneAverage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double price,  double? zoneAverage)  $default,) {final _that = this;
switch (_that) {
case _PricePointModel():
return $default(_that.date,_that.price,_that.zoneAverage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double price,  double? zoneAverage)?  $default,) {final _that = this;
switch (_that) {
case _PricePointModel() when $default != null:
return $default(_that.date,_that.price,_that.zoneAverage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PricePointModel extends PricePointModel {
  const _PricePointModel({required this.date, required this.price, this.zoneAverage}): super._();
  factory _PricePointModel.fromJson(Map<String, dynamic> json) => _$PricePointModelFromJson(json);

@override final  DateTime date;
@override final  double price;
@override final  double? zoneAverage;

/// Create a copy of PricePointModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PricePointModelCopyWith<_PricePointModel> get copyWith => __$PricePointModelCopyWithImpl<_PricePointModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PricePointModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PricePointModel&&(identical(other.date, date) || other.date == date)&&(identical(other.price, price) || other.price == price)&&(identical(other.zoneAverage, zoneAverage) || other.zoneAverage == zoneAverage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,price,zoneAverage);

@override
String toString() {
  return 'PricePointModel(date: $date, price: $price, zoneAverage: $zoneAverage)';
}


}

/// @nodoc
abstract mixin class _$PricePointModelCopyWith<$Res> implements $PricePointModelCopyWith<$Res> {
  factory _$PricePointModelCopyWith(_PricePointModel value, $Res Function(_PricePointModel) _then) = __$PricePointModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double price, double? zoneAverage
});




}
/// @nodoc
class __$PricePointModelCopyWithImpl<$Res>
    implements _$PricePointModelCopyWith<$Res> {
  __$PricePointModelCopyWithImpl(this._self, this._then);

  final _PricePointModel _self;
  final $Res Function(_PricePointModel) _then;

/// Create a copy of PricePointModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? price = null,Object? zoneAverage = freezed,}) {
  return _then(_PricePointModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,zoneAverage: freezed == zoneAverage ? _self.zoneAverage : zoneAverage // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$PriceHistoryModel {

 String get productName; String get unit; List<PricePointModel> get points;
/// Create a copy of PriceHistoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceHistoryModelCopyWith<PriceHistoryModel> get copyWith => _$PriceHistoryModelCopyWithImpl<PriceHistoryModel>(this as PriceHistoryModel, _$identity);

  /// Serializes this PriceHistoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceHistoryModel&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unit, unit) || other.unit == unit)&&const DeepCollectionEquality().equals(other.points, points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,unit,const DeepCollectionEquality().hash(points));

@override
String toString() {
  return 'PriceHistoryModel(productName: $productName, unit: $unit, points: $points)';
}


}

/// @nodoc
abstract mixin class $PriceHistoryModelCopyWith<$Res>  {
  factory $PriceHistoryModelCopyWith(PriceHistoryModel value, $Res Function(PriceHistoryModel) _then) = _$PriceHistoryModelCopyWithImpl;
@useResult
$Res call({
 String productName, String unit, List<PricePointModel> points
});




}
/// @nodoc
class _$PriceHistoryModelCopyWithImpl<$Res>
    implements $PriceHistoryModelCopyWith<$Res> {
  _$PriceHistoryModelCopyWithImpl(this._self, this._then);

  final PriceHistoryModel _self;
  final $Res Function(PriceHistoryModel) _then;

/// Create a copy of PriceHistoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productName = null,Object? unit = null,Object? points = null,}) {
  return _then(_self.copyWith(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<PricePointModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceHistoryModel].
extension PriceHistoryModelPatterns on PriceHistoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceHistoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceHistoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceHistoryModel value)  $default,){
final _that = this;
switch (_that) {
case _PriceHistoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceHistoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _PriceHistoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productName,  String unit,  List<PricePointModel> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceHistoryModel() when $default != null:
return $default(_that.productName,_that.unit,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productName,  String unit,  List<PricePointModel> points)  $default,) {final _that = this;
switch (_that) {
case _PriceHistoryModel():
return $default(_that.productName,_that.unit,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productName,  String unit,  List<PricePointModel> points)?  $default,) {final _that = this;
switch (_that) {
case _PriceHistoryModel() when $default != null:
return $default(_that.productName,_that.unit,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceHistoryModel extends PriceHistoryModel {
  const _PriceHistoryModel({required this.productName, required this.unit, required final  List<PricePointModel> points}): _points = points,super._();
  factory _PriceHistoryModel.fromJson(Map<String, dynamic> json) => _$PriceHistoryModelFromJson(json);

@override final  String productName;
@override final  String unit;
 final  List<PricePointModel> _points;
@override List<PricePointModel> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of PriceHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceHistoryModelCopyWith<_PriceHistoryModel> get copyWith => __$PriceHistoryModelCopyWithImpl<_PriceHistoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceHistoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceHistoryModel&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unit, unit) || other.unit == unit)&&const DeepCollectionEquality().equals(other._points, _points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,unit,const DeepCollectionEquality().hash(_points));

@override
String toString() {
  return 'PriceHistoryModel(productName: $productName, unit: $unit, points: $points)';
}


}

/// @nodoc
abstract mixin class _$PriceHistoryModelCopyWith<$Res> implements $PriceHistoryModelCopyWith<$Res> {
  factory _$PriceHistoryModelCopyWith(_PriceHistoryModel value, $Res Function(_PriceHistoryModel) _then) = __$PriceHistoryModelCopyWithImpl;
@override @useResult
$Res call({
 String productName, String unit, List<PricePointModel> points
});




}
/// @nodoc
class __$PriceHistoryModelCopyWithImpl<$Res>
    implements _$PriceHistoryModelCopyWith<$Res> {
  __$PriceHistoryModelCopyWithImpl(this._self, this._then);

  final _PriceHistoryModel _self;
  final $Res Function(_PriceHistoryModel) _then;

/// Create a copy of PriceHistoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productName = null,Object? unit = null,Object? points = null,}) {
  return _then(_PriceHistoryModel(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<PricePointModel>,
  ));
}


}

// dart format on
