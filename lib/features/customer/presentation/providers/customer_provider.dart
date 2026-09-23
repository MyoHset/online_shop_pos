import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/customer_remote_datasource.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_transaction.dart';
import '../../domain/repositories/customer_repository.dart';

part 'customer_provider.g.dart';

// ── Infrastructure Providers ───────────────────────────────────────────────────

@Riverpod(keepAlive: true)
CustomerRemoteDataSource customerRemoteDataSource(Ref ref) =>
    CustomerRemoteDataSource(ref.watch(supabaseClientProvider));

@Riverpod(keepAlive: true)
CustomerRepository customerRepository(Ref ref) =>
    CustomerRepositoryImpl(ref.watch(customerRemoteDataSourceProvider));

// ── State Providers ────────────────────────────────────────────────────────────

/// Query for filtering customers by name or phone
@riverpod
class CustomerSearchQuery extends _$CustomerSearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

/// Provides filtered or full list of customers
@riverpod
class CustomerList extends _$CustomerList {
  @override
  Future<List<Customer>> build() async {
    final query = ref.watch(customerSearchQueryProvider);
    final repo = ref.watch(customerRepositoryProvider);
    final result = await repo.getCustomers(
      searchQuery: query.trim().isEmpty ? null : query.trim(),
    );
    return result.fold(
      (f) => throw Exception(f.message),
      (customers) => customers,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final query = ref.read(customerSearchQueryProvider);
    final repo = ref.read(customerRepositoryProvider);
    final result = await repo.getCustomers(
      searchQuery: query.trim().isEmpty ? null : query.trim(),
    );
    state = result.fold(
      (f) => AsyncError(f.message, StackTrace.current),
      AsyncData.new,
    );
  }
}

/// Provides single customer by ID
@riverpod
Future<Customer> customerDetail(Ref ref, String id) async {
  final repo = ref.watch(customerRepositoryProvider);
  final result = await repo.getCustomerById(id);
  return result.fold(
    (f) => throw Exception(f.message),
    (c) => c,
  );
}

/// Provides ledger transaction history for a customer
@riverpod
class CustomerTransactions extends _$CustomerTransactions {
  @override
  Future<List<CustomerTransaction>> build(String customerId) async {
    return _fetch(customerId);
  }

  Future<List<CustomerTransaction>> _fetch(String customerId) async {
    final repo = ref.read(customerRepositoryProvider);
    final result = await repo.getTransactions(customerId);
    return result.fold(
      (f) => throw Exception(f.message),
      (t) => t,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(customerId));
  }
}

/// Controller for Customer mutations (Create, Update, Repayment)
@Riverpod(keepAlive: true)
class CustomerController extends _$CustomerController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<Customer?> createCustomer({
    required String name,
    required String phone,
    String? address,
    double creditLimit = 0.0,
    double initialDebt = 0.0,
    RepaymentCycle repaymentCycle = RepaymentCycle.monthly,
    String? notes,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(customerRepositoryProvider);
    final result = await repo.createCustomer(
      name: name,
      phone: phone,
      address: address,
      creditLimit: creditLimit,
      initialDebt: initialDebt,
      repaymentCycle: repaymentCycle,
      notes: notes,
    );

    return result.fold(
      (f) {
        if (ref.mounted) {
          state = AsyncError(f.message, StackTrace.current);
        }
        return null;
      },
      (created) {
        if (ref.mounted) {
          state = const AsyncData(null);
          ref.invalidate(customerListProvider);
        }
        return created;
      },
    );
  }

  Future<Customer?> updateCustomer({
    required String id,
    required String name,
    required String phone,
    String? address,
    required double creditLimit,
    required RepaymentCycle repaymentCycle,
    String? notes,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(customerRepositoryProvider);
    final result = await repo.updateCustomer(
      id: id,
      name: name,
      phone: phone,
      address: address,
      creditLimit: creditLimit,
      repaymentCycle: repaymentCycle,
      notes: notes,
    );

    return result.fold(
      (f) {
        if (ref.mounted) {
          state = AsyncError(f.message, StackTrace.current);
        }
        return null;
      },
      (updated) {
        if (ref.mounted) {
          state = const AsyncData(null);
          ref.invalidate(customerListProvider);
          ref.invalidate(customerDetailProvider(id));
        }
        return updated;
      },
    );
  }

  Future<bool> recordRepayment({
    required String customerId,
    required double amount,
    required String paymentMethod,
    String? notes,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(customerRepositoryProvider);
    final result = await repo.recordRepayment(
      customerId: customerId,
      amount: amount,
      paymentMethod: paymentMethod,
      notes: notes,
    );

    return result.fold(
      (f) {
        if (ref.mounted) {
          state = AsyncError(f.message, StackTrace.current);
        }
        return false;
      },
      (_) {
        if (ref.mounted) {
          state = const AsyncData(null);
          ref.invalidate(customerListProvider);
          ref.invalidate(customerDetailProvider(customerId));
          ref.invalidate(customerTransactionsProvider(customerId));
        }
        return true;
      },
    );
  }
}
