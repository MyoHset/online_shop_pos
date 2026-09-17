// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_brands_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productBrands)
const productBrandsProvider = ProductBrandsProvider._();

final class ProductBrandsProvider extends $FunctionalProvider<
        AsyncValue<List<String>>, List<String>, FutureOr<List<String>>>
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  const ProductBrandsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productBrandsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productBrandsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return productBrands(ref);
  }
}

String _$productBrandsHash() => r'3dd59997097ac3e9d9159d84d8f3275af507c996';
