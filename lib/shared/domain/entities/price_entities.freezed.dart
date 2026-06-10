// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PriceIndex {

 String get productName; String get unit; double get averagePrice; double get minPrice; double get maxPrice; int get reportCount;/// Cambio porcentual vs. ayer (puede ser negativo).
 double get changeVsYesterday; String get zone;
/// Create a copy of PriceIndex
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceIndexCopyWith<PriceIndex> get copyWith => _$PriceIndexCopyWithImpl<PriceIndex>(this as PriceIndex, _$identity);

  /// Serializes this PriceIndex to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceIndex&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.averagePrice, averagePrice) || other.averagePrice == averagePrice)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.reportCount, reportCount) || other.reportCount == reportCount)&&(identical(other.changeVsYesterday, changeVsYesterday) || other.changeVsYesterday == changeVsYesterday)&&(identical(other.zone, zone) || other.zone == zone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,unit,averagePrice,minPrice,maxPrice,reportCount,changeVsYesterday,zone);

@override
String toString() {
  return 'PriceIndex(productName: $productName, unit: $unit, averagePrice: $averagePrice, minPrice: $minPrice, maxPrice: $maxPrice, reportCount: $reportCount, changeVsYesterday: $changeVsYesterday, zone: $zone)';
}


}

/// @nodoc
abstract mixin class $PriceIndexCopyWith<$Res>  {
  factory $PriceIndexCopyWith(PriceIndex value, $Res Function(PriceIndex) _then) = _$PriceIndexCopyWithImpl;
@useResult
$Res call({
 String productName, String unit, double averagePrice, double minPrice, double maxPrice, int reportCount, double changeVsYesterday, String zone
});




}
/// @nodoc
class _$PriceIndexCopyWithImpl<$Res>
    implements $PriceIndexCopyWith<$Res> {
  _$PriceIndexCopyWithImpl(this._self, this._then);

  final PriceIndex _self;
  final $Res Function(PriceIndex) _then;

/// Create a copy of PriceIndex
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


/// Adds pattern-matching-related methods to [PriceIndex].
extension PriceIndexPatterns on PriceIndex {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceIndex value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceIndex() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceIndex value)  $default,){
final _that = this;
switch (_that) {
case _PriceIndex():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceIndex value)?  $default,){
final _that = this;
switch (_that) {
case _PriceIndex() when $default != null:
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
case _PriceIndex() when $default != null:
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
case _PriceIndex():
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
case _PriceIndex() when $default != null:
return $default(_that.productName,_that.unit,_that.averagePrice,_that.minPrice,_that.maxPrice,_that.reportCount,_that.changeVsYesterday,_that.zone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceIndex implements PriceIndex {
  const _PriceIndex({required this.productName, required this.unit, required this.averagePrice, required this.minPrice, required this.maxPrice, required this.reportCount, required this.changeVsYesterday, required this.zone});
  factory _PriceIndex.fromJson(Map<String, dynamic> json) => _$PriceIndexFromJson(json);

@override final  String productName;
@override final  String unit;
@override final  double averagePrice;
@override final  double minPrice;
@override final  double maxPrice;
@override final  int reportCount;
/// Cambio porcentual vs. ayer (puede ser negativo).
@override final  double changeVsYesterday;
@override final  String zone;

/// Create a copy of PriceIndex
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceIndexCopyWith<_PriceIndex> get copyWith => __$PriceIndexCopyWithImpl<_PriceIndex>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceIndexToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceIndex&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.averagePrice, averagePrice) || other.averagePrice == averagePrice)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.reportCount, reportCount) || other.reportCount == reportCount)&&(identical(other.changeVsYesterday, changeVsYesterday) || other.changeVsYesterday == changeVsYesterday)&&(identical(other.zone, zone) || other.zone == zone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,unit,averagePrice,minPrice,maxPrice,reportCount,changeVsYesterday,zone);

@override
String toString() {
  return 'PriceIndex(productName: $productName, unit: $unit, averagePrice: $averagePrice, minPrice: $minPrice, maxPrice: $maxPrice, reportCount: $reportCount, changeVsYesterday: $changeVsYesterday, zone: $zone)';
}


}

