import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/variant_detail.dart';

part 'present_selected_provider.g.dart';

@riverpod
class PresentSelectedItems extends _$PresentSelectedItems {
  @override
  Map<String, VariantDetail> build() => {};

  void toggle(VariantDetail item) {
    final next = Map<String, VariantDetail>.from(state);
    if (next.containsKey(item.variantId)) {
      next.remove(item.variantId);
    } else {
      next[item.variantId] = item;
    }
    state = next;
  }

  void select(VariantDetail item) {
    if (!state.containsKey(item.variantId)) {
      state = {...state, item.variantId: item};
    }
  }

  void deselect(String variantId) {
    if (state.containsKey(variantId)) {
      final next = Map<String, VariantDetail>.from(state)..remove(variantId);
      state = next;
    }
  }

  void clear() => state = {};
}
