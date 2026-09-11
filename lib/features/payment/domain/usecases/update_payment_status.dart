import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class UpdatePaymentStatus {
  const UpdatePaymentStatus(this._repository);
  final PaymentRepository _repository;

  Future<Either<Failure, Payment>> call({
    required String paymentId,
    required PaymentStatus newStatus,
    DateTime? paidAt,
  }) =>
      _repository.updatePaymentStatus(
        paymentId: paymentId,
        newStatus: newStatus,
        paidAt: paidAt,
      );
}
