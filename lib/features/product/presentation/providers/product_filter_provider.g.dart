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

String _$productFilterHash() => r'2d15a9a79d6d0fcc4ac81edab14c1a16ba0e6d5a';

abstract class _$ProductFilter extends $Notifier<
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
