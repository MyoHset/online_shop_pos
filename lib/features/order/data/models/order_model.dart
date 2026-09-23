import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/discount.dart';
import '../../domain/entities/order.dart';
import 'order_item_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
abstract class OrderModel with _$OrderModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OrderModel({
    required String id,
    String? shopId,
    String? customerName,
    required String? customerPhone,
    required String? customerAddress,
    required String status,
    required double totalAmount,
    @Default('online') String orderType,
    @Default('none') String discountType,
    @Default(0.0) double discountValue,
    @Default(0.0) double discountAmount,
    String? discountReason,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<OrderItemModel> orderItems,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  const OrderModel._();

  Order toEntity() => Order(
        id: id,
        shopId: shopId,
        customerName: customerName ?? 'Walk-in Customer',
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        status: OrderStatus.fromString(status),
        totalAmount: totalAmount,
        orderType: OrderType.fromString(orderType),
        discountType: DiscountType.fromString(discountType),
        discountValue: discountValue,
        discountAmount: discountAmount,
        discountReason: discountReason,
        createdAt: createdAt,
        updatedAt: updatedAt,
        items: orderItems.map((i) => i.toEntity()).toList(),
      );
}
