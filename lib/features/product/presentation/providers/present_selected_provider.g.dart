// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'present_selected_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PresentSelectedItems)
const presentSelectedItemsProvider = PresentSelectedItemsProvider._();

final class PresentSelectedItemsProvider extends $NotifierProvider<
    PresentSelectedItems, Map<String, VariantDetail>> {
  const PresentSelectedItemsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'presentSelectedItemsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$presentSelectedItemsHash();

  @$internal
  @override
  PresentSelectedItems create() => PresentSelectedItems();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, VariantDetail> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, VariantDetail>>(value),
    );
  }
}

String _$presentSelectedItemsHash() =>
    r'8d59311aeeac8b08bbef6700420f0fbb5bc3b202';

abstract class _$PresentSelectedItems
    extends $Notifier<Map<String, VariantDetail>> {
  Map<String, VariantDetail> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref
        as $Ref<Map<String, VariantDetail>, Map<String, VariantDetail>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Map<String, VariantDetail>, Map<String, VariantDetail>>,
        Map<String, VariantDetail>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
