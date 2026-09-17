import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products.dart';

import 'product_filter_provider.dart';

part 'product_list_provider.g.dart';

// ── Infrastructure providers ──────────────────────────────────────────────────

@riverpod
ProductRemoteDataSource productRemoteDataSource(Ref ref) {
  return ProductRemoteDataSource(ref.watch(supabaseClientProvider));
}

@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepositoryImpl(ref.watch(productRemoteDataSourceProvider));
}

@riverpod
GetProducts getProductsUseCase(Ref ref) {
  return GetProducts(ref.watch(productRepositoryProvider));
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Provides the paginated, filterable product list.
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() {
    final filter = ref.watch(productFilterProvider);
    return _fetchProducts(filter.search, filter.category, filter.brand);
  }

  Future<List<Product>> _fetchProducts(String search, String? category, String? brand) {
    final useCase = ref.read(getProductsUseCaseProvider);
    final shopId = ref.watch(authControllerProvider).value?.shopId;
    return useCase(
      searchQuery: search,
      category: category,
      brand: brand,
      shopId: shopId,
    ).then(
      (result) => result.fold(
        (failure) => throw Exception(failure.message),
        (products) => products,
      ),
    );
  }

  /// Refreshes the product list with the current filters.
  Future<void> refresh() async {
    state = const AsyncLoading();
    final filter = ref.read(productFilterProvider);
    state = await AsyncValue.guard(() => _fetchProducts(filter.search, filter.category, filter.brand));
  }
}
