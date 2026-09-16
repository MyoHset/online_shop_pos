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

String _$quickSaleHash() => r'8a9af9c22c3cdcdc9c2bf3d02d14872b92460805';

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
