// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_order_provider.dart';

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
    r'9dc9764568689eb0d127e347722730c47a52609f';

@ProviderFor(onlineOrderProductList)
const onlineOrderProductListProvider = OnlineOrderProductListProvider._();

final class OnlineOrderProductListProvider extends $FunctionalProvider<
        AsyncValue<List<Product>>, List<Product>, FutureOr<List<Product>>>
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const OnlineOrderProductListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'onlineOrderProductListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$onlineOrderProductListHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    return onlineOrderProductList(ref);
  }
}

String _$onlineOrderProductListHash() =>
    r'd4e29ba192b5efa0e1bd8ca0587baa092df8dc6d';

/// Manages the online order creation flow state.

@ProviderFor(OnlineOrder)
const onlineOrderProvider = OnlineOrderProvider._();

/// Manages the online order creation flow state.
final class OnlineOrderProvider
    extends $NotifierProvider<OnlineOrder, OnlineOrderState> {
  /// Manages the online order creation flow state.
  const OnlineOrderProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'onlineOrderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$onlineOrderHash();

  @$internal
  @override
  OnlineOrder create() => OnlineOrder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnlineOrderState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnlineOrderState>(value),
    );
  }
}

String _$onlineOrderHash() => r'2ca3112ed374b17e51caaa73de3d5898fbee9020';

/// Manages the online order creation flow state.

abstract class _$OnlineOrder extends $Notifier<OnlineOrderState> {
  OnlineOrderState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OnlineOrderState, OnlineOrderState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<OnlineOrderState, OnlineOrderState>,
        OnlineOrderState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
