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
        String? category,
        String search,
      }) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<
          ({
            String? category,
            String search,
          })>(value),
    );
  }
}

String _$quickSaleFilterHash() => r'7b78e7926ce35fb1ae448ce99b8e228a84c89deb';

abstract class _$QuickSaleFilter extends $Notifier<
    ({
      String? category,
      String search,
    })> {
  ({
    String? category,
    String search,
  }) build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<
        ({
          String? category,
          String search,
        }),
        ({
          String? category,
          String search,
        })>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<
            ({
              String? category,
              String search,
            }),
            ({
              String? category,
              String search,
            })>,
        ({
          String? category,
          String search,
        }),
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
