// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerModel {
  String get id;
  String? get shopId;
  String get name;
  String get phone;
  String? get address;
  double get creditLimit;
  double get currentDebt;
  String get repaymentCycle;
  String? get notes;
  bool get isSuspended;
  String? get suspendedReason;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of CustomerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<CustomerModel> get copyWith =>
      _$CustomerModelCopyWithImpl<CustomerModel>(
          this as CustomerModel, _$identity);

  /// Serializes this CustomerModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomerModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit) &&
            (identical(other.currentDebt, currentDebt) ||
                other.currentDebt == currentDebt) &&
            (identical(other.repaymentCycle, repaymentCycle) ||
                other.repaymentCycle == repaymentCycle) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isSuspended, isSuspended) ||
                other.isSuspended == isSuspended) &&
            (identical(other.suspendedReason, suspendedReason) ||
                other.suspendedReason == suspendedReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      shopId,
      name,
      phone,
      address,
      creditLimit,
      currentDebt,
      repaymentCycle,
      notes,
      isSuspended,
      suspendedReason,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'CustomerModel(id: $id, shopId: $shopId, name: $name, phone: $phone, address: $address, creditLimit: $creditLimit, currentDebt: $currentDebt, repaymentCycle: $repaymentCycle, notes: $notes, isSuspended: $isSuspended, suspendedReason: $suspendedReason, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $CustomerModelCopyWith<$Res> {
  factory $CustomerModelCopyWith(
          CustomerModel value, $Res Function(CustomerModel) _then) =
      _$CustomerModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? shopId,
      String name,
      String phone,
      String? address,
      double creditLimit,
      double currentDebt,
      String repaymentCycle,
      String? notes,
      bool isSuspended,
      String? suspendedReason,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$CustomerModelCopyWithImpl<$Res>
    implements $CustomerModelCopyWith<$Res> {
  _$CustomerModelCopyWithImpl(this._self, this._then);

  final CustomerModel _self;
  final $Res Function(CustomerModel) _then;

  /// Create a copy of CustomerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = freezed,
    Object? name = null,
    Object? phone = null,
    Object? address = freezed,
    Object? creditLimit = null,
    Object? currentDebt = null,
    Object? repaymentCycle = null,
    Object? notes = freezed,
    Object? isSuspended = null,
    Object? suspendedReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      creditLimit: null == creditLimit
          ? _self.creditLimit
          : creditLimit // ignore: cast_nullable_to_non_nullable
              as double,
      currentDebt: null == currentDebt
          ? _self.currentDebt
          : currentDebt // ignore: cast_nullable_to_non_nullable
              as double,
      repaymentCycle: null == repaymentCycle
          ? _self.repaymentCycle
          : repaymentCycle // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isSuspended: null == isSuspended
          ? _self.isSuspended
          : isSuspended // ignore: cast_nullable_to_non_nullable
              as bool,
      suspendedReason: freezed == suspendedReason
          ? _self.suspendedReason
          : suspendedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [CustomerModel].
extension CustomerModelPatterns on CustomerModel {
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
    TResult Function(_CustomerModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CustomerModel() when $default != null:
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
    TResult Function(_CustomerModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomerModel():
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
    TResult? Function(_CustomerModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomerModel() when $default != null:
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
            String phone,
            String? address,
            double creditLimit,
            double currentDebt,
            String repaymentCycle,
            String? notes,
            bool isSuspended,
            String? suspendedReason,
            DateTime createdAt,
            DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CustomerModel() when $default != null:
        return $default(
            _that.id,
            _that.shopId,
            _that.name,
            _that.phone,
            _that.address,
            _that.creditLimit,
            _that.currentDebt,
            _that.repaymentCycle,
            _that.notes,
            _that.isSuspended,
            _that.suspendedReason,
            _that.createdAt,
            _that.updatedAt);
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
            String phone,
            String? address,
            double creditLimit,
            double currentDebt,
            String repaymentCycle,
            String? notes,
            bool isSuspended,
            String? suspendedReason,
            DateTime createdAt,
            DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomerModel():
        return $default(
            _that.id,
            _that.shopId,
            _that.name,
            _that.phone,
            _that.address,
            _that.creditLimit,
            _that.currentDebt,
            _that.repaymentCycle,
            _that.notes,
            _that.isSuspended,
            _that.suspendedReason,
            _that.createdAt,
            _that.updatedAt);
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
            String phone,
            String? address,
            double creditLimit,
            double currentDebt,
            String repaymentCycle,
            String? notes,
            bool isSuspended,
            String? suspendedReason,
            DateTime createdAt,
            DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CustomerModel() when $default != null:
        return $default(
            _that.id,
            _that.shopId,
            _that.name,
            _that.phone,
            _that.address,
            _that.creditLimit,
            _that.currentDebt,
            _that.repaymentCycle,
            _that.notes,
            _that.isSuspended,
            _that.suspendedReason,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CustomerModel extends CustomerModel {
  const _CustomerModel(
      {required this.id,
      this.shopId,
      required this.name,
      required this.phone,
      this.address,
      this.creditLimit = 0.0,
      this.currentDebt = 0.0,
      this.repaymentCycle = 'monthly',
      this.notes,
      this.isSuspended = false,
      this.suspendedReason,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  factory _CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  @override
  final String id;
  @override
  final String? shopId;
  @override
  final String name;
  @override
  final String phone;
  @override
  final String? address;
  @override
  @JsonKey()
  final double creditLimit;
  @override
  @JsonKey()
  final double currentDebt;
  @override
  @JsonKey()
  final String repaymentCycle;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isSuspended;
  @override
  final String? suspendedReason;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of CustomerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CustomerModelCopyWith<_CustomerModel> get copyWith =>
      __$CustomerModelCopyWithImpl<_CustomerModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CustomerModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CustomerModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit) &&
            (identical(other.currentDebt, currentDebt) ||
                other.currentDebt == currentDebt) &&
            (identical(other.repaymentCycle, repaymentCycle) ||
                other.repaymentCycle == repaymentCycle) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isSuspended, isSuspended) ||
                other.isSuspended == isSuspended) &&
            (identical(other.suspendedReason, suspendedReason) ||
                other.suspendedReason == suspendedReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      shopId,
      name,
      phone,
      address,
      creditLimit,
      currentDebt,
      repaymentCycle,
      notes,
      isSuspended,
      suspendedReason,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'CustomerModel(id: $id, shopId: $shopId, name: $name, phone: $phone, address: $address, creditLimit: $creditLimit, currentDebt: $currentDebt, repaymentCycle: $repaymentCycle, notes: $notes, isSuspended: $isSuspended, suspendedReason: $suspendedReason, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$CustomerModelCopyWith<$Res>
    implements $CustomerModelCopyWith<$Res> {
  factory _$CustomerModelCopyWith(
          _CustomerModel value, $Res Function(_CustomerModel) _then) =
      __$CustomerModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? shopId,
      String name,
      String phone,
      String? address,
      double creditLimit,
      double currentDebt,
      String repaymentCycle,
      String? notes,
      bool isSuspended,
      String? suspendedReason,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$CustomerModelCopyWithImpl<$Res>
    implements _$CustomerModelCopyWith<$Res> {
  __$CustomerModelCopyWithImpl(this._self, this._then);

  final _CustomerModel _self;
  final $Res Function(_CustomerModel) _then;

  /// Create a copy of CustomerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? shopId = freezed,
    Object? name = null,
    Object? phone = null,
    Object? address = freezed,
    Object? creditLimit = null,
    Object? currentDebt = null,
    Object? repaymentCycle = null,
    Object? notes = freezed,
    Object? isSuspended = null,
    Object? suspendedReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_CustomerModel(
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
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      creditLimit: null == creditLimit
          ? _self.creditLimit
          : creditLimit // ignore: cast_nullable_to_non_nullable
              as double,
      currentDebt: null == currentDebt
          ? _self.currentDebt
          : currentDebt // ignore: cast_nullable_to_non_nullable
              as double,
      repaymentCycle: null == repaymentCycle
          ? _self.repaymentCycle
          : repaymentCycle // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isSuspended: null == isSuspended
          ? _self.isSuspended
          : isSuspended // ignore: cast_nullable_to_non_nullable
              as bool,
      suspendedReason: freezed == suspendedReason
          ? _self.suspendedReason
          : suspendedReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
