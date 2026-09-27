import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/failures.dart';
import '../models/customer_model.dart';
import '../models/customer_transaction_model.dart';

class CustomerRemoteDataSource {
  const CustomerRemoteDataSource(this._client);

  final SupabaseClient _client;

  /// Fetches customers, optionally filtered by name or phone.
  Future<List<CustomerModel>> getCustomers({String? searchQuery}) async {
    try {
      var query = _client.from(SupabaseConstants.customersTable).select();

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim();
        query = query.or('name.ilike.%$q%,phone.ilike.%$q%');
      }

      final data = await query.order('name', ascending: true);
      return (data as List)
          .map((json) => CustomerModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerFailure('Failed to fetch customers: $e');
    }
  }

  /// Fetches a single customer by id.
  Future<CustomerModel> getCustomerById(String id) async {
    try {
      final data = await _client
          .from(SupabaseConstants.customersTable)
          .select()
          .eq('id', id)
          .single();
      return CustomerModel.fromJson(data);
    } catch (e) {
      throw ServerFailure('Failed to fetch customer: $e');
    }
  }

  /// Creates a new customer. If initialDebt > 0, records opening balance transaction.
  Future<CustomerModel> createCustomer({
    required String name,
    required String phone,
    String? address,
    double creditLimit = 0.0,
    double initialDebt = 0.0,
    String repaymentCycle = 'monthly',
    String? notes,
  }) async {
    try {
      final insertData = <String, dynamic>{
        'name': name.trim(),
        'phone': phone.trim(),
        if (address != null && address.trim().isNotEmpty)
          'address': address.trim(),
        'credit_limit': creditLimit,
        'current_debt': initialDebt,
        'repayment_cycle': repaymentCycle,
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      };

      final createdJson = await _client
          .from(SupabaseConstants.customersTable)
          .insert(insertData)
          .select()
          .single();

      final customer = CustomerModel.fromJson(createdJson);

      // If there's an opening debt balance, record it in ledger
      if (initialDebt > 0) {
        await _client.from(SupabaseConstants.customerTransactionsTable).insert({
          'customer_id': customer.id,
          'transaction_type': 'opening_balance',
          'amount': initialDebt,
          'payment_method': 'cash',
          'balance_after': initialDebt,
          'notes': 'Opening balance',
        });
      }

      return customer;
    } catch (e) {
      throw ServerFailure('Failed to create customer: $e');
    }
  }

  /// Updates an existing customer.
  Future<CustomerModel> updateCustomer({
    required String id,
    required String name,
    required String phone,
    String? address,
    required double creditLimit,
    required String repaymentCycle,
    String? notes,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'name': name.trim(),
        'phone': phone.trim(),
        'address': address?.trim(),
        'credit_limit': creditLimit,
        'repayment_cycle': repaymentCycle,
        'notes': notes?.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final updatedJson = await _client
          .from(SupabaseConstants.customersTable)
          .update(updateData)
          .eq('id', id)
          .select()
          .single();

      return CustomerModel.fromJson(updatedJson);
    } catch (e) {
      throw ServerFailure('Failed to update customer: $e');
    }
  }

  /// Records a customer repayment using atomic RPC function.
  Future<double> recordRepayment({
    required String customerId,
    required double amount,
    required String paymentMethod,
    String? notes,
  }) async {
    try {
      final response = await _client.rpc(
        SupabaseConstants.recordCustomerRepaymentRpc,
        params: {
          'p_customer_id': customerId,
          'p_amount': amount,
          'p_payment_method': paymentMethod,
          'p_notes': notes,
        },
      );
      return (response as num).toDouble();
    } catch (e) {
      throw ServerFailure('Failed to record repayment: $e');
    }
  }

  /// Fetches transaction ledger history for customer.
  Future<List<CustomerTransactionModel>> getCustomerTransactions(
    String customerId,
  ) async {
    try {
      final data = await _client
          .from(SupabaseConstants.customerTransactionsTable)
          .select()
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);

      return (data as List)
          .map(
            (json) => CustomerTransactionModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerFailure('Failed to fetch transactions: $e');
    }
  }

  /// Toggles customer account suspension.
  Future<CustomerModel> toggleSuspendCustomer({
    required String id,
    required bool isSuspended,
    String? reason,
  }) async {
    try {
      final updatedJson = await _client
          .from(SupabaseConstants.customersTable)
          .update({
            'is_suspended': isSuspended,
            'suspended_reason': isSuspended ? (reason ?? 'Suspended by admin') : null,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      return CustomerModel.fromJson(updatedJson);
    } catch (e) {
      throw ServerFailure('Failed to update customer status: $e');
    }
  }
}