/// @nodoc
abstract mixin class _$PriceIndexCopyWith<$Res> implements $PriceIndexCopyWith<$Res> {
  factory _$PriceIndexCopyWith(_PriceIndex value, $Res Function(_PriceIndex) _then) = __$PriceIndexCopyWithImpl;
@override @useResult
$Res call({
 String productName, String unit, double averagePrice, double minPrice, double maxPrice, int reportCount, double changeVsYesterday, String zone
});




}
/// @nodoc
class __$PriceIndexCopyWithImpl<$Res>
    implements _$PriceIndexCopyWith<$Res> {
  __$PriceIndexCopyWithImpl(this._self, this._then);

  final _PriceIndex _self;
  final $Res Function(_PriceIndex) _then;

/// Create a copy of PriceIndex
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productName = null,Object? unit = null,Object? averagePrice = null,Object? minPrice = null,Object? maxPrice = null,Object? reportCount = null,Object? changeVsYesterday = null,Object? zone = null,}) {
  return _then(_PriceIndex(
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


/// @nodoc
mixin _$PricePoint {

 DateTime get date; double get price; double? get zoneAverage;
/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PricePointCopyWith<PricePoint> get copyWith => _$PricePointCopyWithImpl<PricePoint>(this as PricePoint, _$identity);

  /// Serializes this PricePoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PricePoint&&(identical(other.date, date) || other.date == date)&&(identical(other.price, price) || other.price == price)&&(identical(other.zoneAverage, zoneAverage) || other.zoneAverage == zoneAverage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,price,zoneAverage);

@override
String toString() {
  return 'PricePoint(date: $date, price: $price, zoneAverage: $zoneAverage)';
}


}

/// @nodoc
abstract mixin class $PricePointCopyWith<$Res>  {
  factory $PricePointCopyWith(PricePoint value, $Res Function(PricePoint) _then) = _$PricePointCopyWithImpl;
@useResult
$Res call({
 DateTime date, double price, double? zoneAverage
});




}
/// @nodoc
class _$PricePointCopyWithImpl<$Res>
    implements $PricePointCopyWith<$Res> {
  _$PricePointCopyWithImpl(this._self, this._then);

  final PricePoint _self;
  final $Res Function(PricePoint) _then;

/// Create a copy of PricePoint
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


/// Adds pattern-matching-related methods to [PricePoint].
extension PricePointPatterns on PricePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PricePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PricePoint value)  $default,){
final _that = this;
switch (_that) {
case _PricePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PricePoint value)?  $default,){
final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
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
case _PricePoint() when $default != null:
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
case _PricePoint():
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
case _PricePoint() when $default != null:
return $default(_that.date,_that.price,_that.zoneAverage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PricePoint implements PricePoint {
  const _PricePoint({required this.date, required this.price, this.zoneAverage});
  factory _PricePoint.fromJson(Map<String, dynamic> json) => _$PricePointFromJson(json);

@override final  DateTime date;
@override final  double price;
@override final  double? zoneAverage;

/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PricePointCopyWith<_PricePoint> get copyWith => __$PricePointCopyWithImpl<_PricePoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PricePointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PricePoint&&(identical(other.date, date) || other.date == date)&&(identical(other.price, price) || other.price == price)&&(identical(other.zoneAverage, zoneAverage) || other.zoneAverage == zoneAverage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,price,zoneAverage);

@override
String toString() {
  return 'PricePoint(date: $date, price: $price, zoneAverage: $zoneAverage)';
}


}

/// @nodoc
abstract mixin class _$PricePointCopyWith<$Res> implements $PricePointCopyWith<$Res> {
  factory _$PricePointCopyWith(_PricePoint value, $Res Function(_PricePoint) _then) = __$PricePointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double price, double? zoneAverage
});




}
/// @nodoc
class __$PricePointCopyWithImpl<$Res>
    implements _$PricePointCopyWith<$Res> {
  __$PricePointCopyWithImpl(this._self, this._then);

  final _PricePoint _self;
  final $Res Function(_PricePoint) _then;

/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? price = null,Object? zoneAverage = freezed,}) {
  return _then(_PricePoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,zoneAverage: freezed == zoneAverage ? _self.zoneAverage : zoneAverage // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$PriceHistory {

 String get productName; String get unit; List<PricePoint> get points;
/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceHistoryCopyWith<PriceHistory> get copyWith => _$PriceHistoryCopyWithImpl<PriceHistory>(this as PriceHistory, _$identity);

  /// Serializes this PriceHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceHistory&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unit, unit) || other.unit == unit)&&const DeepCollectionEquality().equals(other.points, points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,unit,const DeepCollectionEquality().hash(points));

@override
String toString() {
  return 'PriceHistory(productName: $productName, unit: $unit, points: $points)';
}


}

/// @nodoc
abstract mixin class $PriceHistoryCopyWith<$Res>  {
  factory $PriceHistoryCopyWith(PriceHistory value, $Res Function(PriceHistory) _then) = _$PriceHistoryCopyWithImpl;
@useResult
$Res call({
 String productName, String unit, List<PricePoint> points
});




}
/// @nodoc
class _$PriceHistoryCopyWithImpl<$Res>
    implements $PriceHistoryCopyWith<$Res> {
  _$PriceHistoryCopyWithImpl(this._self, this._then);

  final PriceHistory _self;
  final $Res Function(PriceHistory) _then;

/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productName = null,Object? unit = null,Object? points = null,}) {
  return _then(_self.copyWith(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceHistory].
extension PriceHistoryPatterns on PriceHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceHistory value)  $default,){
final _that = this;
switch (_that) {
case _PriceHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceHistory value)?  $default,){
final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productName,  String unit,  List<PricePoint> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productName,  String unit,  List<PricePoint> points)  $default,) {final _that = this;
switch (_that) {
case _PriceHistory():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productName,  String unit,  List<PricePoint> points)?  $default,) {final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
return $default(_that.productName,_that.unit,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceHistory implements PriceHistory {
  const _PriceHistory({required this.productName, required this.unit, required final  List<PricePoint> points}): _points = points;
  factory _PriceHistory.fromJson(Map<String, dynamic> json) => _$PriceHistoryFromJson(json);

@override final  String productName;
@override final  String unit;
 final  List<PricePoint> _points;
@override List<PricePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceHistoryCopyWith<_PriceHistory> get copyWith => __$PriceHistoryCopyWithImpl<_PriceHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceHistory&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.unit, unit) || other.unit == unit)&&const DeepCollectionEquality().equals(other._points, _points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,unit,const DeepCollectionEquality().hash(_points));

@override
String toString() {
  return 'PriceHistory(productName: $productName, unit: $unit, points: $points)';
}


}

