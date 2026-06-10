// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchFilters {

 double get radiusKm; double? get maxPrice; double get minRating; bool get onlyAvailable; ProductCategory? get category; SortOrder get sortBy;
/// Create a copy of SearchFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchFiltersCopyWith<SearchFilters> get copyWith => _$SearchFiltersCopyWithImpl<SearchFilters>(this as SearchFilters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchFilters&&(identical(other.radiusKm, radiusKm) || other.radiusKm == radiusKm)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.minRating, minRating) || other.minRating == minRating)&&(identical(other.onlyAvailable, onlyAvailable) || other.onlyAvailable == onlyAvailable)&&(identical(other.category, category) || other.category == category)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy));
}


@override
int get hashCode => Object.hash(runtimeType,radiusKm,maxPrice,minRating,onlyAvailable,category,sortBy);

@override
String toString() {
  return 'SearchFilters(radiusKm: $radiusKm, maxPrice: $maxPrice, minRating: $minRating, onlyAvailable: $onlyAvailable, category: $category, sortBy: $sortBy)';
}


}

/// @nodoc
abstract mixin class $SearchFiltersCopyWith<$Res>  {
  factory $SearchFiltersCopyWith(SearchFilters value, $Res Function(SearchFilters) _then) = _$SearchFiltersCopyWithImpl;
@useResult
$Res call({
 double radiusKm, double? maxPrice, double minRating, bool onlyAvailable, ProductCategory? category, SortOrder sortBy
});




}
/// @nodoc
class _$SearchFiltersCopyWithImpl<$Res>
    implements $SearchFiltersCopyWith<$Res> {
  _$SearchFiltersCopyWithImpl(this._self, this._then);

  final SearchFilters _self;
  final $Res Function(SearchFilters) _then;

/// Create a copy of SearchFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? radiusKm = null,Object? maxPrice = freezed,Object? minRating = null,Object? onlyAvailable = null,Object? category = freezed,Object? sortBy = null,}) {
  return _then(_self.copyWith(
radiusKm: null == radiusKm ? _self.radiusKm : radiusKm // ignore: cast_nullable_to_non_nullable
as double,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double?,minRating: null == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as double,onlyAvailable: null == onlyAvailable ? _self.onlyAvailable : onlyAvailable // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory?,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as SortOrder,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchFilters].
extension SearchFiltersPatterns on SearchFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchFilters value)  $default,){
final _that = this;
switch (_that) {
case _SearchFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchFilters value)?  $default,){
final _that = this;
switch (_that) {
case _SearchFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double radiusKm,  double? maxPrice,  double minRating,  bool onlyAvailable,  ProductCategory? category,  SortOrder sortBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchFilters() when $default != null:
return $default(_that.radiusKm,_that.maxPrice,_that.minRating,_that.onlyAvailable,_that.category,_that.sortBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double radiusKm,  double? maxPrice,  double minRating,  bool onlyAvailable,  ProductCategory? category,  SortOrder sortBy)  $default,) {final _that = this;
switch (_that) {
case _SearchFilters():
return $default(_that.radiusKm,_that.maxPrice,_that.minRating,_that.onlyAvailable,_that.category,_that.sortBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double radiusKm,  double? maxPrice,  double minRating,  bool onlyAvailable,  ProductCategory? category,  SortOrder sortBy)?  $default,) {final _that = this;
switch (_that) {
case _SearchFilters() when $default != null:
return $default(_that.radiusKm,_that.maxPrice,_that.minRating,_that.onlyAvailable,_that.category,_that.sortBy);case _:
  return null;

}
}

}

/// @nodoc


class _SearchFilters implements SearchFilters {
  const _SearchFilters({this.radiusKm = 5.0, this.maxPrice, this.minRating = 0.0, this.onlyAvailable = true, this.category, this.sortBy = SortOrder.relevance});
  

@override@JsonKey() final  double radiusKm;
@override final  double? maxPrice;
@override@JsonKey() final  double minRating;
@override@JsonKey() final  bool onlyAvailable;
@override final  ProductCategory? category;
@override@JsonKey() final  SortOrder sortBy;

/// Create a copy of SearchFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchFiltersCopyWith<_SearchFilters> get copyWith => __$SearchFiltersCopyWithImpl<_SearchFilters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchFilters&&(identical(other.radiusKm, radiusKm) || other.radiusKm == radiusKm)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.minRating, minRating) || other.minRating == minRating)&&(identical(other.onlyAvailable, onlyAvailable) || other.onlyAvailable == onlyAvailable)&&(identical(other.category, category) || other.category == category)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy));
}


@override
int get hashCode => Object.hash(runtimeType,radiusKm,maxPrice,minRating,onlyAvailable,category,sortBy);

@override
String toString() {
  return 'SearchFilters(radiusKm: $radiusKm, maxPrice: $maxPrice, minRating: $minRating, onlyAvailable: $onlyAvailable, category: $category, sortBy: $sortBy)';
}


}

/// @nodoc
abstract mixin class _$SearchFiltersCopyWith<$Res> implements $SearchFiltersCopyWith<$Res> {
  factory _$SearchFiltersCopyWith(_SearchFilters value, $Res Function(_SearchFilters) _then) = __$SearchFiltersCopyWithImpl;
@override @useResult
$Res call({
 double radiusKm, double? maxPrice, double minRating, bool onlyAvailable, ProductCategory? category, SortOrder sortBy
});




}
/// @nodoc
class __$SearchFiltersCopyWithImpl<$Res>
    implements _$SearchFiltersCopyWith<$Res> {
  __$SearchFiltersCopyWithImpl(this._self, this._then);

  final _SearchFilters _self;
  final $Res Function(_SearchFilters) _then;

/// Create a copy of SearchFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? radiusKm = null,Object? maxPrice = freezed,Object? minRating = null,Object? onlyAvailable = null,Object? category = freezed,Object? sortBy = null,}) {
  return _then(_SearchFilters(
radiusKm: null == radiusKm ? _self.radiusKm : radiusKm // ignore: cast_nullable_to_non_nullable
as double,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double?,minRating: null == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as double,onlyAvailable: null == onlyAvailable ? _self.onlyAvailable : onlyAvailable // ignore: cast_nullable_to_non_nullable
as bool,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as ProductCategory?,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as SortOrder,
  ));
}


}

