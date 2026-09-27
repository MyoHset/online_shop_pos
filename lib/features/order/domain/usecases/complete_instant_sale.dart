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
    String? customerId,
    required List<OrderItemInput> items,
    required String paymentMethod,
    bool isCredit = false,
    double paidAmount = 0.0,
    DateTime? dueDate,
    DiscountType discountType = DiscountType.none,
    double discountValue = 0.0,
    String? discountReason,
    String? shopId,
  }) =>
      _repository.completeInstantSale(
        customerName: customerName,
        customerId: customerId,
        items: items,
        paymentMethod: paymentMethod,
        isCredit: isCredit,
        paidAmount: paidAmount,
        dueDate: dueDate,
        discountType: discountType,
        discountValue: discountValue,
        discountReason: discountReason,
        shopId: shopId,
      );
}
