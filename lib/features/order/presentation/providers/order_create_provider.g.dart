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
    r'9dc9764568689eb0d127e347722730c47a52609f';

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

String _$orderCreateHash() => r'90cbf7b4240bec989b70f79f1a4f490ce3596020';

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
