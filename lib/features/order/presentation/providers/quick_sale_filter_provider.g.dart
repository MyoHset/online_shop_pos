// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_sale_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuickSaleFilter)
const quickSaleFilterProvider = QuickSaleFilterProvider._();

final class QuickSaleFilterProvider extends $NotifierProvider<
    QuickSaleFilter,
    ({
      String? brand,
      String? category,
      String search,
    })> {
  const QuickSaleFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'quickSaleFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$quickSaleFilterHash();

  @$internal
  @override
  QuickSaleFilter create() => QuickSaleFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
      ({
        String? brand,
        String? category,
        String search,
      }) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<
          ({
            String? brand,
            String? category,
            String search,
          })>(value),
    );
  }
}

String _$quickSaleFilterHash() => r'2a97ef1152ffc608fd56aa23361de8e939a1cd3d';

abstract class _$QuickSaleFilter extends $Notifier<
    ({
      String? brand,
      String? category,
      String search,
    })> {
  ({
    String? brand,
    String? category,
    String search,
  }) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<
        ({
          String? brand,
          String? category,
          String search,
        }),
        ({
          String? brand,
          String? category,
          String search,
        })>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<
            ({
              String? brand,
              String? category,
              String search,
            }),
            ({
              String? brand,
              String? category,
              String search,
            })>,
        ({
          String? brand,
          String? category,
          String search,
        }),
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
