// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productRemoteDataSource)
const productRemoteDataSourceProvider = ProductRemoteDataSourceProvider._();

final class ProductRemoteDataSourceProvider extends $FunctionalProvider<
    ProductRemoteDataSource,
    ProductRemoteDataSource,
    ProductRemoteDataSource> with $Provider<ProductRemoteDataSource> {
  const ProductRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProductRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProductRemoteDataSource create(Ref ref) {
    return productRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRemoteDataSource>(value),
    );
  }
}

String _$productRemoteDataSourceHash() =>
    r'3d6329cbc3272d698e7fde57338bc0e8a51f434e';

@ProviderFor(productRepository)
const productRepositoryProvider = ProductRepositoryProvider._();

final class ProductRepositoryProvider extends $FunctionalProvider<
    ProductRepository,
    ProductRepository,
    ProductRepository> with $Provider<ProductRepository> {
  const ProductRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProductRepository create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepository>(value),
    );
  }
}

String _$productRepositoryHash() => r'9a2a7447af084af5931aad3e4e6fb572897df2c6';

@ProviderFor(getProductsUseCase)
const getProductsUseCaseProvider = GetProductsUseCaseProvider._();

final class GetProductsUseCaseProvider
    extends $FunctionalProvider<GetProducts, GetProducts, GetProducts>
    with $Provider<GetProducts> {
  const GetProductsUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getProductsUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getProductsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetProducts> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetProducts create(Ref ref) {
    return getProductsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetProducts value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetProducts>(value),
    );
  }
}

String _$getProductsUseCaseHash() =>
    r'2f8af3a75e1dcece00345c2cb66cd62c6cedd0a3';

/// Provides the paginated, filterable product list.

@ProviderFor(ProductList)
const productListProvider = ProductListProvider._();

/// Provides the paginated, filterable product list.
final class ProductListProvider
    extends $AsyncNotifierProvider<ProductList, List<Product>> {
  /// Provides the paginated, filterable product list.
  const ProductListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productListHash();

  @$internal
  @override
  ProductList create() => ProductList();
}

String _$productListHash() => r'dad781f4584d88f0ff2d7675e286f5561b7acf71';

/// Provides the paginated, filterable product list.

abstract class _$ProductList extends $AsyncNotifier<List<Product>> {
  FutureOr<List<Product>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Product>>, List<Product>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Product>>, List<Product>>,
        AsyncValue<List<Product>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// The current product list filter state (search/category).

@ProviderFor(ProductListFilter)
const productListFilterProvider = ProductListFilterProvider._();

/// The current product list filter state (search/category).
final class ProductListFilterProvider
    extends $NotifierProvider<ProductListFilter, ProductListState> {
  /// The current product list filter state (search/category).
  const ProductListFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productListFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productListFilterHash();

  @$internal
  @override
  ProductListFilter create() => ProductListFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductListState>(value),
    );
  }
}

String _$productListFilterHash() => r'85a0b69146aa89cde2c8960364106031d9cf9fdb';

/// The current product list filter state (search/category).

abstract class _$ProductListFilter extends $Notifier<ProductListState> {
  ProductListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ProductListState, ProductListState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ProductListState, ProductListState>,
        ProductListState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
