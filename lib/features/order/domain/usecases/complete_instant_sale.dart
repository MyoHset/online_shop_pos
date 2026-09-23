import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../entities/discount.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CompleteInstantSale {
  const CompleteInstantSale(this._repository);

  final OrderRepository _repository;

  Future<Either<Failure, Order>> call({
    String? customerName,
    required List<OrderItemInput> items,
    required String paymentMethod,
    DiscountType discountType = DiscountType.none,
    double discountValue = 0.0,
    String? discountReason,
    String? shopId,
  }) =>
      _repository.completeInstantSale(
        customerName: customerName,
        items: items,
        paymentMethod: paymentMethod,
        discountType: discountType,
        discountValue: discountValue,
        discountReason: discountReason,
        shopId: shopId,
      );
}
