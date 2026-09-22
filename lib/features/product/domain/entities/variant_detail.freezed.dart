// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variant_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VariantDetail {
  String? get shopId;
  String get productName;
  String? get category;
  String? get brand;
  String get variantId;
  String? get sku;
  String? get size;
  String? get color;
  double get finalPrice;
  int get availableStock;
  String? get primaryImage;

  /// Create a copy of VariantDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VariantDetailCopyWith<VariantDetail> get copyWith =>
      _$VariantDetailCopyWithImpl<VariantDetail>(
          this as VariantDetail, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VariantDetail &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.finalPrice, finalPrice) ||
                other.finalPrice == finalPrice) &&
            (identical(other.availableStock, availableStock) ||
                other.availableStock == availableStock) &&
            (identical(other.primaryImage, primaryImage) ||
                other.primaryImage == primaryImage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      shopId,
      productName,
      category,
      brand,
      variantId,
      sku,
      size,
      color,
      finalPrice,
      availableStock,
      primaryImage);

  @override
  String toString() {
    return 'VariantDetail(shopId: $shopId, productName: $productName, category: $category, brand: $brand, variantId: $variantId, sku: $sku, size: $size, color: $color, finalPrice: $finalPrice, availableStock: $availableStock, primaryImage: $primaryImage)';
  }
}

/// @nodoc
abstract mixin class $VariantDetailCopyWith<$Res> {
  factory $VariantDetailCopyWith(
          VariantDetail value, $Res Function(VariantDetail) _then) =
      _$VariantDetailCopyWithImpl;
  @useResult
  $Res call(
      {String? shopId,
      String productName,
      String? category,
      String? brand,
      String variantId,
      String? sku,
      String? size,
      String? color,
      double finalPrice,
      int availableStock,
      String? primaryImage});
}

/// @nodoc
class _$VariantDetailCopyWithImpl<$Res>
    implements $VariantDetailCopyWith<$Res> {
  _$VariantDetailCopyWithImpl(this._self, this._then);

  final VariantDetail _self;
  final $Res Function(VariantDetail) _then;

  /// Create a copy of VariantDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shopId = freezed,
    Object? productName = null,
    Object? category = freezed,
    Object? brand = freezed,
    Object? variantId = null,
    Object? sku = freezed,
    Object? size = freezed,
    Object? color = freezed,
    Object? finalPrice = null,
    Object? availableStock = null,
    Object? primaryImage = freezed,
  }) {
    return _then(_self.copyWith(
      shopId: freezed == shopId
          ? _self.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: null == variantId
          ? _self.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _self.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      finalPrice: null == finalPrice
          ? _self.finalPrice
          : finalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      availableStock: null == availableStock
          ? _self.availableStock
          : availableStock // ignore: cast_nullable_to_non_nullable
              as int,
      primaryImage: freezed == primaryImage
          ? _self.primaryImage
          : primaryImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [VariantDetail].
extension VariantDetailPatterns on VariantDetail {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_VariantDetail value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VariantDetail() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_VariantDetail value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantDetail():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_VariantDetail value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantDetail() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String? shopId,
            String productName,
            String? category,
            String? brand,
            String variantId,
            String? sku,
            String? size,
            String? color,
            double finalPrice,
            int availableStock,
            String? primaryImage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VariantDetail() when $default != null:
        return $default(
            _that.shopId,
            _that.productName,
            _that.category,
            _that.brand,
            _that.variantId,
            _that.sku,
            _that.size,
            _that.color,
            _that.finalPrice,
            _that.availableStock,
            _that.primaryImage);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String? shopId,
            String productName,
            String? category,
            String? brand,
            String variantId,
            String? sku,
            String? size,
            String? color,
            double finalPrice,
            int availableStock,
            String? primaryImage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantDetail():
        return $default(
            _that.shopId,
            _that.productName,
            _that.category,
            _that.brand,
            _that.variantId,
            _that.sku,
            _that.size,
            _that.color,
            _that.finalPrice,
            _that.availableStock,
            _that.primaryImage);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String? shopId,
            String productName,
            String? category,
            String? brand,
            String variantId,
            String? sku,
            String? size,
            String? color,
            double finalPrice,
            int availableStock,
            String? primaryImage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantDetail() when $default != null:
        return $default(
            _that.shopId,
            _that.productName,
            _that.category,
            _that.brand,
            _that.variantId,
            _that.sku,
            _that.size,
            _that.color,
            _that.finalPrice,
            _that.availableStock,
            _that.primaryImage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _VariantDetail implements VariantDetail {
  const _VariantDetail(
      {this.shopId,
      required this.productName,
      this.category,
      this.brand,
      required this.variantId,
      this.sku,
      this.size,
      this.color,
      required this.finalPrice,
      required this.availableStock,
      this.primaryImage});

  @override
  final String? shopId;
  @override
  final String productName;
  @override
  final String? category;
  @override
  final String? brand;
  @override
  final String variantId;
  @override
  final String? sku;
  @override
  final String? size;
  @override
  final String? color;
  @override
  final double finalPrice;
  @override
  final int availableStock;
  @override
  final String? primaryImage;

  /// Create a copy of VariantDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VariantDetailCopyWith<_VariantDetail> get copyWith =>
      __$VariantDetailCopyWithImpl<_VariantDetail>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VariantDetail &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.finalPrice, finalPrice) ||
                other.finalPrice == finalPrice) &&
            (identical(other.availableStock, availableStock) ||
                other.availableStock == availableStock) &&
            (identical(other.primaryImage, primaryImage) ||
                other.primaryImage == primaryImage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      shopId,
      productName,
      category,
      brand,
      variantId,
      sku,
      size,
      color,
      finalPrice,
      availableStock,
      primaryImage);

  @override
  String toString() {
    return 'VariantDetail(shopId: $shopId, productName: $productName, category: $category, brand: $brand, variantId: $variantId, sku: $sku, size: $size, color: $color, finalPrice: $finalPrice, availableStock: $availableStock, primaryImage: $primaryImage)';
  }
}

/// @nodoc
abstract mixin class _$VariantDetailCopyWith<$Res>
    implements $VariantDetailCopyWith<$Res> {
  factory _$VariantDetailCopyWith(
          _VariantDetail value, $Res Function(_VariantDetail) _then) =
      __$VariantDetailCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? shopId,
      String productName,
      String? category,
      String? brand,
      String variantId,
      String? sku,
      String? size,
      String? color,
      double finalPrice,
      int availableStock,
      String? primaryImage});
}

/// @nodoc
class __$VariantDetailCopyWithImpl<$Res>
    implements _$VariantDetailCopyWith<$Res> {
  __$VariantDetailCopyWithImpl(this._self, this._then);

  final _VariantDetail _self;
  final $Res Function(_VariantDetail) _then;

  /// Create a copy of VariantDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? shopId = freezed,
    Object? productName = null,
    Object? category = freezed,
    Object? brand = freezed,
    Object? variantId = null,
    Object? sku = freezed,
    Object? size = freezed,
    Object? color = freezed,
    Object? finalPrice = null,
    Object? availableStock = null,
    Object? primaryImage = freezed,
  }) {
    return _then(_VariantDetail(
      shopId: freezed == shopId
          ? _self.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      variantId: null == variantId
          ? _self.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String,
      sku: freezed == sku
          ? _self.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      finalPrice: null == finalPrice
          ? _self.finalPrice
          : finalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      availableStock: null == availableStock
          ? _self.availableStock
          : availableStock // ignore: cast_nullable_to_non_nullable
              as int,
      primaryImage: freezed == primaryImage
          ? _self.primaryImage
          : primaryImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
