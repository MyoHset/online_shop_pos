import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment.dart';

/// Abstract repository for payment operations.
abstract interface class PaymentRepository {
  /// Returns all payments attached to [orderId].
  Future<Either<Failure, List<Payment>>> getPaymentsForOrder(String orderId);

  /// Records a new payment for [orderId].
  Future<Either<Failure, Payment>> recordPayment({
    required String orderId,
    required PaymentMethod method,
    required double amount,
    required PaymentStatus status,
  });

  /// Updates the status of an existing payment.
  Future<Either<Failure, Payment>> updatePaymentStatus({
    required String paymentId,
    required PaymentStatus newStatus,
    DateTime? paidAt,
  });
}
