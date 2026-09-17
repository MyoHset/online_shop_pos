// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_sale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(completeInstantSaleUseCase)
const completeInstantSaleUseCaseProvider =
    CompleteInstantSaleUseCaseProvider._();

final class CompleteInstantSaleUseCaseProvider extends $FunctionalProvider<
    CompleteInstantSale,
    CompleteInstantSale,
    CompleteInstantSale> with $Provider<CompleteInstantSale> {
  const CompleteInstantSaleUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'completeInstantSaleUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$completeInstantSaleUseCaseHash();

  @$internal
  @override
  $ProviderElement<CompleteInstantSale> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CompleteInstantSale create(Ref ref) {
    return completeInstantSaleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompleteInstantSale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompleteInstantSale>(value),
    );
  }
}

String _$completeInstantSaleUseCaseHash() =>
    r'8d89701691f2b87a66b89d43723d1869f25f92cd';

@ProviderFor(quickSaleProductList)
const quickSaleProductListProvider = QuickSaleProductListProvider._();

final class QuickSaleProductListProvider extends $FunctionalProvider<
        AsyncValue<List<Product>>, List<Product>, FutureOr<List<Product>>>
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const QuickSaleProductListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'quickSaleProductListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$quickSaleProductListHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    return quickSaleProductList(ref);
  }
}

String _$quickSaleProductListHash() =>
    r'045d02a39789f210643525b1a24f4dc466947920';

@ProviderFor(QuickSale)
const quickSaleProvider = QuickSaleProvider._();

final class QuickSaleProvider
    extends $NotifierProvider<QuickSale, QuickSaleState> {
  const QuickSaleProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'quickSaleProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$quickSaleHash();

  @$internal
  @override
  QuickSale create() => QuickSale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QuickSaleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QuickSaleState>(value),
    );
  }
}

String _$quickSaleHash() => r'ff359d2ef427bb27e5cd69b70de1b2c6f9bace2b';

abstract class _$QuickSale extends $Notifier<QuickSaleState> {
  QuickSaleState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<QuickSaleState, QuickSaleState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<QuickSaleState, QuickSaleState>,
        QuickSaleState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
