// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_stats_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyViewsEntity {

 DateTime get date; int get views;
/// Create a copy of DailyViewsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyViewsEntityCopyWith<DailyViewsEntity> get copyWith => _$DailyViewsEntityCopyWithImpl<DailyViewsEntity>(this as DailyViewsEntity, _$identity);

  /// Serializes this DailyViewsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyViewsEntity&&(identical(other.date, date) || other.date == date)&&(identical(other.views, views) || other.views == views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,views);

@override
String toString() {
  return 'DailyViewsEntity(date: $date, views: $views)';
}


}

/// @nodoc
abstract mixin class $DailyViewsEntityCopyWith<$Res>  {
  factory $DailyViewsEntityCopyWith(DailyViewsEntity value, $Res Function(DailyViewsEntity) _then) = _$DailyViewsEntityCopyWithImpl;
@useResult
$Res call({
 DateTime date, int views
});




}
/// @nodoc
class _$DailyViewsEntityCopyWithImpl<$Res>
    implements $DailyViewsEntityCopyWith<$Res> {
  _$DailyViewsEntityCopyWithImpl(this._self, this._then);

  final DailyViewsEntity _self;
  final $Res Function(DailyViewsEntity) _then;

/// Create a copy of DailyViewsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? views = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyViewsEntity].
extension DailyViewsEntityPatterns on DailyViewsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyViewsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyViewsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyViewsEntity value)  $default,){
final _that = this;
switch (_that) {
case _DailyViewsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyViewsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DailyViewsEntity() when $default != null:
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
case _DailyViewsEntity() when $default != null:
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
case _DailyViewsEntity():
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
case _DailyViewsEntity() when $default != null:
return $default(_that.date,_that.views);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyViewsEntity implements DailyViewsEntity {
  const _DailyViewsEntity({required this.date, required this.views});
  factory _DailyViewsEntity.fromJson(Map<String, dynamic> json) => _$DailyViewsEntityFromJson(json);

@override final  DateTime date;
@override final  int views;

/// Create a copy of DailyViewsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyViewsEntityCopyWith<_DailyViewsEntity> get copyWith => __$DailyViewsEntityCopyWithImpl<_DailyViewsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyViewsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyViewsEntity&&(identical(other.date, date) || other.date == date)&&(identical(other.views, views) || other.views == views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,views);

@override
String toString() {
  return 'DailyViewsEntity(date: $date, views: $views)';
}


}

/// @nodoc
abstract mixin class _$DailyViewsEntityCopyWith<$Res> implements $DailyViewsEntityCopyWith<$Res> {
  factory _$DailyViewsEntityCopyWith(_DailyViewsEntity value, $Res Function(_DailyViewsEntity) _then) = __$DailyViewsEntityCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int views
});




}
/// @nodoc
class __$DailyViewsEntityCopyWithImpl<$Res>
    implements _$DailyViewsEntityCopyWith<$Res> {
  __$DailyViewsEntityCopyWithImpl(this._self, this._then);

  final _DailyViewsEntity _self;
  final $Res Function(_DailyViewsEntity) _then;

/// Create a copy of DailyViewsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? views = null,}) {
  return _then(_DailyViewsEntity(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$VendorStatsEntity {

 int get totalViews; int get totalClicks; int get activeProducts; int get soldOutProducts; List<DailyViewsEntity> get viewsByDay; List<ProductEntity> get topProducts; double get averageRating;
/// Create a copy of VendorStatsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorStatsEntityCopyWith<VendorStatsEntity> get copyWith => _$VendorStatsEntityCopyWithImpl<VendorStatsEntity>(this as VendorStatsEntity, _$identity);

  /// Serializes this VendorStatsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorStatsEntity&&(identical(other.totalViews, totalViews) || other.totalViews == totalViews)&&(identical(other.totalClicks, totalClicks) || other.totalClicks == totalClicks)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.soldOutProducts, soldOutProducts) || other.soldOutProducts == soldOutProducts)&&const DeepCollectionEquality().equals(other.viewsByDay, viewsByDay)&&const DeepCollectionEquality().equals(other.topProducts, topProducts)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalViews,totalClicks,activeProducts,soldOutProducts,const DeepCollectionEquality().hash(viewsByDay),const DeepCollectionEquality().hash(topProducts),averageRating);

@override
String toString() {
  return 'VendorStatsEntity(totalViews: $totalViews, totalClicks: $totalClicks, activeProducts: $activeProducts, soldOutProducts: $soldOutProducts, viewsByDay: $viewsByDay, topProducts: $topProducts, averageRating: $averageRating)';
}


}

/// @nodoc
abstract mixin class $VendorStatsEntityCopyWith<$Res>  {
  factory $VendorStatsEntityCopyWith(VendorStatsEntity value, $Res Function(VendorStatsEntity) _then) = _$VendorStatsEntityCopyWithImpl;
@useResult
$Res call({
 int totalViews, int totalClicks, int activeProducts, int soldOutProducts, List<DailyViewsEntity> viewsByDay, List<ProductEntity> topProducts, double averageRating
});




}
/// @nodoc
class _$VendorStatsEntityCopyWithImpl<$Res>
    implements $VendorStatsEntityCopyWith<$Res> {
  _$VendorStatsEntityCopyWithImpl(this._self, this._then);

  final VendorStatsEntity _self;
  final $Res Function(VendorStatsEntity) _then;

/// Create a copy of VendorStatsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalViews = null,Object? totalClicks = null,Object? activeProducts = null,Object? soldOutProducts = null,Object? viewsByDay = null,Object? topProducts = null,Object? averageRating = null,}) {
  return _then(_self.copyWith(
totalViews: null == totalViews ? _self.totalViews : totalViews // ignore: cast_nullable_to_non_nullable
as int,totalClicks: null == totalClicks ? _self.totalClicks : totalClicks // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,soldOutProducts: null == soldOutProducts ? _self.soldOutProducts : soldOutProducts // ignore: cast_nullable_to_non_nullable
as int,viewsByDay: null == viewsByDay ? _self.viewsByDay : viewsByDay // ignore: cast_nullable_to_non_nullable
as List<DailyViewsEntity>,topProducts: null == topProducts ? _self.topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<ProductEntity>,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [VendorStatsEntity].
extension VendorStatsEntityPatterns on VendorStatsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorStatsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorStatsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorStatsEntity value)  $default,){
final _that = this;
switch (_that) {
case _VendorStatsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorStatsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _VendorStatsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalViews,  int totalClicks,  int activeProducts,  int soldOutProducts,  List<DailyViewsEntity> viewsByDay,  List<ProductEntity> topProducts,  double averageRating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorStatsEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalViews,  int totalClicks,  int activeProducts,  int soldOutProducts,  List<DailyViewsEntity> viewsByDay,  List<ProductEntity> topProducts,  double averageRating)  $default,) {final _that = this;
switch (_that) {
case _VendorStatsEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalViews,  int totalClicks,  int activeProducts,  int soldOutProducts,  List<DailyViewsEntity> viewsByDay,  List<ProductEntity> topProducts,  double averageRating)?  $default,) {final _that = this;
switch (_that) {
case _VendorStatsEntity() when $default != null:
return $default(_that.totalViews,_that.totalClicks,_that.activeProducts,_that.soldOutProducts,_that.viewsByDay,_that.topProducts,_that.averageRating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VendorStatsEntity implements VendorStatsEntity {
  const _VendorStatsEntity({required this.totalViews, required this.totalClicks, required this.activeProducts, required this.soldOutProducts, required final  List<DailyViewsEntity> viewsByDay, required final  List<ProductEntity> topProducts, required this.averageRating}): _viewsByDay = viewsByDay,_topProducts = topProducts;
  factory _VendorStatsEntity.fromJson(Map<String, dynamic> json) => _$VendorStatsEntityFromJson(json);

@override final  int totalViews;
@override final  int totalClicks;
@override final  int activeProducts;
@override final  int soldOutProducts;
 final  List<DailyViewsEntity> _viewsByDay;
@override List<DailyViewsEntity> get viewsByDay {
  if (_viewsByDay is EqualUnmodifiableListView) return _viewsByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_viewsByDay);
}

 final  List<ProductEntity> _topProducts;
@override List<ProductEntity> get topProducts {
  if (_topProducts is EqualUnmodifiableListView) return _topProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topProducts);
}

@override final  double averageRating;

/// Create a copy of VendorStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorStatsEntityCopyWith<_VendorStatsEntity> get copyWith => __$VendorStatsEntityCopyWithImpl<_VendorStatsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorStatsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorStatsEntity&&(identical(other.totalViews, totalViews) || other.totalViews == totalViews)&&(identical(other.totalClicks, totalClicks) || other.totalClicks == totalClicks)&&(identical(other.activeProducts, activeProducts) || other.activeProducts == activeProducts)&&(identical(other.soldOutProducts, soldOutProducts) || other.soldOutProducts == soldOutProducts)&&const DeepCollectionEquality().equals(other._viewsByDay, _viewsByDay)&&const DeepCollectionEquality().equals(other._topProducts, _topProducts)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalViews,totalClicks,activeProducts,soldOutProducts,const DeepCollectionEquality().hash(_viewsByDay),const DeepCollectionEquality().hash(_topProducts),averageRating);

@override
String toString() {
  return 'VendorStatsEntity(totalViews: $totalViews, totalClicks: $totalClicks, activeProducts: $activeProducts, soldOutProducts: $soldOutProducts, viewsByDay: $viewsByDay, topProducts: $topProducts, averageRating: $averageRating)';
}


}

/// @nodoc
abstract mixin class _$VendorStatsEntityCopyWith<$Res> implements $VendorStatsEntityCopyWith<$Res> {
  factory _$VendorStatsEntityCopyWith(_VendorStatsEntity value, $Res Function(_VendorStatsEntity) _then) = __$VendorStatsEntityCopyWithImpl;
@override @useResult
$Res call({
 int totalViews, int totalClicks, int activeProducts, int soldOutProducts, List<DailyViewsEntity> viewsByDay, List<ProductEntity> topProducts, double averageRating
});




}
/// @nodoc
class __$VendorStatsEntityCopyWithImpl<$Res>
    implements _$VendorStatsEntityCopyWith<$Res> {
  __$VendorStatsEntityCopyWithImpl(this._self, this._then);

  final _VendorStatsEntity _self;
  final $Res Function(_VendorStatsEntity) _then;

/// Create a copy of VendorStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalViews = null,Object? totalClicks = null,Object? activeProducts = null,Object? soldOutProducts = null,Object? viewsByDay = null,Object? topProducts = null,Object? averageRating = null,}) {
  return _then(_VendorStatsEntity(
totalViews: null == totalViews ? _self.totalViews : totalViews // ignore: cast_nullable_to_non_nullable
as int,totalClicks: null == totalClicks ? _self.totalClicks : totalClicks // ignore: cast_nullable_to_non_nullable
as int,activeProducts: null == activeProducts ? _self.activeProducts : activeProducts // ignore: cast_nullable_to_non_nullable
as int,soldOutProducts: null == soldOutProducts ? _self.soldOutProducts : soldOutProducts // ignore: cast_nullable_to_non_nullable
as int,viewsByDay: null == viewsByDay ? _self._viewsByDay : viewsByDay // ignore: cast_nullable_to_non_nullable
as List<DailyViewsEntity>,topProducts: null == topProducts ? _self._topProducts : topProducts // ignore: cast_nullable_to_non_nullable
as List<ProductEntity>,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
