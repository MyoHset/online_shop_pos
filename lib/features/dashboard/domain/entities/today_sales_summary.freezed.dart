// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_sales_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodaySalesSummary {
  @JsonKey(name: 'order_count')
  int get orderCount;
  @JsonKey(name: 'total_revenue')
  double get totalRevenue;
  @JsonKey(name: 'online_revenue')
  double get onlineRevenue;
  @JsonKey(name: 'in_store_revenue')
  double get inStoreRevenue;

  /// Create a copy of TodaySalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TodaySalesSummaryCopyWith<TodaySalesSummary> get copyWith =>
      _$TodaySalesSummaryCopyWithImpl<TodaySalesSummary>(
          this as TodaySalesSummary, _$identity);

  /// Serializes this TodaySalesSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TodaySalesSummary &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.onlineRevenue, onlineRevenue) ||
                other.onlineRevenue == onlineRevenue) &&
            (identical(other.inStoreRevenue, inStoreRevenue) ||
                other.inStoreRevenue == inStoreRevenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, orderCount, totalRevenue, onlineRevenue, inStoreRevenue);

  @override
  String toString() {
    return 'TodaySalesSummary(orderCount: $orderCount, totalRevenue: $totalRevenue, onlineRevenue: $onlineRevenue, inStoreRevenue: $inStoreRevenue)';
  }
}

/// @nodoc
abstract mixin class $TodaySalesSummaryCopyWith<$Res> {
  factory $TodaySalesSummaryCopyWith(
          TodaySalesSummary value, $Res Function(TodaySalesSummary) _then) =
      _$TodaySalesSummaryCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'order_count') int orderCount,
      @JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'online_revenue') double onlineRevenue,
      @JsonKey(name: 'in_store_revenue') double inStoreRevenue});
}

/// @nodoc
class _$TodaySalesSummaryCopyWithImpl<$Res>
    implements $TodaySalesSummaryCopyWith<$Res> {
  _$TodaySalesSummaryCopyWithImpl(this._self, this._then);

  final TodaySalesSummary _self;
  final $Res Function(TodaySalesSummary) _then;

  /// Create a copy of TodaySalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderCount = null,
    Object? totalRevenue = null,
    Object? onlineRevenue = null,
    Object? inStoreRevenue = null,
  }) {
    return _then(_self.copyWith(
      orderCount: null == orderCount
          ? _self.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _self.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      onlineRevenue: null == onlineRevenue
          ? _self.onlineRevenue
          : onlineRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      inStoreRevenue: null == inStoreRevenue
          ? _self.inStoreRevenue
          : inStoreRevenue // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [TodaySalesSummary].
extension TodaySalesSummaryPatterns on TodaySalesSummary {
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
    TResult Function(_TodaySalesSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TodaySalesSummary() when $default != null:
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
    TResult Function(_TodaySalesSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodaySalesSummary():
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
    TResult? Function(_TodaySalesSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodaySalesSummary() when $default != null:
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
            @JsonKey(name: 'order_count') int orderCount,
            @JsonKey(name: 'total_revenue') double totalRevenue,
            @JsonKey(name: 'online_revenue') double onlineRevenue,
            @JsonKey(name: 'in_store_revenue') double inStoreRevenue)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TodaySalesSummary() when $default != null:
        return $default(_that.orderCount, _that.totalRevenue,
            _that.onlineRevenue, _that.inStoreRevenue);
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
            @JsonKey(name: 'order_count') int orderCount,
            @JsonKey(name: 'total_revenue') double totalRevenue,
            @JsonKey(name: 'online_revenue') double onlineRevenue,
            @JsonKey(name: 'in_store_revenue') double inStoreRevenue)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodaySalesSummary():
        return $default(_that.orderCount, _that.totalRevenue,
            _that.onlineRevenue, _that.inStoreRevenue);
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
            @JsonKey(name: 'order_count') int orderCount,
            @JsonKey(name: 'total_revenue') double totalRevenue,
            @JsonKey(name: 'online_revenue') double onlineRevenue,
            @JsonKey(name: 'in_store_revenue') double inStoreRevenue)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TodaySalesSummary() when $default != null:
        return $default(_that.orderCount, _that.totalRevenue,
            _that.onlineRevenue, _that.inStoreRevenue);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TodaySalesSummary implements TodaySalesSummary {
  const _TodaySalesSummary(
      {@JsonKey(name: 'order_count') this.orderCount = 0,
      @JsonKey(name: 'total_revenue') this.totalRevenue = 0.0,
      @JsonKey(name: 'online_revenue') this.onlineRevenue = 0.0,
      @JsonKey(name: 'in_store_revenue') this.inStoreRevenue = 0.0});
  factory _TodaySalesSummary.fromJson(Map<String, dynamic> json) =>
      _$TodaySalesSummaryFromJson(json);

  @override
  @JsonKey(name: 'order_count')
  final int orderCount;
  @override
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;
  @override
  @JsonKey(name: 'online_revenue')
  final double onlineRevenue;
  @override
  @JsonKey(name: 'in_store_revenue')
  final double inStoreRevenue;

  /// Create a copy of TodaySalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TodaySalesSummaryCopyWith<_TodaySalesSummary> get copyWith =>
      __$TodaySalesSummaryCopyWithImpl<_TodaySalesSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TodaySalesSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TodaySalesSummary &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.onlineRevenue, onlineRevenue) ||
                other.onlineRevenue == onlineRevenue) &&
            (identical(other.inStoreRevenue, inStoreRevenue) ||
                other.inStoreRevenue == inStoreRevenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, orderCount, totalRevenue, onlineRevenue, inStoreRevenue);

  @override
  String toString() {
    return 'TodaySalesSummary(orderCount: $orderCount, totalRevenue: $totalRevenue, onlineRevenue: $onlineRevenue, inStoreRevenue: $inStoreRevenue)';
  }
}

/// @nodoc
abstract mixin class _$TodaySalesSummaryCopyWith<$Res>
    implements $TodaySalesSummaryCopyWith<$Res> {
  factory _$TodaySalesSummaryCopyWith(
          _TodaySalesSummary value, $Res Function(_TodaySalesSummary) _then) =
      __$TodaySalesSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'order_count') int orderCount,
      @JsonKey(name: 'total_revenue') double totalRevenue,
      @JsonKey(name: 'online_revenue') double onlineRevenue,
      @JsonKey(name: 'in_store_revenue') double inStoreRevenue});
}

/// @nodoc
class __$TodaySalesSummaryCopyWithImpl<$Res>
    implements _$TodaySalesSummaryCopyWith<$Res> {
  __$TodaySalesSummaryCopyWithImpl(this._self, this._then);

  final _TodaySalesSummary _self;
  final $Res Function(_TodaySalesSummary) _then;

  /// Create a copy of TodaySalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? orderCount = null,
    Object? totalRevenue = null,
    Object? onlineRevenue = null,
    Object? inStoreRevenue = null,
  }) {
    return _then(_TodaySalesSummary(
      orderCount: null == orderCount
          ? _self.orderCount
          : orderCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _self.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      onlineRevenue: null == onlineRevenue
          ? _self.onlineRevenue
          : onlineRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      inStoreRevenue: null == inStoreRevenue
          ? _self.inStoreRevenue
          : inStoreRevenue // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
