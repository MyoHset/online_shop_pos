// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModel {
  String get id;
  String? get shopId;
  String get name;
  String? get description;
  double get basePrice;
  String? get category;
  String? get brand;
  String? get productCode;
  bool get isActive;
  List<VariantModel> get productVariants;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductModelCopyWith<ProductModel> get copyWith =>
      _$ProductModelCopyWithImpl<ProductModel>(
          this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.productCode, productCode) ||
                other.productCode == productCode) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality()
                .equals(other.productVariants, productVariants));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      shopId,
      name,
      description,
      basePrice,
      category,
      brand,
      productCode,
      isActive,
      const DeepCollectionEquality().hash(productVariants));

  @override
  String toString() {
    return 'ProductModel(id: $id, shopId: $shopId, name: $name, description: $description, basePrice: $basePrice, category: $category, brand: $brand, productCode: $productCode, isActive: $isActive, productVariants: $productVariants)';
  }
}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) _then) =
      _$ProductModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? shopId,
      String name,
      String? description,
      double basePrice,
      String? category,
      String? brand,
      String? productCode,
      bool isActive,
      List<VariantModel> productVariants});
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res> implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? basePrice = null,
    Object? category = freezed,
    Object? brand = freezed,
    Object? productCode = freezed,
    Object? isActive = null,
    Object? productVariants = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: freezed == shopId
          ? _self.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      basePrice: null == basePrice
          ? _self.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      productCode: freezed == productCode
          ? _self.productCode
          : productCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      productVariants: null == productVariants
          ? _self.productVariants
          : productVariants // ignore: cast_nullable_to_non_nullable
              as List<VariantModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
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
    TResult Function(_ProductModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
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
    TResult Function(_ProductModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel():
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
    TResult? Function(_ProductModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
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
            String? shopId,
            String name,
            String? description,
            double basePrice,
            String? category,
            String? brand,
            String? productCode,
            bool isActive,
            List<VariantModel> productVariants)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
        return $default(
            _that.id,
            _that.shopId,
            _that.name,
            _that.description,
            _that.basePrice,
            _that.category,
            _that.brand,
            _that.productCode,
            _that.isActive,
            _that.productVariants);
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
            String? shopId,
            String name,
            String? description,
            double basePrice,
            String? category,
            String? brand,
            String? productCode,
            bool isActive,
            List<VariantModel> productVariants)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel():
        return $default(
            _that.id,
            _that.shopId,
            _that.name,
            _that.description,
            _that.basePrice,
            _that.category,
            _that.brand,
            _that.productCode,
            _that.isActive,
            _that.productVariants);
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
            String? shopId,
            String name,
            String? description,
            double basePrice,
            String? category,
            String? brand,
            String? productCode,
            bool isActive,
            List<VariantModel> productVariants)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
        return $default(
            _that.id,
            _that.shopId,
            _that.name,
            _that.description,
            _that.basePrice,
            _that.category,
            _that.brand,
            _that.productCode,
            _that.isActive,
            _that.productVariants);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ProductModel extends ProductModel {
  const _ProductModel(
      {required this.id,
      this.shopId,
      required this.name,
      required this.description,
      required this.basePrice,
      required this.category,
      required this.brand,
      required this.productCode,
      required this.isActive,
      final List<VariantModel> productVariants = const []})
      : _productVariants = productVariants,
        super._();
  factory _ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  @override
  final String id;
  @override
  final String? shopId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double basePrice;
  @override
  final String? category;
  @override
  final String? brand;
  @override
  final String? productCode;
  @override
  final bool isActive;
  final List<VariantModel> _productVariants;
  @override
  @JsonKey()
  List<VariantModel> get productVariants {
    if (_productVariants is EqualUnmodifiableListView) return _productVariants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productVariants);
  }

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductModelCopyWith<_ProductModel> get copyWith =>
      __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.productCode, productCode) ||
                other.productCode == productCode) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality()
                .equals(other._productVariants, _productVariants));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      shopId,
      name,
      description,
      basePrice,
      category,
      brand,
      productCode,
      isActive,
      const DeepCollectionEquality().hash(_productVariants));

  @override
  String toString() {
    return 'ProductModel(id: $id, shopId: $shopId, name: $name, description: $description, basePrice: $basePrice, category: $category, brand: $brand, productCode: $productCode, isActive: $isActive, productVariants: $productVariants)';
  }
}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(
          _ProductModel value, $Res Function(_ProductModel) _then) =
      __$ProductModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? shopId,
      String name,
      String? description,
      double basePrice,
      String? category,
      String? brand,
      String? productCode,
      bool isActive,
      List<VariantModel> productVariants});
}

/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? shopId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? basePrice = null,
    Object? category = freezed,
    Object? brand = freezed,
    Object? productCode = freezed,
    Object? isActive = null,
    Object? productVariants = null,
  }) {
    return _then(_ProductModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: freezed == shopId
          ? _self.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      basePrice: null == basePrice
          ? _self.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      productCode: freezed == productCode
          ? _self.productCode
          : productCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      productVariants: null == productVariants
          ? _self._productVariants
          : productVariants // ignore: cast_nullable_to_non_nullable
              as List<VariantModel>,
    ));
  }
}

// dart format on
