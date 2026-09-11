import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrderDetail {
  const GetOrderDetail(this._repository);
  final OrderRepository _repository;

  Future<Either<Failure, Order>> call(String orderId) =>
      _repository.getOrderById(orderId);
}
