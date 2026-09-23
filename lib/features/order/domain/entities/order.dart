import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_item.dart';

part 'order.freezed.dart';

/// Represents the lifecycle status of an order.
enum OrderStatus {
  pending,
  confirmed,
  packed,
  shipped,
  delivered,
  cancelled;

  String get displayLabel => switch (this) {
        OrderStatus.pending => 'Pending',
        OrderStatus.confirmed => 'Confirmed',
        OrderStatus.packed => 'Packed',
        OrderStatus.shipped => 'Shipped',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
      };

  /// Returns the statuses that [this] can legally transition to.
  List<OrderStatus> get nextStatuses => switch (this) {
        OrderStatus.pending => [OrderStatus.confirmed, OrderStatus.cancelled],
        OrderStatus.confirmed => [OrderStatus.packed, OrderStatus.cancelled],
        OrderStatus.packed => [OrderStatus.shipped, OrderStatus.cancelled],
        OrderStatus.shipped => [OrderStatus.delivered],
        OrderStatus.delivered => [],
        OrderStatus.cancelled => [],
      };

  bool get isFinal =>
      this == OrderStatus.delivered || this == OrderStatus.cancelled;
  bool get isActive => !isFinal;

  static OrderStatus fromString(String value) =>
      OrderStatus.values.firstWhere(
        (s) => s.name == value,
        orElse: () => OrderStatus.pending,
      );
}

/// Represents how an order was placed.
enum OrderType {
  online,
  inStore;

  String get displayLabel => switch (this) {
        OrderType.online => 'Online Order',
        OrderType.inStore => 'In-Store',
      };

  String get iconLabel => switch (this) {
        OrderType.online => '🛒',
        OrderType.inStore => '🏪',
      };

  /// DB value stored as snake_case string.
  String get value => switch (this) {
        OrderType.online => 'online',
        OrderType.inStore => 'in_store',
      };

  static OrderType fromString(String value) =>
      OrderType.values.firstWhere(
        (t) => t.value == value || t.name == value,
        orElse: () => OrderType.online,
      );
}

/// Core order entity — pure Dart, no framework or Supabase dependencies.
@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    String? shopId,
    required String customerName,
    required String? customerPhone,
    required String? customerAddress,
    required OrderStatus status,
    required double totalAmount,
    required OrderType orderType,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<OrderItem> items,
  }) = _Order;
}
