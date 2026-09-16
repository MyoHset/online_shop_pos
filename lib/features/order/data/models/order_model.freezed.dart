// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderModel {
  String get id;
  String? get shopId;
  String? get customerName;
  String? get customerPhone;
  String? get customerAddress;
  String get status;
  double get totalAmount;
  String get orderType;
  DateTime get createdAt;
  DateTime get updatedAt;
  List<OrderItemModel> get orderItems;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderModelCopyWith<OrderModel> get copyWith =>
      _$OrderModelCopyWithImpl<OrderModel>(this as OrderModel, _$identity);

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderModel &&
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
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other.orderItems, orderItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(orderItems));

  @override
  String toString() {
    return 'OrderModel(id: $id, shopId: $shopId, customerName: $customerName, customerPhone: $customerPhone, customerAddress: $customerAddress, status: $status, totalAmount: $totalAmount, orderType: $orderType, createdAt: $createdAt, updatedAt: $updatedAt, orderItems: $orderItems)';
  }
}

/// @nodoc
abstract mixin class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) _then) =
      _$OrderModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? shopId,
      String? customerName,
      String? customerPhone,
      String? customerAddress,
      String status,
      double totalAmount,
      String orderType,
      DateTime createdAt,
      DateTime updatedAt,
      List<OrderItemModel> orderItems});
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res> implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._self, this._then);

  final OrderModel _self;
  final $Res Function(OrderModel) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerAddress = freezed,
    Object? status = null,
    Object? totalAmount = null,
    Object? orderType = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? orderItems = null,
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
      customerName: freezed == customerName
          ? _self.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
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
              as String,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      orderItems: null == orderItems
          ? _self.orderItems
          : orderItems // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
    ));
  }
}

/// Adds pattern-matching-related methods to [OrderModel].
extension OrderModelPatterns on OrderModel {
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
    TResult Function(_OrderModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
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
    TResult Function(_OrderModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel():
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
    TResult? Function(_OrderModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
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
            String? customerName,
            String? customerPhone,
            String? customerAddress,
            String status,
            double totalAmount,
            String orderType,
            DateTime createdAt,
            DateTime updatedAt,
            List<OrderItemModel> orderItems)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
        return $default(
            _that.id,
            _that.shopId,
            _that.customerName,
            _that.customerPhone,
            _that.customerAddress,
            _that.status,
            _that.totalAmount,
            _that.orderType,
            _that.createdAt,
            _that.updatedAt,
            _that.orderItems);
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
            String? customerName,
            String? customerPhone,
            String? customerAddress,
            String status,
            double totalAmount,
            String orderType,
            DateTime createdAt,
            DateTime updatedAt,
            List<OrderItemModel> orderItems)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel():
        return $default(
            _that.id,
            _that.shopId,
            _that.customerName,
            _that.customerPhone,
            _that.customerAddress,
            _that.status,
            _that.totalAmount,
            _that.orderType,
            _that.createdAt,
            _that.updatedAt,
            _that.orderItems);
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
            String? customerName,
            String? customerPhone,
            String? customerAddress,
            String status,
            double totalAmount,
            String orderType,
            DateTime createdAt,
            DateTime updatedAt,
            List<OrderItemModel> orderItems)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderModel() when $default != null:
        return $default(
            _that.id,
            _that.shopId,
            _that.customerName,
            _that.customerPhone,
            _that.customerAddress,
            _that.status,
            _that.totalAmount,
            _that.orderType,
            _that.createdAt,
            _that.updatedAt,
            _that.orderItems);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _OrderModel extends OrderModel {
  const _OrderModel(
      {required this.id,
      this.shopId,
      this.customerName,
      required this.customerPhone,
      required this.customerAddress,
      required this.status,
      required this.totalAmount,
      this.orderType = 'online',
      required this.createdAt,
      required this.updatedAt,
      final List<OrderItemModel> orderItems = const []})
      : _orderItems = orderItems,
        super._();
  factory _OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  @override
  final String id;
  @override
  final String? shopId;
  @override
  final String? customerName;
  @override
  final String? customerPhone;
  @override
  final String? customerAddress;
  @override
  final String status;
  @override
  final double totalAmount;
  @override
  @JsonKey()
  final String orderType;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<OrderItemModel> _orderItems;
  @override
  @JsonKey()
  List<OrderItemModel> get orderItems {
    if (_orderItems is EqualUnmodifiableListView) return _orderItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderItems);
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderModelCopyWith<_OrderModel> get copyWith =>
      __$OrderModelCopyWithImpl<_OrderModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderModel &&
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
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._orderItems, _orderItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_orderItems));

  @override
  String toString() {
    return 'OrderModel(id: $id, shopId: $shopId, customerName: $customerName, customerPhone: $customerPhone, customerAddress: $customerAddress, status: $status, totalAmount: $totalAmount, orderType: $orderType, createdAt: $createdAt, updatedAt: $updatedAt, orderItems: $orderItems)';
  }
}

/// @nodoc
abstract mixin class _$OrderModelCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$OrderModelCopyWith(
          _OrderModel value, $Res Function(_OrderModel) _then) =
      __$OrderModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? shopId,
      String? customerName,
      String? customerPhone,
      String? customerAddress,
      String status,
      double totalAmount,
      String orderType,
      DateTime createdAt,
      DateTime updatedAt,
      List<OrderItemModel> orderItems});
}

/// @nodoc
class __$OrderModelCopyWithImpl<$Res> implements _$OrderModelCopyWith<$Res> {
  __$OrderModelCopyWithImpl(this._self, this._then);

  final _OrderModel _self;
  final $Res Function(_OrderModel) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? shopId = freezed,
    Object? customerName = freezed,
    Object? customerPhone = freezed,
    Object? customerAddress = freezed,
    Object? status = null,
    Object? totalAmount = null,
    Object? orderType = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? orderItems = null,
  }) {
    return _then(_OrderModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: freezed == shopId
          ? _self.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _self.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
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
              as String,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      orderType: null == orderType
          ? _self.orderType
          : orderType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      orderItems: null == orderItems
          ? _self._orderItems
          : orderItems // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
    ));
  }
}

// dart format on
