// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyViewsModel {

 DateTime get date; int get views;
/// Create a copy of DailyViewsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyViewsModelCopyWith<DailyViewsModel> get copyWith => _$DailyViewsModelCopyWithImpl<DailyViewsModel>(this as DailyViewsModel, _$identity);

  /// Serializes this DailyViewsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyViewsModel&&(identical(other.date, date) || other.date == date)&&(identical(other.views, views) || other.views == views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,views);

@override
String toString() {
  return 'DailyViewsModel(date: $date, views: $views)';
}


}

/// @nodoc
abstract mixin class $DailyViewsModelCopyWith<$Res>  {
  factory $DailyViewsModelCopyWith(DailyViewsModel value, $Res Function(DailyViewsModel) _then) = _$DailyViewsModelCopyWithImpl;
@useResult
$Res call({
 DateTime date, int views
});




}
/// @nodoc
class _$DailyViewsModelCopyWithImpl<$Res>
    implements $DailyViewsModelCopyWith<$Res> {
  _$DailyViewsModelCopyWithImpl(this._self, this._then);

  final DailyViewsModel _self;
  final $Res Function(DailyViewsModel) _then;

/// Create a copy of DailyViewsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? views = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyViewsModel].
extension DailyViewsModelPatterns on DailyViewsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyViewsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyViewsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyViewsModel value)  $default,){
final _that = this;
switch (_that) {
case _DailyViewsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyViewsModel value)?  $default,){
final _that = this;
switch (_that) {
case _DailyViewsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int views)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyViewsModel() when $default != null:
return $default(_that.date,_that.views);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int views)  $default,) {final _that = this;
switch (_that) {
case _DailyViewsModel():
return $default(_that.date,_that.views);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int views)?  $default,) {final _that = this;
switch (_that) {
case _DailyViewsModel() when $default != null:
return $default(_that.date,_that.views);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyViewsModel extends DailyViewsModel {
  const _DailyViewsModel({required this.date, required this.views}): super._();
  factory _DailyViewsModel.fromJson(Map<String, dynamic> json) => _$DailyViewsModelFromJson(json);

@override final  DateTime date;
@override final  int views;

/// Create a copy of DailyViewsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyViewsModelCopyWith<_DailyViewsModel> get copyWith => __$DailyViewsModelCopyWithImpl<_DailyViewsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyViewsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyViewsModel&&(identical(other.date, date) || other.date == date)&&(identical(other.views, views) || other.views == views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,views);

@override
String toString() {
  return 'DailyViewsModel(date: $date, views: $views)';
}


}

/// @nodoc
abstract mixin class _$DailyViewsModelCopyWith<$Res> implements $DailyViewsModelCopyWith<$Res> {
  factory _$DailyViewsModelCopyWith(_DailyViewsModel value, $Res Function(_DailyViewsModel) _then) = __$DailyViewsModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int views
});




}
/// @nodoc
class __$DailyViewsModelCopyWithImpl<$Res>
    implements _$DailyViewsModelCopyWith<$Res> {
  __$DailyViewsModelCopyWithImpl(this._self, this._then);

  final _DailyViewsModel _self;
  final $Res Function(_DailyViewsModel) _then;

/// Create a copy of DailyViewsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? views = null,}) {
  return _then(_DailyViewsModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$VendorStatsModel {

 int get totalViews; int get totalClicks; int get activeProducts; int get soldOutProducts; List<DailyViewsModel> get viewsByDay; List<ProductModel> get topProducts; double get averageRating;
/// Create a copy of VendorStatsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorStatsModelCopyWith<VendorStatsModel> get copyWith => _$VendorStatsModelCopyWithImpl<VendorStatsModel>(this as VendorStatsModel, _$identity);

  /// Serializes this VendorStatsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorStatsModel&&(identical(other.totalViews, totalViews) || other.totalViews == totalViews)&&(identical(other.totalClicks, totalClicks) || other.totalClicks == totalClicks)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.soldOutProducts, soldOutProducts) || other.soldOutProducts == soldOutProducts)&&const DeepCollectionEquality().equals(other.viewsByDay, viewsByDay)&&const DeepCollectionEquality().equals(other.topProducts, topProducts)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalViews,totalClicks,activeProducts,soldOutProducts,const DeepCollectionEquality().hash(viewsByDay),const DeepCollectionEquality().hash(topProducts),averageRating);

@override
String toString() {
  return 'VendorStatsModel(totalViews: $totalViews, totalClicks: $totalClicks, activeProducts: $activeProducts, soldOutProducts: $soldOutProducts, viewsByDay: $viewsByDay, topProducts: $topProducts, averageRating: $averageRating)';
}


}

/// @nodoc
abstract mixin class $VendorStatsModelCopyWith<$Res>  {
  factory $VendorStatsModelCopyWith(VendorStatsModel value, $Res Function(VendorStatsModel) _then) = _$VendorStatsModelCopyWithImpl;
@useResult
$Res call({
 int totalViews, int totalClicks, int activeProducts, int soldOutProducts, List<DailyViewsModel> viewsByDay, List<ProductModel> topProducts, double averageRating
});




}
/// @nodoc
class _$VendorStatsModelCopyWithImpl<$Res>
    implements $VendorStatsModelCopyWith<$Res> {
  _$VendorStatsModelCopyWithImpl(this._self, this._then);

  final VendorStatsModel _self;
  final $Res Function(VendorStatsModel) _then;

/// Create a copy of VendorStatsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalViews = null,Object? totalClicks = null,Object? activeProducts = null,Object? soldOutProducts = null,Object? viewsByDay = null,Object? topProducts = null,Object? averageRating = null,}) {
  return _then(_self.copyWith(
totalViews: null == totalViews ? _self.totalViews : totalViews // ignore: cast_nullable_to_non_nullable
as int,totalClicks: null == totalClicks ? _self.totalClicks : totalClicks // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,soldOutProducts: null == soldOutProducts ? _self.soldOutProducts : soldOutProducts // ignore: cast_nullable_to_non_nullable
as int,viewsByDay: null == viewsByDay ? _self.viewsByDay : viewsByDay // ignore: cast_nullable_to_non_nullable
as List<DailyViewsModel>,topProducts: null == topProducts ? _self.topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<ProductModel>,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [VendorStatsModel].
extension VendorStatsModelPatterns on VendorStatsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorStatsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorStatsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorStatsModel value)  $default,){
final _that = this;
switch (_that) {
case _VendorStatsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorStatsModel value)?  $default,){
final _that = this;
switch (_that) {
case _VendorStatsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalViews,  int totalClicks,  int activeProducts,  int soldOutProducts,  List<DailyViewsModel> viewsByDay,  List<ProductModel> topProducts,  double averageRating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorStatsModel() when $default != null:
return $default(_that.totalViews,_that.totalClicks,_that.activeProducts,_that.soldOutProducts,_that.viewsByDay,_that.topProducts,_that.averageRating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalViews,  int totalClicks,  int activeProducts,  int soldOutProducts,  List<DailyViewsModel> viewsByDay,  List<ProductModel> topProducts,  double averageRating)  $default,) {final _that = this;
switch (_that) {
case _VendorStatsModel():
return $default(_that.totalViews,_that.totalClicks,_that.activeProducts,_that.soldOutProducts,_that.viewsByDay,_that.topProducts,_that.averageRating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalViews,  int totalClicks,  int activeProducts,  int soldOutProducts,  List<DailyViewsModel> viewsByDay,  List<ProductModel> topProducts,  double averageRating)?  $default,) {final _that = this;
switch (_that) {
case _VendorStatsModel() when $default != null:
return $default(_that.totalViews,_that.totalClicks,_that.activeProducts,_that.soldOutProducts,_that.viewsByDay,_that.topProducts,_that.averageRating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorStatsModel extends VendorStatsModel {
  const _VendorStatsModel({required this.totalViews, required this.totalClicks, required this.activeProducts, required this.soldOutProducts, required final  List<DailyViewsModel> viewsByDay, required final  List<ProductModel> topProducts, required this.averageRating}): _viewsByDay = viewsByDay,_topProducts = topProducts,super._();
  factory _VendorStatsModel.fromJson(Map<String, dynamic> json) => _$VendorStatsModelFromJson(json);

@override final  int totalViews;
@override final  int totalClicks;
@override final  int activeProducts;
@override final  int soldOutProducts;
 final  List<DailyViewsModel> _viewsByDay;
@override List<DailyViewsModel> get viewsByDay {
  if (_viewsByDay is EqualUnmodifiableListView) return _viewsByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_viewsByDay);
}

 final  List<ProductModel> _topProducts;
@override List<ProductModel> get topProducts {
  if (_topProducts is EqualUnmodifiableListView) return _topProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topProducts);
}

@override final  double averageRating;

/// Create a copy of VendorStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorStatsModelCopyWith<_VendorStatsModel> get copyWith => __$VendorStatsModelCopyWithImpl<_VendorStatsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorStatsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorStatsModel&&(identical(other.totalViews, totalViews) || other.totalViews == totalViews)&&(identical(other.totalClicks, totalClicks) || other.totalClicks == totalClicks)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.soldOutProducts, soldOutProducts) || other.soldOutProducts == soldOutProducts)&&const DeepCollectionEquality().equals(other._viewsByDay, _viewsByDay)&&const DeepCollectionEquality().equals(other._topProducts, _topProducts)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalViews,totalClicks,activeProducts,soldOutProducts,const DeepCollectionEquality().hash(_viewsByDay),const DeepCollectionEquality().hash(_topProducts),averageRating);

@override
String toString() {
  return 'VendorStatsModel(totalViews: $totalViews, totalClicks: $totalClicks, activeProducts: $activeProducts, soldOutProducts: $soldOutProducts, viewsByDay: $viewsByDay, topProducts: $topProducts, averageRating: $averageRating)';
}


}

/// @nodoc
abstract mixin class _$VendorStatsModelCopyWith<$Res> implements $VendorStatsModelCopyWith<$Res> {
  factory _$VendorStatsModelCopyWith(_VendorStatsModel value, $Res Function(_VendorStatsModel) _then) = __$VendorStatsModelCopyWithImpl;
@override @useResult
$Res call({
 int totalViews, int totalClicks, int activeProducts, int soldOutProducts, List<DailyViewsModel> viewsByDay, List<ProductModel> topProducts, double averageRating
});




}
/// @nodoc
class __$VendorStatsModelCopyWithImpl<$Res>
    implements _$VendorStatsModelCopyWith<$Res> {
  __$VendorStatsModelCopyWithImpl(this._self, this._then);

  final _VendorStatsModel _self;
  final $Res Function(_VendorStatsModel) _then;

/// Create a copy of VendorStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalViews = null,Object? totalClicks = null,Object? activeProducts = null,Object? soldOutProducts = null,Object? viewsByDay = null,Object? topProducts = null,Object? averageRating = null,}) {
  return _then(_VendorStatsModel(
totalViews: null == totalViews ? _self.totalViews : totalViews // ignore: cast_nullable_to_non_nullable
as int,totalClicks: null == totalClicks ? _self.totalClicks : totalClicks // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,soldOutProducts: null == soldOutProducts ? _self.soldOutProducts : soldOutProducts // ignore: cast_nullable_to_non_nullable
as int,viewsByDay: null == viewsByDay ? _self._viewsByDay : viewsByDay // ignore: cast_nullable_to_non_nullable
as List<DailyViewsModel>,topProducts: null == topProducts ? _self._topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<ProductModel>,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
