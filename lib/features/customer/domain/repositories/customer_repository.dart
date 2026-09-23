import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/customer.dart';
import '../entities/customer_transaction.dart';

abstract interface class CustomerRepository {
  /// Fetch all customers for current shop, optionally matching name or phone.
  Future<Either<Failure, List<Customer>>> getCustomers({String? searchQuery});

  /// Get single customer by ID.
  Future<Either<Failure, Customer>> getCustomerById(String id);

  /// Create a new customer with optional opening balance.
  Future<Either<Failure, Customer>> createCustomer({
    required String name,
    required String phone,
    String? address,
    double creditLimit = 0.0,
    double initialDebt = 0.0,
    RepaymentCycle repaymentCycle = RepaymentCycle.monthly,
    String? notes,
  });

  /// Update existing customer details.
  Future<Either<Failure, Customer>> updateCustomer({
    required String id,
    required String name,
    required String phone,
    String? address,
    required double creditLimit,
    required RepaymentCycle repaymentCycle,
    String? notes,
  });

  /// Record a debt repayment for a customer.
  Future<Either<Failure, double>> recordRepayment({
    required String customerId,
    required double amount,
    required String paymentMethod,
    String? notes,
  });

  /// Fetch transaction ledger history for a customer.
  Future<Either<Failure, List<CustomerTransaction>>> getTransactions(String customerId);
}
