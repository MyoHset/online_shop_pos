import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class RecordPayment {
  const RecordPayment(this._repository);
  final PaymentRepository _repository;

  Future<Either<Failure, Payment>> call({
    required String orderId,
    required PaymentMethod method,
    required double amount,
    required PaymentStatus status,
  }) =>
      _repository.recordPayment(
        orderId: orderId,
        method: method,
        amount: amount,
        status: status,
      );
}
