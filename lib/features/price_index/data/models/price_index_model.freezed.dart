// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_index_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PriceIndexModel {

 String get productName; String get unit; double get averagePrice; double get minPrice; double get maxPrice; int get reportCount; double get changeVsYesterday; String get zone;
/// Create a copy of PriceIndexModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceIndexModelCopyWith<PriceIndexModel> get copyWith => _$PriceIndexModelCopyWithImpl<PriceIndexModel>(this as PriceIndexModel, _$identity);

  /// Serializes this PriceIndexModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceIndexModel&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.averagePrice, averagePrice) || other.averagePrice == averagePrice)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.reportCount, reportCount) || other.reportCount == reportCount)&&(identical(other.changeVsYesterday, changeVsYesterday) || other.changeVsYesterday == changeVsYesterday)&&(identical(other.zone, zone) || other.zone == zone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,unit,averagePrice,minPrice,maxPrice,reportCount,changeVsYesterday,zone);

@override
String toString() {
  return 'PriceIndexModel(productName: $productName, unit: $unit, averagePrice: $averagePrice, minPrice: $minPrice, maxPrice: $maxPrice, reportCount: $reportCount, changeVsYesterday: $changeVsYesterday, zone: $zone)';
}


}

/// @nodoc
abstract mixin class $PriceIndexModelCopyWith<$Res>  {
  factory $PriceIndexModelCopyWith(PriceIndexModel value, $Res Function(PriceIndexModel) _then) = _$PriceIndexModelCopyWithImpl;
@useResult
$Res call({
 String productName, String unit, double averagePrice, double minPrice, double maxPrice, int reportCount, double changeVsYesterday, String zone
});




}
/// @nodoc
class _$PriceIndexModelCopyWithImpl<$Res>
    implements $PriceIndexModelCopyWith<$Res> {
  _$PriceIndexModelCopyWithImpl(this._self, this._then);

  final PriceIndexModel _self;
  final $Res Function(PriceIndexModel) _then;

/// Create a copy of PriceIndexModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productName = null,Object? unit = null,Object? averagePrice = null,Object? minPrice = null,Object? maxPrice = null,Object? reportCount = null,Object? changeVsYesterday = null,Object? zone = null,}) {
  return _then(_self.copyWith(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,averagePrice: null == averagePrice ? _self.averagePrice : averagePrice // ignore: cast_nullable_to_non_nullable
as double,minPrice: null == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as double,maxPrice: null == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double,reportCount: null == reportCount ? _self.reportCount : reportCount // ignore: cast_nullable_to_non_nullable
as int,changeVsYesterday: null == changeVsYesterday ? _self.changeVsYesterday : changeVsYesterday // ignore: cast_nullable_to_non_nullable
as double,zone: null == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceIndexModel].
extension PriceIndexModelPatterns on PriceIndexModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceIndexModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceIndexModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceIndexModel value)  $default,){
final _that = this;
switch (_that) {
case _PriceIndexModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceIndexModel value)?  $default,){
final _that = this;
switch (_that) {
case _PriceIndexModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productName,  String unit,  double averagePrice,  double minPrice,  double maxPrice,  int reportCount,  double changeVsYesterday,  String zone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceIndexModel() when $default != null:
return $default(_that.productName,_that.unit,_that.averagePrice,_that.minPrice,_that.maxPrice,_that.reportCount,_that.changeVsYesterday,_that.zone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productName,  String unit,  double averagePrice,  double minPrice,  double maxPrice,  int reportCount,  double changeVsYesterday,  String zone)  $default,) {final _that = this;
switch (_that) {
case _PriceIndexModel():
return $default(_that.productName,_that.unit,_that.averagePrice,_that.minPrice,_that.maxPrice,_that.reportCount,_that.changeVsYesterday,_that.zone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productName,  String unit,  double averagePrice,  double minPrice,  double maxPrice,  int reportCount,  double changeVsYesterday,  String zone)?  $default,) {final _that = this;
switch (_that) {
case _PriceIndexModel() when $default != null:
return $default(_that.productName,_that.unit,_that.averagePrice,_that.minPrice,_that.maxPrice,_that.reportCount,_that.changeVsYesterday,_that.zone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceIndexModel extends PriceIndexModel {
  const _PriceIndexModel({required this.productName, required this.unit, required this.averagePrice, required this.minPrice, required this.maxPrice, required this.reportCount, required this.changeVsYesterday, required this.zone}): super._();
  factory _PriceIndexModel.fromJson(Map<String, dynamic> json) => _$PriceIndexModelFromJson(json);

@override final  String productName;
@override final  String unit;
@override final  double averagePrice;
@override final  double minPrice;
@override final  double maxPrice;
@override final  int reportCount;
@override final  double changeVsYesterday;
@override final  String zone;

/// Create a copy of PriceIndexModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceIndexModelCopyWith<_PriceIndexModel> get copyWith => __$PriceIndexModelCopyWithImpl<_PriceIndexModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceIndexModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceIndexModel&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.averagePrice, averagePrice) || other.averagePrice == averagePrice)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.reportCount, reportCount) || other.reportCount == reportCount)&&(identical(other.changeVsYesterday, changeVsYesterday) || other.changeVsYesterday == changeVsYesterday)&&(identical(other.zone, zone) || other.zone == zone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,unit,averagePrice,minPrice,maxPrice,reportCount,changeVsYesterday,zone);

@override
String toString() {
  return 'PriceIndexModel(productName: $productName, unit: $unit, averagePrice: $averagePrice, minPrice: $minPrice, maxPrice: $maxPrice, reportCount: $reportCount, changeVsYesterday: $changeVsYesterday, zone: $zone)';
}


}

/// @nodoc
abstract mixin class _$PriceIndexModelCopyWith<$Res> implements $PriceIndexModelCopyWith<$Res> {
  factory _$PriceIndexModelCopyWith(_PriceIndexModel value, $Res Function(_PriceIndexModel) _then) = __$PriceIndexModelCopyWithImpl;
@override @useResult
$Res call({
 String productName, String unit, double averagePrice, double minPrice, double maxPrice, int reportCount, double changeVsYesterday, String zone
});




}
/// @nodoc
class __$PriceIndexModelCopyWithImpl<$Res>
    implements _$PriceIndexModelCopyWith<$Res> {
  __$PriceIndexModelCopyWithImpl(this._self, this._then);

  final _PriceIndexModel _self;
  final $Res Function(_PriceIndexModel) _then;

/// Create a copy of PriceIndexModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productName = null,Object? unit = null,Object? averagePrice = null,Object? minPrice = null,Object? maxPrice = null,Object? reportCount = null,Object? changeVsYesterday = null,Object? zone = null,}) {
  return _then(_PriceIndexModel(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,averagePrice: null == averagePrice ? _self.averagePrice : averagePrice // ignore: cast_nullable_to_non_nullable
as double,minPrice: null == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as double,maxPrice: null == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double,reportCount: null == reportCount ? _self.reportCount : reportCount // ignore: cast_nullable_to_non_nullable
as int,changeVsYesterday: null == changeVsYesterday ? _self.changeVsYesterday : changeVsYesterday // ignore: cast_nullable_to_non_nullable
as double,zone: null == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
