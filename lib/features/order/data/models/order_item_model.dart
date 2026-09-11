import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order_item.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

@freezed
abstract class OrderItemModel with _$OrderItemModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OrderItemModel({
    required String id,
    required String orderId,
    required String variantId,
    required int quantity,
    required double unitPrice,
    required double subtotal,
    // Joined fields
    @JsonKey(name: 'product_variants') Map<String, dynamic>? variantData,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  const OrderItemModel._();

  OrderItem toEntity() {
    final variant = variantData;
    final product = variant?['products'] as Map<String, dynamic>?;
    final images = (variant?['variant_images'] as List?)
        ?.cast<Map<String, dynamic>>();
    final primaryImage = images
        ?.where((img) => img['is_primary'] == true)
        .firstOrNull?['image_url'] as String?;

    return OrderItem(
      id: id,
      orderId: orderId,
      variantId: variantId,
      quantity: quantity,
      unitPrice: unitPrice,
      subtotal: subtotal,
      productName: product?['name'] as String?,
      variantDisplayName: _buildDisplayName(
        variant?['size'] as String?,
        variant?['color'] as String?,
      ),
      variantSku: variant?['sku'] as String?,
      variantImageUrl: primaryImage,
    );
  }

  static String? _buildDisplayName(String? size, String? color) {
    final parts = [if (size != null) size, if (color != null) color];
    return parts.isEmpty ? null : parts.join(' / ');
  }
}
