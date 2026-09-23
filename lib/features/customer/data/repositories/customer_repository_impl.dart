import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_transaction.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this._dataSource);

  final CustomerRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<Customer>>> getCustomers({String? searchQuery}) async {
    try {
      final models = await _dataSource.getCustomers(searchQuery: searchQuery);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> getCustomerById(String id) async {
    try {
      final model = await _dataSource.getCustomerById(id);
      return Right(model.toEntity());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> createCustomer({
    required String name,
    required String phone,
    String? address,
    double creditLimit = 0.0,
    double initialDebt = 0.0,
    RepaymentCycle repaymentCycle = RepaymentCycle.monthly,
    String? notes,
  }) async {
    try {
      final model = await _dataSource.createCustomer(
        name: name,
        phone: phone,
        address: address,
        creditLimit: creditLimit,
        initialDebt: initialDebt,
        repaymentCycle: repaymentCycle.value,
        notes: notes,
      );
      return Right(model.toEntity());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> updateCustomer({
    required String id,
    required String name,
    required String phone,
    String? address,
    required double creditLimit,
    required RepaymentCycle repaymentCycle,
    String? notes,
  }) async {
    try {
      final model = await _dataSource.updateCustomer(
        id: id,
        name: name,
        phone: phone,
        address: address,
        creditLimit: creditLimit,
        repaymentCycle: repaymentCycle.value,
        notes: notes,
      );
      return Right(model.toEntity());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> recordRepayment({
    required String customerId,
    required double amount,
    required String paymentMethod,
    String? notes,
  }) async {
    try {
      final newDebt = await _dataSource.recordRepayment(
        customerId: customerId,
        amount: amount,
        paymentMethod: paymentMethod,
        notes: notes,
      );
      return Right(newDebt);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CustomerTransaction>>> getTransactions(
    String customerId,
  ) async {
    try {
      final models = await _dataSource.getCustomerTransactions(customerId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
