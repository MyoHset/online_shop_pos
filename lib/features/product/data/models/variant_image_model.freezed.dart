// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variant_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VariantImageModel {
  String get id;
  String get variantId;
  String get imageUrl;
  bool get isPrimary;
  int get sortOrder;

  /// Create a copy of VariantImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VariantImageModelCopyWith<VariantImageModel> get copyWith =>
      _$VariantImageModelCopyWithImpl<VariantImageModel>(
          this as VariantImageModel, _$identity);

  /// Serializes this VariantImageModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VariantImageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, variantId, imageUrl, isPrimary, sortOrder);

  @override
  String toString() {
    return 'VariantImageModel(id: $id, variantId: $variantId, imageUrl: $imageUrl, isPrimary: $isPrimary, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class $VariantImageModelCopyWith<$Res> {
  factory $VariantImageModelCopyWith(
          VariantImageModel value, $Res Function(VariantImageModel) _then) =
      _$VariantImageModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String variantId,
      String imageUrl,
      bool isPrimary,
      int sortOrder});
}

/// @nodoc
class _$VariantImageModelCopyWithImpl<$Res>
    implements $VariantImageModelCopyWith<$Res> {
  _$VariantImageModelCopyWithImpl(this._self, this._then);

  final VariantImageModel _self;
  final $Res Function(VariantImageModel) _then;

  /// Create a copy of VariantImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? variantId = null,
    Object? imageUrl = null,
    Object? isPrimary = null,
    Object? sortOrder = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: null == variantId
          ? _self.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isPrimary: null == isPrimary
          ? _self.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [VariantImageModel].
extension VariantImageModelPatterns on VariantImageModel {
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
    TResult Function(_VariantImageModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VariantImageModel() when $default != null:
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
    TResult Function(_VariantImageModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantImageModel():
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
    TResult? Function(_VariantImageModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantImageModel() when $default != null:
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
    TResult Function(String id, String variantId, String imageUrl,
            bool isPrimary, int sortOrder)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VariantImageModel() when $default != null:
        return $default(_that.id, _that.variantId, _that.imageUrl,
            _that.isPrimary, _that.sortOrder);
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
    TResult Function(String id, String variantId, String imageUrl,
            bool isPrimary, int sortOrder)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantImageModel():
        return $default(_that.id, _that.variantId, _that.imageUrl,
            _that.isPrimary, _that.sortOrder);
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
    TResult? Function(String id, String variantId, String imageUrl,
            bool isPrimary, int sortOrder)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantImageModel() when $default != null:
        return $default(_that.id, _that.variantId, _that.imageUrl,
            _that.isPrimary, _that.sortOrder);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _VariantImageModel extends VariantImageModel {
  const _VariantImageModel(
      {required this.id,
      required this.variantId,
      required this.imageUrl,
      required this.isPrimary,
      required this.sortOrder})
      : super._();
  factory _VariantImageModel.fromJson(Map<String, dynamic> json) =>
      _$VariantImageModelFromJson(json);

  @override
  final String id;
  @override
  final String variantId;
  @override
  final String imageUrl;
  @override
  final bool isPrimary;
  @override
  final int sortOrder;

  /// Create a copy of VariantImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VariantImageModelCopyWith<_VariantImageModel> get copyWith =>
      __$VariantImageModelCopyWithImpl<_VariantImageModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VariantImageModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VariantImageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, variantId, imageUrl, isPrimary, sortOrder);

  @override
  String toString() {
    return 'VariantImageModel(id: $id, variantId: $variantId, imageUrl: $imageUrl, isPrimary: $isPrimary, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class _$VariantImageModelCopyWith<$Res>
    implements $VariantImageModelCopyWith<$Res> {
  factory _$VariantImageModelCopyWith(
          _VariantImageModel value, $Res Function(_VariantImageModel) _then) =
      __$VariantImageModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String variantId,
      String imageUrl,
      bool isPrimary,
      int sortOrder});
}

/// @nodoc
class __$VariantImageModelCopyWithImpl<$Res>
    implements _$VariantImageModelCopyWith<$Res> {
  __$VariantImageModelCopyWithImpl(this._self, this._then);

  final _VariantImageModel _self;
  final $Res Function(_VariantImageModel) _then;

  /// Create a copy of VariantImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? variantId = null,
    Object? imageUrl = null,
    Object? isPrimary = null,
    Object? sortOrder = null,
  }) {
    return _then(_VariantImageModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      variantId: null == variantId
          ? _self.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isPrimary: null == isPrimary
          ? _self.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
