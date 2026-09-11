import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl(this._dataSource);

  final PaymentRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<Payment>>> getPaymentsForOrder(
      String orderId) async {
    try {
      final models = await _dataSource.getPaymentsForOrder(orderId);
      return right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Payment>> recordPayment({
    required String orderId,
    required PaymentMethod method,
    required double amount,
    required PaymentStatus status,
  }) async {
    try {
      final model = await _dataSource.recordPayment(
        orderId: orderId,
        method: method,
        amount: amount,
        status: status,
      );
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Payment>> updatePaymentStatus({
    required String paymentId,
    required PaymentStatus newStatus,
    DateTime? paidAt,
  }) async {
    try {
      final model = await _dataSource.updatePaymentStatus(
        paymentId: paymentId,
        newStatus: newStatus,
        paidAt: paidAt,
      );
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
