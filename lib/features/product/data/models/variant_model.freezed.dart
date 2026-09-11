// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VariantModel {
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
  List<VariantImageModel> get variantImages;

  /// Create a copy of VariantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VariantModelCopyWith<VariantModel> get copyWith =>
      _$VariantModelCopyWithImpl<VariantModel>(
          this as VariantModel, _$identity);

  /// Serializes this VariantModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VariantModel &&
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
            const DeepCollectionEquality()
                .equals(other.variantImages, variantImages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
      const DeepCollectionEquality().hash(variantImages));

  @override
  String toString() {
    return 'VariantModel(id: $id, productId: $productId, size: $size, color: $color, sku: $sku, priceOverride: $priceOverride, stockQuantity: $stockQuantity, stockReserved: $stockReserved, weightGrams: $weightGrams, isActive: $isActive, variantImages: $variantImages)';
  }
}

/// @nodoc
abstract mixin class $VariantModelCopyWith<$Res> {
  factory $VariantModelCopyWith(
          VariantModel value, $Res Function(VariantModel) _then) =
      _$VariantModelCopyWithImpl;
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
      List<VariantImageModel> variantImages});
}

/// @nodoc
class _$VariantModelCopyWithImpl<$Res> implements $VariantModelCopyWith<$Res> {
  _$VariantModelCopyWithImpl(this._self, this._then);

  final VariantModel _self;
  final $Res Function(VariantModel) _then;

  /// Create a copy of VariantModel
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
    Object? variantImages = null,
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
      variantImages: null == variantImages
          ? _self.variantImages
          : variantImages // ignore: cast_nullable_to_non_nullable
              as List<VariantImageModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [VariantModel].
extension VariantModelPatterns on VariantModel {
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
    TResult Function(_VariantModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VariantModel() when $default != null:
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
    TResult Function(_VariantModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantModel():
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
    TResult? Function(_VariantModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantModel() when $default != null:
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
            List<VariantImageModel> variantImages)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VariantModel() when $default != null:
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
            _that.variantImages);
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
            List<VariantImageModel> variantImages)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantModel():
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
            _that.variantImages);
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
            List<VariantImageModel> variantImages)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantModel() when $default != null:
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
            _that.variantImages);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _VariantModel extends VariantModel {
  const _VariantModel(
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
      final List<VariantImageModel> variantImages = const []})
      : _variantImages = variantImages,
        super._();
  factory _VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);

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
  final List<VariantImageModel> _variantImages;
  @override
  @JsonKey()
  List<VariantImageModel> get variantImages {
    if (_variantImages is EqualUnmodifiableListView) return _variantImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variantImages);
  }

  /// Create a copy of VariantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VariantModelCopyWith<_VariantModel> get copyWith =>
      __$VariantModelCopyWithImpl<_VariantModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VariantModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VariantModel &&
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
            const DeepCollectionEquality()
                .equals(other._variantImages, _variantImages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
      const DeepCollectionEquality().hash(_variantImages));

  @override
  String toString() {
    return 'VariantModel(id: $id, productId: $productId, size: $size, color: $color, sku: $sku, priceOverride: $priceOverride, stockQuantity: $stockQuantity, stockReserved: $stockReserved, weightGrams: $weightGrams, isActive: $isActive, variantImages: $variantImages)';
  }
}

/// @nodoc
abstract mixin class _$VariantModelCopyWith<$Res>
    implements $VariantModelCopyWith<$Res> {
  factory _$VariantModelCopyWith(
          _VariantModel value, $Res Function(_VariantModel) _then) =
      __$VariantModelCopyWithImpl;
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
      List<VariantImageModel> variantImages});
}

/// @nodoc
class __$VariantModelCopyWithImpl<$Res>
    implements _$VariantModelCopyWith<$Res> {
  __$VariantModelCopyWithImpl(this._self, this._then);

  final _VariantModel _self;
  final $Res Function(_VariantModel) _then;

  /// Create a copy of VariantModel
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
    Object? variantImages = null,
  }) {
    return _then(_VariantModel(
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
      variantImages: null == variantImages
          ? _self._variantImages
          : variantImages // ignore: cast_nullable_to_non_nullable
              as List<VariantImageModel>,
    ));
  }
}

// dart format on
