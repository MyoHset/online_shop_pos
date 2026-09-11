// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Variant {
  String get id;
  String get productId;
  String? get size;
  String? get color;
  String get sku;
  double? get priceOverride;
  int get stockQuantity;
  int get stockReserved;
  int? get weightGrams;
  bool get isActive;
  List<VariantImage> get images;

  /// Create a copy of Variant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VariantCopyWith<Variant> get copyWith =>
      _$VariantCopyWithImpl<Variant>(this as Variant, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Variant &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.priceOverride, priceOverride) ||
                other.priceOverride == priceOverride) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.stockReserved, stockReserved) ||
                other.stockReserved == stockReserved) &&
            (identical(other.weightGrams, weightGrams) ||
                other.weightGrams == weightGrams) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other.images, images));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      size,
      color,
      sku,
      priceOverride,
      stockQuantity,
      stockReserved,
      weightGrams,
      isActive,
      const DeepCollectionEquality().hash(images));

  @override
  String toString() {
    return 'Variant(id: $id, productId: $productId, size: $size, color: $color, sku: $sku, priceOverride: $priceOverride, stockQuantity: $stockQuantity, stockReserved: $stockReserved, weightGrams: $weightGrams, isActive: $isActive, images: $images)';
  }
}

/// @nodoc
abstract mixin class $VariantCopyWith<$Res> {
  factory $VariantCopyWith(Variant value, $Res Function(Variant) _then) =
      _$VariantCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String productId,
      String? size,
      String? color,
      String sku,
      double? priceOverride,
      int stockQuantity,
      int stockReserved,
      int? weightGrams,
      bool isActive,
      List<VariantImage> images});
}

/// @nodoc
class _$VariantCopyWithImpl<$Res> implements $VariantCopyWith<$Res> {
  _$VariantCopyWithImpl(this._self, this._then);

  final Variant _self;
  final $Res Function(Variant) _then;

  /// Create a copy of Variant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? size = freezed,
    Object? color = freezed,
    Object? sku = null,
    Object? priceOverride = freezed,
    Object? stockQuantity = null,
    Object? stockReserved = null,
    Object? weightGrams = freezed,
    Object? isActive = null,
    Object? images = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      size: freezed == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: null == sku
          ? _self.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      priceOverride: freezed == priceOverride
          ? _self.priceOverride
          : priceOverride // ignore: cast_nullable_to_non_nullable
              as double?,
      stockQuantity: null == stockQuantity
          ? _self.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      stockReserved: null == stockReserved
          ? _self.stockReserved
          : stockReserved // ignore: cast_nullable_to_non_nullable
              as int,
      weightGrams: freezed == weightGrams
          ? _self.weightGrams
          : weightGrams // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      images: null == images
          ? _self.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<VariantImage>,
    ));
  }
}

