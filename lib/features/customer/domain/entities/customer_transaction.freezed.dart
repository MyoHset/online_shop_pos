// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerTransaction {
  String get id;
  String get customerId;
  String? get orderId;
  CustomerTransactionType get transactionType;
  double get amount;
  String get paymentMethod;
  double get balanceAfter;
  String? get notes;
  DateTime get createdAt;

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomerTransactionCopyWith<CustomerTransaction> get copyWith =>
      _$CustomerTransactionCopyWithImpl<CustomerTransaction>(
          this as CustomerTransaction, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomerTransaction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, customerId, orderId,
      transactionType, amount, paymentMethod, balanceAfter, notes, createdAt);

  @override
  String toString() {
    return 'CustomerTransaction(id: $id, customerId: $customerId, orderId: $orderId, transactionType: $transactionType, amount: $amount, paymentMethod: $paymentMethod, balanceAfter: $balanceAfter, notes: $notes, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $CustomerTransactionCopyWith<$Res> {
  factory $CustomerTransactionCopyWith(
          CustomerTransaction value, $Res Function(CustomerTransaction) _then) =
      _$CustomerTransactionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String customerId,
      String? orderId,
      CustomerTransactionType transactionType,
      double amount,
      String paymentMethod,
      double balanceAfter,
      String? notes,
      DateTime createdAt});
}

/// @nodoc
class _$CustomerTransactionCopyWithImpl<$Res>
    implements $CustomerTransactionCopyWith<$Res> {
  _$CustomerTransactionCopyWithImpl(this._self, this._then);

  final CustomerTransaction _self;
  final $Res Function(CustomerTransaction) _then;

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? orderId = freezed,
    Object? transactionType = null,
    Object? amount = null,
    Object? paymentMethod = null,
    Object? balanceAfter = null,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionType: null == transactionType
          ? _self.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as CustomerTransactionType,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      balanceAfter: null == balanceAfter
          ? _self.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [CustomerTransaction].
extension CustomerTransactionPatterns on CustomerTransaction {
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
    TResult Function(_CustomerTransaction value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CustomerTransaction() when $default != null:
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
    TResult Function(_CustomerTransaction value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomerTransaction():
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
    TResult? Function(_CustomerTransaction value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomerTransaction() when $default != null:
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
            String customerId,
            String? orderId,
            CustomerTransactionType transactionType,
            double amount,
            String paymentMethod,
            double balanceAfter,
            String? notes,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CustomerTransaction() when $default != null:
        return $default(
            _that.id,
            _that.customerId,
            _that.orderId,
            _that.transactionType,
            _that.amount,
            _that.paymentMethod,
            _that.balanceAfter,
            _that.notes,
            _that.createdAt);
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
            String customerId,
            String? orderId,
            CustomerTransactionType transactionType,
            double amount,
            String paymentMethod,
            double balanceAfter,
            String? notes,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomerTransaction():
        return $default(
            _that.id,
            _that.customerId,
            _that.orderId,
            _that.transactionType,
            _that.amount,
            _that.paymentMethod,
            _that.balanceAfter,
            _that.notes,
            _that.createdAt);
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
            String customerId,
            String? orderId,
            CustomerTransactionType transactionType,
            double amount,
            String paymentMethod,
            double balanceAfter,
            String? notes,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomerTransaction() when $default != null:
        return $default(
            _that.id,
            _that.customerId,
            _that.orderId,
            _that.transactionType,
            _that.amount,
            _that.paymentMethod,
            _that.balanceAfter,
            _that.notes,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CustomerTransaction implements CustomerTransaction {
  const _CustomerTransaction(
      {required this.id,
      required this.customerId,
      this.orderId,
      required this.transactionType,
      required this.amount,
      required this.paymentMethod,
      required this.balanceAfter,
      this.notes,
      required this.createdAt});

  @override
  final String id;
  @override
  final String customerId;
  @override
  final String? orderId;
  @override
  final CustomerTransactionType transactionType;
  @override
  final double amount;
  @override
  final String paymentMethod;
  @override
  final double balanceAfter;
  @override
  final String? notes;
  @override
  final DateTime createdAt;

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CustomerTransactionCopyWith<_CustomerTransaction> get copyWith =>
      __$CustomerTransactionCopyWithImpl<_CustomerTransaction>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CustomerTransaction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.balanceAfter, balanceAfter) ||
                other.balanceAfter == balanceAfter) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, customerId, orderId,
      transactionType, amount, paymentMethod, balanceAfter, notes, createdAt);

  @override
  String toString() {
    return 'CustomerTransaction(id: $id, customerId: $customerId, orderId: $orderId, transactionType: $transactionType, amount: $amount, paymentMethod: $paymentMethod, balanceAfter: $balanceAfter, notes: $notes, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$CustomerTransactionCopyWith<$Res>
    implements $CustomerTransactionCopyWith<$Res> {
  factory _$CustomerTransactionCopyWith(_CustomerTransaction value,
          $Res Function(_CustomerTransaction) _then) =
      __$CustomerTransactionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String customerId,
      String? orderId,
      CustomerTransactionType transactionType,
      double amount,
      String paymentMethod,
      double balanceAfter,
      String? notes,
      DateTime createdAt});
}

/// @nodoc
class __$CustomerTransactionCopyWithImpl<$Res>
    implements _$CustomerTransactionCopyWith<$Res> {
  __$CustomerTransactionCopyWithImpl(this._self, this._then);

  final _CustomerTransaction _self;
  final $Res Function(_CustomerTransaction) _then;

  /// Create a copy of CustomerTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? orderId = freezed,
    Object? transactionType = null,
    Object? amount = null,
    Object? paymentMethod = null,
    Object? balanceAfter = null,
    Object? notes = freezed,
    Object? createdAt = null,
  }) {
    return _then(_CustomerTransaction(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionType: null == transactionType
          ? _self.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as CustomerTransactionType,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      balanceAfter: null == balanceAfter
          ? _self.balanceAfter
          : balanceAfter // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
