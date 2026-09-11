import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class UpdateOrderStatus {
  const UpdateOrderStatus(this._repository);
  final OrderRepository _repository;

  Future<Either<Failure, Order>> call({
    required String orderId,
    required OrderStatus newStatus,
  }) =>
      _repository.updateOrderStatus(
        orderId: orderId,
        newStatus: newStatus,
      );
}
