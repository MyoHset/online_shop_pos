import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class GetPaymentsForOrder {
  const GetPaymentsForOrder(this._repository);
  final PaymentRepository _repository;

  Future<Either<Failure, List<Payment>>> call(String orderId) =>
      _repository.getPaymentsForOrder(orderId);
}
