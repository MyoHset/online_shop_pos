import 'package:freezed_annotation/freezed_annotation.dart';
import 'cart_item.dart';

part 'cart.freezed.dart';

@freezed
abstract class Cart with _$Cart {
  const factory Cart({
    @Default([]) List<CartItem> items,
  }) = _Cart;

  const Cart._();

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);
  
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  
  bool get hasInsufficientStock => items.any((item) => !item.hasSufficientStock);
  
  List<CartItem> get insufficientStockItems => 
      items.where((item) => !item.hasSufficientStock).toList();
}
