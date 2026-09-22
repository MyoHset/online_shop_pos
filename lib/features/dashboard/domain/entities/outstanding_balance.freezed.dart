// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outstanding_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OutstandingBalance {
  @JsonKey(name: 'order_id')
  String get orderId;
  @JsonKey(name: 'order_number')
  String get orderNumber;
  @JsonKey(name: 'customer_name')
  String? get customerName;
  @JsonKey(name: 'balance_due')
  double get balanceDue;

  /// Create a copy of OutstandingBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OutstandingBalanceCopyWith<OutstandingBalance> get copyWith =>
      _$OutstandingBalanceCopyWithImpl<OutstandingBalance>(
          this as OutstandingBalance, _$identity);

  /// Serializes this OutstandingBalance to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OutstandingBalance &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.balanceDue, balanceDue) ||
                other.balanceDue == balanceDue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, orderId, orderNumber, customerName, balanceDue);

  @override
  String toString() {
    return 'OutstandingBalance(orderId: $orderId, orderNumber: $orderNumber, customerName: $customerName, balanceDue: $balanceDue)';
  }
}

/// @nodoc
abstract mixin class $OutstandingBalanceCopyWith<$Res> {
  factory $OutstandingBalanceCopyWith(
          OutstandingBalance value, $Res Function(OutstandingBalance) _then) =
      _$OutstandingBalanceCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'order_id') String orderId,
      @JsonKey(name: 'order_number') String orderNumber,
      @JsonKey(name: 'customer_name') String? customerName,
      @JsonKey(name: 'balance_due') double balanceDue});
}

/// @nodoc
class _$OutstandingBalanceCopyWithImpl<$Res>
    implements $OutstandingBalanceCopyWith<$Res> {
  _$OutstandingBalanceCopyWithImpl(this._self, this._then);

  final OutstandingBalance _self;
  final $Res Function(OutstandingBalance) _then;

  /// Create a copy of OutstandingBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? orderNumber = null,
    Object? customerName = freezed,
    Object? balanceDue = null,
  }) {
    return _then(_self.copyWith(
      orderId: null == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _self.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _self.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      balanceDue: null == balanceDue
          ? _self.balanceDue
          : balanceDue // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [OutstandingBalance].
extension OutstandingBalancePatterns on OutstandingBalance {
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
    TResult Function(_OutstandingBalance value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OutstandingBalance() when $default != null:
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
    TResult Function(_OutstandingBalance value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OutstandingBalance():
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
    TResult? Function(_OutstandingBalance value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OutstandingBalance() when $default != null:
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
            @JsonKey(name: 'order_id') String orderId,
            @JsonKey(name: 'order_number') String orderNumber,
            @JsonKey(name: 'customer_name') String? customerName,
            @JsonKey(name: 'balance_due') double balanceDue)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OutstandingBalance() when $default != null:
        return $default(_that.orderId, _that.orderNumber, _that.customerName,
            _that.balanceDue);
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
            @JsonKey(name: 'order_id') String orderId,
            @JsonKey(name: 'order_number') String orderNumber,
            @JsonKey(name: 'customer_name') String? customerName,
            @JsonKey(name: 'balance_due') double balanceDue)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OutstandingBalance():
        return $default(_that.orderId, _that.orderNumber, _that.customerName,
            _that.balanceDue);
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
            @JsonKey(name: 'order_id') String orderId,
            @JsonKey(name: 'order_number') String orderNumber,
            @JsonKey(name: 'customer_name') String? customerName,
            @JsonKey(name: 'balance_due') double balanceDue)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OutstandingBalance() when $default != null:
        return $default(_that.orderId, _that.orderNumber, _that.customerName,
            _that.balanceDue);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _OutstandingBalance implements OutstandingBalance {
  const _OutstandingBalance(
      {@JsonKey(name: 'order_id') required this.orderId,
      @JsonKey(name: 'order_number') required this.orderNumber,
      @JsonKey(name: 'customer_name') this.customerName,
      @JsonKey(name: 'balance_due') this.balanceDue = 0.0});
  factory _OutstandingBalance.fromJson(Map<String, dynamic> json) =>
      _$OutstandingBalanceFromJson(json);

  @override
  @JsonKey(name: 'order_id')
  final String orderId;
  @override
  @JsonKey(name: 'order_number')
  final String orderNumber;
  @override
  @JsonKey(name: 'customer_name')
  final String? customerName;
  @override
  @JsonKey(name: 'balance_due')
  final double balanceDue;

  /// Create a copy of OutstandingBalance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OutstandingBalanceCopyWith<_OutstandingBalance> get copyWith =>
      __$OutstandingBalanceCopyWithImpl<_OutstandingBalance>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OutstandingBalanceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OutstandingBalance &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.balanceDue, balanceDue) ||
                other.balanceDue == balanceDue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, orderId, orderNumber, customerName, balanceDue);

  @override
  String toString() {
    return 'OutstandingBalance(orderId: $orderId, orderNumber: $orderNumber, customerName: $customerName, balanceDue: $balanceDue)';
  }
}

/// @nodoc
abstract mixin class _$OutstandingBalanceCopyWith<$Res>
    implements $OutstandingBalanceCopyWith<$Res> {
  factory _$OutstandingBalanceCopyWith(
          _OutstandingBalance value, $Res Function(_OutstandingBalance) _then) =
      __$OutstandingBalanceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'order_id') String orderId,
      @JsonKey(name: 'order_number') String orderNumber,
      @JsonKey(name: 'customer_name') String? customerName,
      @JsonKey(name: 'balance_due') double balanceDue});
}

/// @nodoc
class __$OutstandingBalanceCopyWithImpl<$Res>
    implements _$OutstandingBalanceCopyWith<$Res> {
  __$OutstandingBalanceCopyWithImpl(this._self, this._then);

  final _OutstandingBalance _self;
  final $Res Function(_OutstandingBalance) _then;

  /// Create a copy of OutstandingBalance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? orderId = null,
    Object? orderNumber = null,
    Object? customerName = freezed,
    Object? balanceDue = null,
  }) {
    return _then(_OutstandingBalance(
      orderId: null == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      orderNumber: null == orderNumber
          ? _self.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: freezed == customerName
          ? _self.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      balanceDue: null == balanceDue
          ? _self.balanceDue
          : balanceDue // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
