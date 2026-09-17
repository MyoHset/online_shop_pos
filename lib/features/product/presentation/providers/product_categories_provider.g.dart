// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_categories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productCategories)
const productCategoriesProvider = ProductCategoriesProvider._();

final class ProductCategoriesProvider extends $FunctionalProvider<
        AsyncValue<List<String>>, List<String>, FutureOr<List<String>>>
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  const ProductCategoriesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productCategoriesProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return productCategories(ref);
  }
}

String _$productCategoriesHash() => r'd939e71a82469b77afbc67f2e992aa6b1d1173b6';