/// @nodoc
abstract mixin class _$PriceHistoryCopyWith<$Res> implements $PriceHistoryCopyWith<$Res> {
  factory _$PriceHistoryCopyWith(_PriceHistory value, $Res Function(_PriceHistory) _then) = __$PriceHistoryCopyWithImpl;
@override @useResult
$Res call({
 String productName, String unit, List<PricePoint> points
});




}
/// @nodoc
class __$PriceHistoryCopyWithImpl<$Res>
    implements _$PriceHistoryCopyWith<$Res> {
  __$PriceHistoryCopyWithImpl(this._self, this._then);

  final _PriceHistory _self;
  final $Res Function(_PriceHistory) _then;

/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productName = null,Object? unit = null,Object? points = null,}) {
  return _then(_PriceHistory(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,
  ));
}


}


/// @nodoc
mixin _$PriceAlert {

 String get id; String get productName; double get targetPrice; bool get isActive; DateTime get createdAt;
/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceAlertCopyWith<PriceAlert> get copyWith => _$PriceAlertCopyWithImpl<PriceAlert>(this as PriceAlert, _$identity);

  /// Serializes this PriceAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.targetPrice, targetPrice) || other.targetPrice == targetPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,targetPrice,isActive,createdAt);

@override
String toString() {
  return 'PriceAlert(id: $id, productName: $productName, targetPrice: $targetPrice, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PriceAlertCopyWith<$Res>  {
  factory $PriceAlertCopyWith(PriceAlert value, $Res Function(PriceAlert) _then) = _$PriceAlertCopyWithImpl;
@useResult
$Res call({
 String id, String productName, double targetPrice, bool isActive, DateTime createdAt
});




}
/// @nodoc
class _$PriceAlertCopyWithImpl<$Res>
    implements $PriceAlertCopyWith<$Res> {
  _$PriceAlertCopyWithImpl(this._self, this._then);

  final PriceAlert _self;
  final $Res Function(PriceAlert) _then;

/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productName = null,Object? targetPrice = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,targetPrice: null == targetPrice ? _self.targetPrice : targetPrice // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceAlert].
extension PriceAlertPatterns on PriceAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceAlert value)  $default,){
final _that = this;
switch (_that) {
case _PriceAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceAlert value)?  $default,){
final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productName,  double targetPrice,  bool isActive,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
return $default(_that.id,_that.productName,_that.targetPrice,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productName,  double targetPrice,  bool isActive,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PriceAlert():
return $default(_that.id,_that.productName,_that.targetPrice,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productName,  double targetPrice,  bool isActive,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PriceAlert() when $default != null:
return $default(_that.id,_that.productName,_that.targetPrice,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceAlert implements PriceAlert {
  const _PriceAlert({required this.id, required this.productName, required this.targetPrice, required this.isActive, required this.createdAt});
  factory _PriceAlert.fromJson(Map<String, dynamic> json) => _$PriceAlertFromJson(json);

@override final  String id;
@override final  String productName;
@override final  double targetPrice;
@override final  bool isActive;
@override final  DateTime createdAt;

/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceAlertCopyWith<_PriceAlert> get copyWith => __$PriceAlertCopyWithImpl<_PriceAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.targetPrice, targetPrice) || other.targetPrice == targetPrice)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productName,targetPrice,isActive,createdAt);

@override
String toString() {
  return 'PriceAlert(id: $id, productName: $productName, targetPrice: $targetPrice, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PriceAlertCopyWith<$Res> implements $PriceAlertCopyWith<$Res> {
  factory _$PriceAlertCopyWith(_PriceAlert value, $Res Function(_PriceAlert) _then) = __$PriceAlertCopyWithImpl;
@override @useResult
$Res call({
 String id, String productName, double targetPrice, bool isActive, DateTime createdAt
});




}
/// @nodoc
class __$PriceAlertCopyWithImpl<$Res>
    implements _$PriceAlertCopyWith<$Res> {
  __$PriceAlertCopyWithImpl(this._self, this._then);

  final _PriceAlert _self;
  final $Res Function(_PriceAlert) _then;

/// Create a copy of PriceAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productName = null,Object? targetPrice = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_PriceAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,targetPrice: null == targetPrice ? _self.targetPrice : targetPrice // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
