// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orderRemoteDataSource)
const orderRemoteDataSourceProvider = OrderRemoteDataSourceProvider._();

final class OrderRemoteDataSourceProvider extends $FunctionalProvider<
    OrderRemoteDataSource,
    OrderRemoteDataSource,
    OrderRemoteDataSource> with $Provider<OrderRemoteDataSource> {
  const OrderRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'orderRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$orderRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<OrderRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderRemoteDataSource create(Ref ref) {
    return orderRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderRemoteDataSource>(value),
    );
  }
}

String _$orderRemoteDataSourceHash() =>
    r'6c7587c8a88715f881e10f41f6a3fa7c87d1d95a';

@ProviderFor(orderRepository)
const orderRepositoryProvider = OrderRepositoryProvider._();

final class OrderRepositoryProvider extends $FunctionalProvider<OrderRepository,
    OrderRepository, OrderRepository> with $Provider<OrderRepository> {
  const OrderRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'orderRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$orderRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrderRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderRepository create(Ref ref) {
    return orderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderRepository>(value),
    );
  }
}

String _$orderRepositoryHash() => r'013c5041ca8d69ab35087108ac3f5d35a8a87c75';

@ProviderFor(getOrdersUseCase)
const getOrdersUseCaseProvider = GetOrdersUseCaseProvider._();

final class GetOrdersUseCaseProvider
    extends $FunctionalProvider<GetOrders, GetOrders, GetOrders>
    with $Provider<GetOrders> {
  const GetOrdersUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getOrdersUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getOrdersUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetOrders> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetOrders create(Ref ref) {
    return getOrdersUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetOrders value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetOrders>(value),
    );
  }
}

String _$getOrdersUseCaseHash() => r'31f1726a2fd59bea5388b077a12a1c832d3d4f5d';

/// Provides the order list, optionally filtered by status.

@ProviderFor(OrderList)
const orderListProvider = OrderListProvider._();

/// Provides the order list, optionally filtered by status.
final class OrderListProvider
    extends $AsyncNotifierProvider<OrderList, List<Order>> {
  /// Provides the order list, optionally filtered by status.
  const OrderListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'orderListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$orderListHash();

  @$internal
  @override
  OrderList create() => OrderList();
}

String _$orderListHash() => r'1c6e41a08690ef7cbe9ad6a6ab3ef1a228ae49e4';

/// Provides the order list, optionally filtered by status.

abstract class _$OrderList extends $AsyncNotifier<List<Order>> {
  FutureOr<List<Order>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Order>>, List<Order>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Order>>, List<Order>>,
        AsyncValue<List<Order>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