/// @nodoc
mixin _$SearchResult {

 ProductEntity get product; VendorEntity get vendor; double get distanceKm;
/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultCopyWith<SearchResult> get copyWith => _$SearchResultCopyWithImpl<SearchResult>(this as SearchResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResult&&(identical(other.product, product) || other.product == product)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}


@override
int get hashCode => Object.hash(runtimeType,product,vendor,distanceKm);

@override
String toString() {
  return 'SearchResult(product: $product, vendor: $vendor, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class $SearchResultCopyWith<$Res>  {
  factory $SearchResultCopyWith(SearchResult value, $Res Function(SearchResult) _then) = _$SearchResultCopyWithImpl;
@useResult
$Res call({
 ProductEntity product, VendorEntity vendor, double distanceKm
});


$ProductEntityCopyWith<$Res> get product;$VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class _$SearchResultCopyWithImpl<$Res>
    implements $SearchResultCopyWith<$Res> {
  _$SearchResultCopyWithImpl(this._self, this._then);

  final SearchResult _self;
  final $Res Function(SearchResult) _then;

/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? vendor = null,Object? distanceKm = null,}) {
  return _then(_self.copyWith(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductEntity,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductEntityCopyWith<$Res> get product {
  
  return $ProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<$Res> get vendor {
  
  return $VendorEntityCopyWith<$Res>(_self.vendor, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchResult].
extension SearchResultPatterns on SearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResult value)  $default,){
final _that = this;
switch (_that) {
case _SearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductEntity product,  VendorEntity vendor,  double distanceKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResult() when $default != null:
return $default(_that.product,_that.vendor,_that.distanceKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductEntity product,  VendorEntity vendor,  double distanceKm)  $default,) {final _that = this;
switch (_that) {
case _SearchResult():
return $default(_that.product,_that.vendor,_that.distanceKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductEntity product,  VendorEntity vendor,  double distanceKm)?  $default,) {final _that = this;
switch (_that) {
case _SearchResult() when $default != null:
return $default(_that.product,_that.vendor,_that.distanceKm);case _:
  return null;

}
}

}

/// @nodoc


class _SearchResult implements SearchResult {
  const _SearchResult({required this.product, required this.vendor, required this.distanceKm});
  

@override final  ProductEntity product;
@override final  VendorEntity vendor;
@override final  double distanceKm;

/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResultCopyWith<_SearchResult> get copyWith => __$SearchResultCopyWithImpl<_SearchResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResult&&(identical(other.product, product) || other.product == product)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}


@override
int get hashCode => Object.hash(runtimeType,product,vendor,distanceKm);

@override
String toString() {
  return 'SearchResult(product: $product, vendor: $vendor, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class _$SearchResultCopyWith<$Res> implements $SearchResultCopyWith<$Res> {
  factory _$SearchResultCopyWith(_SearchResult value, $Res Function(_SearchResult) _then) = __$SearchResultCopyWithImpl;
@override @useResult
$Res call({
 ProductEntity product, VendorEntity vendor, double distanceKm
});


@override $ProductEntityCopyWith<$Res> get product;@override $VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class __$SearchResultCopyWithImpl<$Res>
    implements _$SearchResultCopyWith<$Res> {
  __$SearchResultCopyWithImpl(this._self, this._then);

  final _SearchResult _self;
  final $Res Function(_SearchResult) _then;

/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? vendor = null,Object? distanceKm = null,}) {
  return _then(_SearchResult(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductEntity,vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductEntityCopyWith<$Res> get product {
  
  return $ProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of SearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<$Res> get vendor {
  
  return $VendorEntityCopyWith<$Res>(_self.vendor, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}
}

/// @nodoc
mixin _$NearbyVendor {

 VendorEntity get vendor; double get distanceKm;
/// Create a copy of NearbyVendor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyVendorCopyWith<NearbyVendor> get copyWith => _$NearbyVendorCopyWithImpl<NearbyVendor>(this as NearbyVendor, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyVendor&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}


@override
int get hashCode => Object.hash(runtimeType,vendor,distanceKm);

@override
String toString() {
  return 'NearbyVendor(vendor: $vendor, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class $NearbyVendorCopyWith<$Res>  {
  factory $NearbyVendorCopyWith(NearbyVendor value, $Res Function(NearbyVendor) _then) = _$NearbyVendorCopyWithImpl;
@useResult
$Res call({
 VendorEntity vendor, double distanceKm
});


$VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class _$NearbyVendorCopyWithImpl<$Res>
    implements $NearbyVendorCopyWith<$Res> {
  _$NearbyVendorCopyWithImpl(this._self, this._then);

  final NearbyVendor _self;
  final $Res Function(NearbyVendor) _then;

/// Create a copy of NearbyVendor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vendor = null,Object? distanceKm = null,}) {
  return _then(_self.copyWith(
vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of NearbyVendor
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<$Res> get vendor {
  
  return $VendorEntityCopyWith<$Res>(_self.vendor, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}
}


/// Adds pattern-matching-related methods to [NearbyVendor].
extension NearbyVendorPatterns on NearbyVendor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearbyVendor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearbyVendor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearbyVendor value)  $default,){
final _that = this;
switch (_that) {
case _NearbyVendor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearbyVendor value)?  $default,){
final _that = this;
switch (_that) {
case _NearbyVendor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VendorEntity vendor,  double distanceKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearbyVendor() when $default != null:
return $default(_that.vendor,_that.distanceKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VendorEntity vendor,  double distanceKm)  $default,) {final _that = this;
switch (_that) {
case _NearbyVendor():
return $default(_that.vendor,_that.distanceKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VendorEntity vendor,  double distanceKm)?  $default,) {final _that = this;
switch (_that) {
case _NearbyVendor() when $default != null:
return $default(_that.vendor,_that.distanceKm);case _:
  return null;

}
}

}

/// @nodoc


class _NearbyVendor implements NearbyVendor {
  const _NearbyVendor({required this.vendor, required this.distanceKm});
  

@override final  VendorEntity vendor;
@override final  double distanceKm;

/// Create a copy of NearbyVendor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearbyVendorCopyWith<_NearbyVendor> get copyWith => __$NearbyVendorCopyWithImpl<_NearbyVendor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearbyVendor&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}


@override
int get hashCode => Object.hash(runtimeType,vendor,distanceKm);

@override
String toString() {
  return 'NearbyVendor(vendor: $vendor, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class _$NearbyVendorCopyWith<$Res> implements $NearbyVendorCopyWith<$Res> {
  factory _$NearbyVendorCopyWith(_NearbyVendor value, $Res Function(_NearbyVendor) _then) = __$NearbyVendorCopyWithImpl;
@override @useResult
$Res call({
 VendorEntity vendor, double distanceKm
});


@override $VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class __$NearbyVendorCopyWithImpl<$Res>
    implements _$NearbyVendorCopyWith<$Res> {
  __$NearbyVendorCopyWithImpl(this._self, this._then);

  final _NearbyVendor _self;
  final $Res Function(_NearbyVendor) _then;

/// Create a copy of NearbyVendor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vendor = null,Object? distanceKm = null,}) {
  return _then(_NearbyVendor(
vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of NearbyVendor
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<$Res> get vendor {
  
  return $VendorEntityCopyWith<$Res>(_self.vendor, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}
}

/// @nodoc
mixin _$VendorDetail {

 VendorEntity get vendor; List<ProductEntity> get products; double? get distanceKm;
/// Create a copy of VendorDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorDetailCopyWith<VendorDetail> get copyWith => _$VendorDetailCopyWithImpl<VendorDetail>(this as VendorDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorDetail&&(identical(other.vendor, vendor) || other.vendor == vendor)&&const DeepCollectionEquality().equals(other.products, products)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}


@override
int get hashCode => Object.hash(runtimeType,vendor,const DeepCollectionEquality().hash(products),distanceKm);

@override
String toString() {
  return 'VendorDetail(vendor: $vendor, products: $products, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class $VendorDetailCopyWith<$Res>  {
  factory $VendorDetailCopyWith(VendorDetail value, $Res Function(VendorDetail) _then) = _$VendorDetailCopyWithImpl;
@useResult
$Res call({
 VendorEntity vendor, List<ProductEntity> products, double? distanceKm
});


$VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class _$VendorDetailCopyWithImpl<$Res>
    implements $VendorDetailCopyWith<$Res> {
  _$VendorDetailCopyWithImpl(this._self, this._then);

  final VendorDetail _self;
  final $Res Function(VendorDetail) _then;

/// Create a copy of VendorDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vendor = null,Object? products = null,Object? distanceKm = freezed,}) {
  return _then(_self.copyWith(
vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductEntity>,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of VendorDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VendorEntityCopyWith<$Res> get vendor {
  
  return $VendorEntityCopyWith<$Res>(_self.vendor, (value) {
    return _then(_self.copyWith(vendor: value));
  });
}
}


/// Adds pattern-matching-related methods to [VendorDetail].
extension VendorDetailPatterns on VendorDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VendorDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VendorDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VendorDetail value)  $default,){
final _that = this;
switch (_that) {
case _VendorDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VendorDetail value)?  $default,){
final _that = this;
switch (_that) {
case _VendorDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VendorEntity vendor,  List<ProductEntity> products,  double? distanceKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VendorDetail() when $default != null:
return $default(_that.vendor,_that.products,_that.distanceKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VendorEntity vendor,  List<ProductEntity> products,  double? distanceKm)  $default,) {final _that = this;
switch (_that) {
case _VendorDetail():
return $default(_that.vendor,_that.products,_that.distanceKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VendorEntity vendor,  List<ProductEntity> products,  double? distanceKm)?  $default,) {final _that = this;
switch (_that) {
case _VendorDetail() when $default != null:
return $default(_that.vendor,_that.products,_that.distanceKm);case _:
  return null;

}
}

}

/// @nodoc


class _VendorDetail implements VendorDetail {
  const _VendorDetail({required this.vendor, required final  List<ProductEntity> products, this.distanceKm}): _products = products;
  

@override final  VendorEntity vendor;
 final  List<ProductEntity> _products;
@override List<ProductEntity> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@override final  double? distanceKm;

/// Create a copy of VendorDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VendorDetailCopyWith<_VendorDetail> get copyWith => __$VendorDetailCopyWithImpl<_VendorDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VendorDetail&&(identical(other.vendor, vendor) || other.vendor == vendor)&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}


@override
int get hashCode => Object.hash(runtimeType,vendor,const DeepCollectionEquality().hash(_products),distanceKm);

@override
String toString() {
  return 'VendorDetail(vendor: $vendor, products: $products, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class _$VendorDetailCopyWith<$Res> implements $VendorDetailCopyWith<$Res> {
  factory _$VendorDetailCopyWith(_VendorDetail value, $Res Function(_VendorDetail) _then) = __$VendorDetailCopyWithImpl;
@override @useResult
$Res call({
 VendorEntity vendor, List<ProductEntity> products, double? distanceKm
});


@override $VendorEntityCopyWith<$Res> get vendor;

}
/// @nodoc
class __$VendorDetailCopyWithImpl<$Res>
    implements _$VendorDetailCopyWith<$Res> {
  __$VendorDetailCopyWithImpl(this._self, this._then);

  final _VendorDetail _self;
  final $Res Function(_VendorDetail) _then;

/// Create a copy of VendorDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vendor = null,Object? products = null,Object? distanceKm = freezed,}) {
  return _then(_VendorDetail(
vendor: null == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as VendorEntity,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductEntity>,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of VendorDetail
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
