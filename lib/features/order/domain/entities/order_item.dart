import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';

/// A single line item within an order.
@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String orderId,
    required String variantId,
    required int quantity,
    required double unitPrice,
    required double subtotal,
    // Denormalized for display — loaded via join
    String? productName,
    String? variantDisplayName,
    String? variantSku,
    String? variantImageUrl,
  }) = _OrderItem;
}
