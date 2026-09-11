import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/payment.dart';
import '../models/payment_model.dart';

class PaymentRemoteDataSource {
  const PaymentRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<List<PaymentModel>> getPaymentsForOrder(String orderId) async {
    try {
      final data = await _client
          .from(SupabaseConstants.paymentsTable)
          .select()
          .eq('order_id', orderId)
          .order('created_at');
      return (data as List)
          .map((json) => PaymentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<PaymentModel> recordPayment({
    required String orderId,
    required PaymentMethod method,
    required double amount,
    required PaymentStatus status,
  }) async {
    try {
      final data = await _client
          .from(SupabaseConstants.paymentsTable)
          .insert({
            'order_id': orderId,
            'method': method.name,
            'amount': amount,
            'status': status.name,
            'paid_at': status == PaymentStatus.paid
                ? DateTime.now().toIso8601String()
                : null,
          })
          .select()
          .single();
      return PaymentModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<PaymentModel> updatePaymentStatus({
    required String paymentId,
    required PaymentStatus newStatus,
    DateTime? paidAt,
  }) async {
    try {
      final data = await _client
          .from(SupabaseConstants.paymentsTable)
          .update({
            'status': newStatus.name,
            if (newStatus == PaymentStatus.paid)
              'paid_at': (paidAt ?? DateTime.now()).toIso8601String(),
          })
          .eq('id', paymentId)
          .select()
          .single();
      return PaymentModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
