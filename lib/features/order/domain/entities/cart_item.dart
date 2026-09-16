import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required String variantId,
    required String productName,
    required String variantDisplayName,
    required double unitPrice,
    required int quantity,
    required int availableStock,
  }) = _CartItem;

  const CartItem._();

  double get subtotal => unitPrice * quantity;
  bool get hasSufficientStock => quantity <= availableStock;
}
