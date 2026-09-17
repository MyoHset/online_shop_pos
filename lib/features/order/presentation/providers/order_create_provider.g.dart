// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_create_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(createOrderUseCase)
const createOrderUseCaseProvider = CreateOrderUseCaseProvider._();

final class CreateOrderUseCaseProvider
    extends $FunctionalProvider<CreateOrder, CreateOrder, CreateOrder>
    with $Provider<CreateOrder> {
  const CreateOrderUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'createOrderUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$createOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateOrder> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateOrder create(Ref ref) {
    return createOrderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateOrder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateOrder>(value),
    );
  }
}

String _$createOrderUseCaseHash() =>
    r'e52bdb5e73916a9ef819078fba0070752cf21558';

@ProviderFor(orderCreateProductList)
const orderCreateProductListProvider = OrderCreateProductListProvider._();

final class OrderCreateProductListProvider extends $FunctionalProvider<
        AsyncValue<List<Product>>, List<Product>, FutureOr<List<Product>>>
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const OrderCreateProductListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'orderCreateProductListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$orderCreateProductListHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    return orderCreateProductList(ref);
  }
}

String _$orderCreateProductListHash() =>
    r'7eda5f161f0490bf5bcf0c7218c7ad40482e24c0';

/// Manages the order creation flow state.

@ProviderFor(OrderCreate)
const orderCreateProvider = OrderCreateProvider._();

/// Manages the order creation flow state.
final class OrderCreateProvider
    extends $NotifierProvider<OrderCreate, OrderCreateState> {
  /// Manages the order creation flow state.
  const OrderCreateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'orderCreateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$orderCreateHash();

  @$internal
  @override
  OrderCreate create() => OrderCreate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderCreateState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderCreateState>(value),
    );
  }
}

String _$orderCreateHash() => r'2ca3112ed374b17e51caaa73de3d5898fbee9020';

/// Manages the order creation flow state.

abstract class _$OrderCreate extends $Notifier<OrderCreateState> {
  OrderCreateState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OrderCreateState, OrderCreateState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<OrderCreateState, OrderCreateState>,
        OrderCreateState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