/// Adds pattern-matching-related methods to [Variant].
extension VariantPatterns on Variant {
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
    TResult Function(_Variant value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Variant() when $default != null:
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
    TResult Function(_Variant value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Variant():
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
    TResult? Function(_Variant value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Variant() when $default != null:
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
            String id,
            String productId,
            String? size,
            String? color,
            String sku,
            double? priceOverride,
            int stockQuantity,
            int stockReserved,
            int? weightGrams,
            bool isActive,
            List<VariantImage> images)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Variant() when $default != null:
        return $default(
            _that.id,
            _that.productId,
            _that.size,
            _that.color,
            _that.sku,
            _that.priceOverride,
            _that.stockQuantity,
            _that.stockReserved,
            _that.weightGrams,
            _that.isActive,
            _that.images);
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
            String id,
            String productId,
            String? size,
            String? color,
            String sku,
            double? priceOverride,
            int stockQuantity,
            int stockReserved,
            int? weightGrams,
            bool isActive,
            List<VariantImage> images)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Variant():
        return $default(
            _that.id,
            _that.productId,
            _that.size,
            _that.color,
            _that.sku,
            _that.priceOverride,
            _that.stockQuantity,
            _that.stockReserved,
            _that.weightGrams,
            _that.isActive,
            _that.images);
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
            String id,
            String productId,
            String? size,
            String? color,
            String sku,
            double? priceOverride,
            int stockQuantity,
            int stockReserved,
            int? weightGrams,
            bool isActive,
            List<VariantImage> images)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Variant() when $default != null:
        return $default(
            _that.id,
            _that.productId,
            _that.size,
            _that.color,
            _that.sku,
            _that.priceOverride,
            _that.stockQuantity,
            _that.stockReserved,
            _that.weightGrams,
            _that.isActive,
            _that.images);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Variant extends Variant {
  const _Variant(
      {required this.id,
      required this.productId,
      required this.size,
      required this.color,
      required this.sku,
      required this.priceOverride,
      required this.stockQuantity,
      required this.stockReserved,
      required this.weightGrams,
      required this.isActive,
      final List<VariantImage> images = const []})
      : _images = images,
        super._();

  @override
  final String id;
  @override
  final String productId;
  @override
  final String? size;
  @override
  final String? color;
  @override
  final String sku;
  @override
  final double? priceOverride;
  @override
  final int stockQuantity;
  @override
  final int stockReserved;
  @override
  final int? weightGrams;
  @override
  final bool isActive;
  final List<VariantImage> _images;
  @override
  @JsonKey()
  List<VariantImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  /// Create a copy of Variant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VariantCopyWith<_Variant> get copyWith =>
      __$VariantCopyWithImpl<_Variant>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Variant &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.priceOverride, priceOverride) ||
                other.priceOverride == priceOverride) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.stockReserved, stockReserved) ||
                other.stockReserved == stockReserved) &&
            (identical(other.weightGrams, weightGrams) ||
                other.weightGrams == weightGrams) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      size,
      color,
      sku,
      priceOverride,
      stockQuantity,
      stockReserved,
      weightGrams,
      isActive,
      const DeepCollectionEquality().hash(_images));

  @override
  String toString() {
    return 'Variant(id: $id, productId: $productId, size: $size, color: $color, sku: $sku, priceOverride: $priceOverride, stockQuantity: $stockQuantity, stockReserved: $stockReserved, weightGrams: $weightGrams, isActive: $isActive, images: $images)';
  }
}

/// @nodoc
abstract mixin class _$VariantCopyWith<$Res> implements $VariantCopyWith<$Res> {
  factory _$VariantCopyWith(_Variant value, $Res Function(_Variant) _then) =
      __$VariantCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      String? size,
      String? color,
      String sku,
      double? priceOverride,
      int stockQuantity,
      int stockReserved,
      int? weightGrams,
      bool isActive,
      List<VariantImage> images});
}

/// @nodoc
class __$VariantCopyWithImpl<$Res> implements _$VariantCopyWith<$Res> {
  __$VariantCopyWithImpl(this._self, this._then);

  final _Variant _self;
  final $Res Function(_Variant) _then;

  /// Create a copy of Variant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? size = freezed,
    Object? color = freezed,
    Object? sku = null,
    Object? priceOverride = freezed,
    Object? stockQuantity = null,
    Object? stockReserved = null,
    Object? weightGrams = freezed,
    Object? isActive = null,
    Object? images = null,
  }) {
    return _then(_Variant(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      size: freezed == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: null == sku
          ? _self.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      priceOverride: freezed == priceOverride
          ? _self.priceOverride
          : priceOverride // ignore: cast_nullable_to_non_nullable
              as double?,
      stockQuantity: null == stockQuantity
          ? _self.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      stockReserved: null == stockReserved
          ? _self.stockReserved
          : stockReserved // ignore: cast_nullable_to_non_nullable
              as int,
      weightGrams: freezed == weightGrams
          ? _self.weightGrams
          : weightGrams // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      images: null == images
          ? _self._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<VariantImage>,
    ));
  }
}

// dart format on
