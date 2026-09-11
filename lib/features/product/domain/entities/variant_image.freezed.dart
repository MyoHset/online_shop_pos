// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variant_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VariantImage {
  String get id;
  String get variantId;
  String get imageUrl;
  bool get isPrimary;
  int get sortOrder;

  /// Create a copy of VariantImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VariantImageCopyWith<VariantImage> get copyWith =>
      _$VariantImageCopyWithImpl<VariantImage>(
          this as VariantImage, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VariantImage &&
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

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, variantId, imageUrl, isPrimary, sortOrder);

  @override
  String toString() {
    return 'VariantImage(id: $id, variantId: $variantId, imageUrl: $imageUrl, isPrimary: $isPrimary, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class $VariantImageCopyWith<$Res> {
  factory $VariantImageCopyWith(
          VariantImage value, $Res Function(VariantImage) _then) =
      _$VariantImageCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String variantId,
      String imageUrl,
      bool isPrimary,
      int sortOrder});
}

/// @nodoc
class _$VariantImageCopyWithImpl<$Res> implements $VariantImageCopyWith<$Res> {
  _$VariantImageCopyWithImpl(this._self, this._then);

  final VariantImage _self;
  final $Res Function(VariantImage) _then;

  /// Create a copy of VariantImage
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

/// Adds pattern-matching-related methods to [VariantImage].
extension VariantImagePatterns on VariantImage {
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
    TResult Function(_VariantImage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VariantImage() when $default != null:
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
    TResult Function(_VariantImage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantImage():
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
    TResult? Function(_VariantImage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VariantImage() when $default != null:
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
      case _VariantImage() when $default != null:
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
      case _VariantImage():
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
      case _VariantImage() when $default != null:
        return $default(_that.id, _that.variantId, _that.imageUrl,
            _that.isPrimary, _that.sortOrder);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _VariantImage implements VariantImage {
  const _VariantImage(
      {required this.id,
      required this.variantId,
      required this.imageUrl,
      required this.isPrimary,
      required this.sortOrder});

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

  /// Create a copy of VariantImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VariantImageCopyWith<_VariantImage> get copyWith =>
      __$VariantImageCopyWithImpl<_VariantImage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VariantImage &&
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

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, variantId, imageUrl, isPrimary, sortOrder);

  @override
  String toString() {
    return 'VariantImage(id: $id, variantId: $variantId, imageUrl: $imageUrl, isPrimary: $isPrimary, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class _$VariantImageCopyWith<$Res>
    implements $VariantImageCopyWith<$Res> {
  factory _$VariantImageCopyWith(
          _VariantImage value, $Res Function(_VariantImage) _then) =
      __$VariantImageCopyWithImpl;
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
class __$VariantImageCopyWithImpl<$Res>
    implements _$VariantImageCopyWith<$Res> {
  __$VariantImageCopyWithImpl(this._self, this._then);

  final _VariantImage _self;
  final $Res Function(_VariantImage) _then;

  /// Create a copy of VariantImage
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
    return _then(_VariantImage(
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
