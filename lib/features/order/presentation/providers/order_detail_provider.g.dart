// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getOrderDetailUseCase)
const getOrderDetailUseCaseProvider = GetOrderDetailUseCaseProvider._();

final class GetOrderDetailUseCaseProvider
    extends $FunctionalProvider<GetOrderDetail, GetOrderDetail, GetOrderDetail>
    with $Provider<GetOrderDetail> {
  const GetOrderDetailUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getOrderDetailUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getOrderDetailUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetOrderDetail> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetOrderDetail create(Ref ref) {
    return getOrderDetailUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetOrderDetail value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetOrderDetail>(value),
    );
  }
}

String _$getOrderDetailUseCaseHash() =>
    r'9e526506828a0da5f65b38978de43fa497586550';

@ProviderFor(updateOrderStatusUseCase)
const updateOrderStatusUseCaseProvider = UpdateOrderStatusUseCaseProvider._();

final class UpdateOrderStatusUseCaseProvider extends $FunctionalProvider<
    UpdateOrderStatus,
    UpdateOrderStatus,
    UpdateOrderStatus> with $Provider<UpdateOrderStatus> {
  const UpdateOrderStatusUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'updateOrderStatusUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$updateOrderStatusUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateOrderStatus> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateOrderStatus create(Ref ref) {
    return updateOrderStatusUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateOrderStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateOrderStatus>(value),
    );
  }
}

String _$updateOrderStatusUseCaseHash() =>
    r'9c986998a0afb95eb225c2f30fef2a599cec8725';

@ProviderFor(cancelOrderUseCase)
const cancelOrderUseCaseProvider = CancelOrderUseCaseProvider._();

final class CancelOrderUseCaseProvider
    extends $FunctionalProvider<CancelOrder, CancelOrder, CancelOrder>
    with $Provider<CancelOrder> {
  const CancelOrderUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cancelOrderUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cancelOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<CancelOrder> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CancelOrder create(Ref ref) {
    return cancelOrderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CancelOrder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CancelOrder>(value),
    );
  }
}

String _$cancelOrderUseCaseHash() =>
    r'2ed5abde3b92311bf6f3eaee8ccfb70fb49f5e60';

/// Provides a single order's detail — family + autoDispose.

@ProviderFor(OrderDetail)
const orderDetailProvider = OrderDetailFamily._();

/// Provides a single order's detail — family + autoDispose.
final class OrderDetailProvider
    extends $AsyncNotifierProvider<OrderDetail, Order> {
  /// Provides a single order's detail — family + autoDispose.
  const OrderDetailProvider._(
      {required OrderDetailFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'orderDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$orderDetailHash();

  @override
  String toString() {
    return r'orderDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  OrderDetail create() => OrderDetail();

  @override
  bool operator ==(Object other) {
    return other is OrderDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderDetailHash() => r'f960b303c8115a5def97cea8abe0587ccb409e9a';

/// Provides a single order's detail — family + autoDispose.

final class OrderDetailFamily extends $Family
    with
        $ClassFamilyOverride<OrderDetail, AsyncValue<Order>, Order,
            FutureOr<Order>, String> {
  const OrderDetailFamily._()
      : super(
          retry: null,
          name: r'orderDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provides a single order's detail — family + autoDispose.

  OrderDetailProvider call(
    String orderId,
  ) =>
      OrderDetailProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderDetailProvider';
}

/// Provides a single order's detail — family + autoDispose.

abstract class _$OrderDetail extends $AsyncNotifier<Order> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  FutureOr<Order> build(
    String orderId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<Order>, Order>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Order>, Order>,
        AsyncValue<Order>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
