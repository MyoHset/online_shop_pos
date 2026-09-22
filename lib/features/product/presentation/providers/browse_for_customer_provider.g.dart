// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_for_customer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BrowseFilter)
const browseFilterProvider = BrowseFilterProvider._();

final class BrowseFilterProvider
    extends $NotifierProvider<BrowseFilter, BrowseFilterState> {
  const BrowseFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'browseFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$browseFilterHash();

  @$internal
  @override
  BrowseFilter create() => BrowseFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BrowseFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BrowseFilterState>(value),
    );
  }
}

String _$browseFilterHash() => r'45e9dd6fdf49685fe087e2fcf84b6854bf5260c1';

abstract class _$BrowseFilter extends $Notifier<BrowseFilterState> {
  BrowseFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BrowseFilterState, BrowseFilterState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<BrowseFilterState, BrowseFilterState>,
        BrowseFilterState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(browseResults)
const browseResultsProvider = BrowseResultsProvider._();

final class BrowseResultsProvider extends $FunctionalProvider<
        AsyncValue<List<VariantDetail>>,
        List<VariantDetail>,
        FutureOr<List<VariantDetail>>>
    with
        $FutureModifier<List<VariantDetail>>,
        $FutureProvider<List<VariantDetail>> {
  const BrowseResultsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'browseResultsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$browseResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<VariantDetail>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<VariantDetail>> create(Ref ref) {
    return browseResults(ref);
  }
}

String _$browseResultsHash() => r'e33c5c73c98dc8fb89f9e3cb07429505f0d9b52a';
