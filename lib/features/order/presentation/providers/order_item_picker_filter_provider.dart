import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_item_picker_filter_provider.g.dart';

@riverpod
class OrderItemPickerFilter extends _$OrderItemPickerFilter {
  @override
  ({String? category, String search}) build() => (category: null, search: '');

  void setCategory(String? category) => state = (category: category, search: state.search);
  
  void setSearch(String query) => state = (category: state.category, search: query);
  
  void clear() => state = (category: null, search: '');
}
