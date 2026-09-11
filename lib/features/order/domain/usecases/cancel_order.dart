import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class CancelOrder {
  const CancelOrder(this._repository);
  final OrderRepository _repository;

  /// Cancels the order and releases reserved stock back to available.
  Future<Either<Failure, Order>> call(String orderId) =>
      _repository.cancelOrder(orderId);
}
