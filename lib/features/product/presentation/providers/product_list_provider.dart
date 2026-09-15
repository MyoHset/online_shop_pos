import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products.dart';

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

// ── State ─────────────────────────────────────────────────────────────────────

/// State for the product list, including search/filter state.
class ProductListState {
  const ProductListState({
    this.searchQuery = '',
    this.selectedCategory,
  });

  final String searchQuery;
  final String? selectedCategory;

  ProductListState copyWith({
    String? searchQuery,
    String? selectedCategory,
    bool clearCategory = false,
  }) =>
      ProductListState(
        searchQuery: searchQuery ?? this.searchQuery,
        selectedCategory:
            clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      );
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Provides the paginated, filterable product list.
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() => _fetchProducts();

  String _searchQuery = '';
  String? _selectedCategory;

  Future<List<Product>> _fetchProducts() {
    final useCase = ref.read(getProductsUseCaseProvider);
    final shopId = ref.watch(authControllerProvider).value?.shopId;
    return useCase(
      searchQuery: _searchQuery,
      category: _selectedCategory,
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
    state = await AsyncValue.guard(_fetchProducts);
  }

  /// Updates the search query and reloads.
  Future<void> search(String query) async {
    _searchQuery = query;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchProducts);
  }

  /// Filters by category and reloads.
  Future<void> filterByCategory(String? category) async {
    _selectedCategory = category;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchProducts);
  }
}

/// The current product list filter state (search/category).
@riverpod
class ProductListFilter extends _$ProductListFilter {
  @override
  ProductListState build() => const ProductListState();

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateCategory(String? category) {
    state = state.copyWith(
      selectedCategory: category,
      clearCategory: category == null,
    );
  }
}
