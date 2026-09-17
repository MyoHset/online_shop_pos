import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quick_sale_filter_provider.g.dart';

@riverpod
class QuickSaleFilter extends _$QuickSaleFilter {
  @override
  ({String? category, String? brand, String search}) build() =>
      (category: null, brand: null, search: '');

  void setCategory(String? category) =>
      state = (category: category, brand: state.brand, search: state.search);
      
  void setBrand(String? brand) =>
      state = (category: state.category, brand: brand, search: state.search);
      
  void setSearch(String query) =>
      state = (category: state.category, brand: state.brand, search: query);
      
  void clear() => state = (category: null, brand: null, search: '');
}
