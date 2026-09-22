import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/variant_detail.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_list_provider.dart';

part 'browse_for_customer_provider.g.dart';

class BrowseFilterState {
  const BrowseFilterState({
    this.category,
    this.brand,
    this.size,
  });

  final String? category;
  final String? brand;
  final String? size;

  BrowseFilterState copyWith({
    String? category,
    String? brand,
    String? size,
    bool clearCategory = false,
    bool clearBrand = false,
    bool clearSize = false,
  }) {
    return BrowseFilterState(
      category: clearCategory ? null : (category ?? this.category),
      brand: clearBrand ? null : (brand ?? this.brand),
      size: clearSize ? null : (size ?? this.size),
    );
  }
}

@riverpod
class BrowseFilter extends _$BrowseFilter {
  @override
  BrowseFilterState build() => const BrowseFilterState();

  void updateCategory(String? category) {
    state = state.copyWith(category: category, clearCategory: category == null);
  }

  void updateBrand(String? brand) {
    state = state.copyWith(brand: brand, clearBrand: brand == null);
  }

  void updateSize(String? size) {
    state = state.copyWith(size: size, clearSize: size == null);
  }

  void clearFilters() {
    state = const BrowseFilterState();
  }
}

@riverpod
Future<List<VariantDetail>> browseResults(Ref ref) async {
  final filter = ref.watch(browseFilterProvider);
  final repository = ref.watch(productRepositoryProvider);

  final result = await repository.browseForCustomer(
    category: filter.category,
    brand: filter.brand,
    size: filter.size,
    limit: 30,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (items) => items,
  );
}
