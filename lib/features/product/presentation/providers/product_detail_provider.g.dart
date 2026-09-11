// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getProductDetailUseCase)
const getProductDetailUseCaseProvider = GetProductDetailUseCaseProvider._();

final class GetProductDetailUseCaseProvider extends $FunctionalProvider<
    GetProductDetail,
    GetProductDetail,
    GetProductDetail> with $Provider<GetProductDetail> {
  const GetProductDetailUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getProductDetailUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getProductDetailUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetProductDetail> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetProductDetail create(Ref ref) {
    return getProductDetailUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetProductDetail value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetProductDetail>(value),
    );
  }
}

String _$getProductDetailUseCaseHash() =>
    r'c7c945aa6bc7948524aeb6c2a63e382fe49d1dbe';

/// Provides a single product's full detail (with variants + images).
///
/// Uses `.family` so each product id gets its own cached state.
/// Uses `.autoDispose` so the state is cleared when no widget is listening.

@ProviderFor(productDetail)
const productDetailProvider = ProductDetailFamily._();

/// Provides a single product's full detail (with variants + images).
///
/// Uses `.family` so each product id gets its own cached state.
/// Uses `.autoDispose` so the state is cleared when no widget is listening.

final class ProductDetailProvider
    extends $FunctionalProvider<AsyncValue<Product>, Product, FutureOr<Product>>
    with $FutureModifier<Product>, $FutureProvider<Product> {
  /// Provides a single product's full detail (with variants + images).
  ///
  /// Uses `.family` so each product id gets its own cached state.
  /// Uses `.autoDispose` so the state is cleared when no widget is listening.
  const ProductDetailProvider._(
      {required ProductDetailFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'productDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productDetailHash();

  @override
  String toString() {
    return r'productDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product> create(Ref ref) {
    final argument = this.argument as String;
    return productDetail(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDetailHash() => r'013a6e22d99cf890bee9e02c65f1bbf6f8806d2e';

/// Provides a single product's full detail (with variants + images).
///
/// Uses `.family` so each product id gets its own cached state.
/// Uses `.autoDispose` so the state is cleared when no widget is listening.

final class ProductDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product>, String> {
  const ProductDetailFamily._()
      : super(
          retry: null,
          name: r'productDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provides a single product's full detail (with variants + images).
  ///
  /// Uses `.family` so each product id gets its own cached state.
  /// Uses `.autoDispose` so the state is cleared when no widget is listening.

  ProductDetailProvider call(
    String productId,
  ) =>
      ProductDetailProvider._(argument: productId, from: this);

  @override
  String toString() => r'productDetailProvider';
}
