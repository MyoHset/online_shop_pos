import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../entities/discount.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class UpdateOrderDiscount {
  const UpdateOrderDiscount(this._repository);

  final OrderRepository _repository;

  /// Updates discount on an existing order.
  ///
  /// Recalculates [Order.totalAmount] automatically via backend triggers
  /// and returns the authoritative refreshed [Order].
  Future<Either<Failure, Order>> call({
    required String orderId,
    required DiscountType discountType,
    required double discountValue,
    String? discountReason,
  }) =>
      _repository.updateOrderDiscount(
        orderId: orderId,
        discountType: discountType,
        discountValue: discountValue,
        discountReason: discountReason,
      );
}
