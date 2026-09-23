import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../entities/discount.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CreateOrder {
  const CreateOrder(this._repository);
  final OrderRepository _repository;

  /// Creates an order and atomically reserves stock for each item.
  ///
  /// Uses a Supabase RPC under the hood to ensure no race conditions.
  Future<Either<Failure, Order>> call({
    required String customerName,
    String? customerPhone,
    String? customerAddress,
    required List<OrderItemInput> items,
    DiscountType discountType = DiscountType.none,
    double discountValue = 0.0,
    String? discountReason,
    String? shopId,
  }) =>
      _repository.createOrder(
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        items: items,
        discountType: discountType,
        discountValue: discountValue,
        discountReason: discountReason,
        shopId: shopId,
      );
}
