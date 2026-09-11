import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrders {
  const GetOrders(this._repository);
  final OrderRepository _repository;

  Future<Either<Failure, List<Order>>> call({
    OrderStatus? status,
    int page = 0,
    int pageSize = 20,
  }) =>
      _repository.getOrders(status: status, page: page, pageSize: pageSize);
}
