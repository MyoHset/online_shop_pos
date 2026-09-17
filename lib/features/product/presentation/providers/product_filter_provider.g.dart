// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductFilter)
const productFilterProvider = ProductFilterProvider._();

final class ProductFilterProvider extends $NotifierProvider<
    ProductFilter,
    ({
      String? brand,
      String? category,
      String search,
    })> {
  const ProductFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productFilterHash();

  @$internal
  @override
  ProductFilter create() => ProductFilter();

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

String _$productFilterHash() => r'3048bfd8cd6688e858eb9ac8fc7a3aae7c8122ab';

abstract class _$ProductFilter extends $Notifier<
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
