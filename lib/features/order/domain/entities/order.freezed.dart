// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {
  String get id;
  String? get shopId;
  String get customerName;
  String? get customerPhone;
  String? get customerAddress;
  OrderStatus get status;
  double get totalAmount;
  OrderType get orderType;
  DiscountType get discountType;
  double get discountValue;
  double get discountAmount;
  String? get discountReason;
  DateTime get createdAt;
  DateTime get updatedAt;
  List<OrderItem> get items;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderCopyWith<Order> get copyWith =>
      _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Order &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerAddress, customerAddress) ||
                other.customerAddress == customerAddress) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.discountReason, discountReason) ||
                other.discountReason == discountReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      shopId,
      customerName,
      customerPhone,
      customerAddress,
      status,
      totalAmount,
      orderType,
      discountType,
      discountValue,
      discountAmount,
      discountReason,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(items));

  @override
  String toString() {
    return 'Order(id: $id, shopId: $shopId, customerName: $customerName, customerPhone: $customerPhone, customerAddress: $customerAddress, status: $status, totalAmount: $totalAmount, orderType: $orderType, discountType: $discountType, discountValue: $discountValue, discountAmount: $discountAmount, discountReason: $discountReason, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
  }
}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) =
      _$OrderCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? shopId,
      String customerName,
      String? customerPhone,
      String? customerAddress,
      OrderStatus status,
      double totalAmount,
      OrderType orderType,
      DiscountType discountType,
      double discountValue,
      double discountAmount,
      String? discountReason,
      DateTime createdAt,
      DateTime updatedAt,
      List<OrderItem> items});
}

/// @nodoc
class _$OrderCopyWithImpl<$Res> implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = freezed,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? customerAddress = freezed,
    Object? status = null,
    Object? totalAmount = null,
    Object? orderType = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? discountAmount = null,
    Object? discountReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? items = null,
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
      customerName: null == customerName
          ? _self.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _self.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerAddress: freezed == customerAddress
          ? _self.customerAddress
          : customerAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as OrderType,
      discountType: null == discountType
          ? _self.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as DiscountType,
      discountValue: null == discountValue
          ? _self.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _self.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      discountReason: freezed == discountReason
          ? _self.discountReason
          : discountReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
    ));
  }
}

/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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
    TResult Function(_Order value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
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
    TResult Function(_Order value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order():
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
    TResult? Function(_Order value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
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
            String customerName,
            String? customerPhone,
            String? customerAddress,
            OrderStatus status,
            double totalAmount,
            OrderType orderType,
            DiscountType discountType,
            double discountValue,
            double discountAmount,
            String? discountReason,
            DateTime createdAt,
            DateTime updatedAt,
            List<OrderItem> items)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
        return $default(
            _that.id,
            _that.shopId,
            _that.customerName,
            _that.customerPhone,
            _that.customerAddress,
            _that.status,
            _that.totalAmount,
            _that.orderType,
            _that.discountType,
            _that.discountValue,
            _that.discountAmount,
            _that.discountReason,
            _that.createdAt,
            _that.updatedAt,
            _that.items);
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
            String customerName,
            String? customerPhone,
            String? customerAddress,
            OrderStatus status,
            double totalAmount,
            OrderType orderType,
            DiscountType discountType,
            double discountValue,
            double discountAmount,
            String? discountReason,
            DateTime createdAt,
            DateTime updatedAt,
            List<OrderItem> items)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order():
        return $default(
            _that.id,
            _that.shopId,
            _that.customerName,
            _that.customerPhone,
            _that.customerAddress,
            _that.status,
            _that.totalAmount,
            _that.orderType,
            _that.discountType,
            _that.discountValue,
            _that.discountAmount,
            _that.discountReason,
            _that.createdAt,
            _that.updatedAt,
            _that.items);
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
            String customerName,
            String? customerPhone,
            String? customerAddress,
            OrderStatus status,
            double totalAmount,
            OrderType orderType,
            DiscountType discountType,
            double discountValue,
            double discountAmount,
            String? discountReason,
            DateTime createdAt,
            DateTime updatedAt,
            List<OrderItem> items)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Order() when $default != null:
        return $default(
            _that.id,
            _that.shopId,
            _that.customerName,
            _that.customerPhone,
            _that.customerAddress,
            _that.status,
            _that.totalAmount,
            _that.orderType,
            _that.discountType,
            _that.discountValue,
            _that.discountAmount,
            _that.discountReason,
            _that.createdAt,
            _that.updatedAt,
            _that.items);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Order extends Order {
  const _Order(
      {required this.id,
      this.shopId,
      required this.customerName,
      required this.customerPhone,
      required this.customerAddress,
      required this.status,
      required this.totalAmount,
      required this.orderType,
      this.discountType = DiscountType.none,
      this.discountValue = 0.0,
      this.discountAmount = 0.0,
      this.discountReason,
      required this.createdAt,
      required this.updatedAt,
      final List<OrderItem> items = const []})
      : _items = items,
        super._();

  @override
  final String id;
  @override
  final String? shopId;
  @override
  final String customerName;
  @override
  final String? customerPhone;
  @override
  final String? customerAddress;
  @override
  final OrderStatus status;
  @override
  final double totalAmount;
  @override
  final OrderType orderType;
  @override
  @JsonKey()
  final DiscountType discountType;
  @override
  @JsonKey()
  final double discountValue;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  final String? discountReason;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<OrderItem> _items;
  @override
  @JsonKey()
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderCopyWith<_Order> get copyWith =>
      __$OrderCopyWithImpl<_Order>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Order &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerAddress, customerAddress) ||
                other.customerAddress == customerAddress) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.orderType, orderType) ||
                other.orderType == orderType) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.discountReason, discountReason) ||
                other.discountReason == discountReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      shopId,
      customerName,
      customerPhone,
      customerAddress,
      status,
      totalAmount,
      orderType,
      discountType,
      discountValue,
      discountAmount,
      discountReason,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_items));

  @override
  String toString() {
    return 'Order(id: $id, shopId: $shopId, customerName: $customerName, customerPhone: $customerPhone, customerAddress: $customerAddress, status: $status, totalAmount: $totalAmount, orderType: $orderType, discountType: $discountType, discountValue: $discountValue, discountAmount: $discountAmount, discountReason: $discountReason, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
  }
}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) =
      __$OrderCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? shopId,
      String customerName,
      String? customerPhone,
      String? customerAddress,
      OrderStatus status,
      double totalAmount,
      OrderType orderType,
      DiscountType discountType,
      double discountValue,
      double discountAmount,
      String? discountReason,
      DateTime createdAt,
      DateTime updatedAt,
      List<OrderItem> items});
}

/// @nodoc
class __$OrderCopyWithImpl<$Res> implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? shopId = freezed,
    Object? customerName = null,
    Object? customerPhone = freezed,
    Object? customerAddress = freezed,
    Object? status = null,
    Object? totalAmount = null,
    Object? orderType = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? discountAmount = null,
    Object? discountReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? items = null,
  }) {
    return _then(_Order(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: freezed == shopId
          ? _self.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: null == customerName
          ? _self.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _self.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      customerAddress: freezed == customerAddress
          ? _self.customerAddress
          : customerAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as OrderType,
      discountType: null == discountType
          ? _self.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as DiscountType,
      discountValue: null == discountValue
          ? _self.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _self.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      discountReason: freezed == discountReason
          ? _self.discountReason
          : discountReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
    ));
  }
}

// dart format on
