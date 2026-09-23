import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/payment_remote_datasource.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../domain/usecases/get_payments_for_order.dart';
import '../../domain/usecases/record_payment.dart';
import '../../domain/usecases/update_payment_status.dart';

part 'payment_provider.g.dart';

// ── Infrastructure ─────────────────────────────────────────────────────────────

@riverpod
PaymentRemoteDataSource paymentRemoteDataSource(Ref ref) =>
    PaymentRemoteDataSource(ref.watch(supabaseClientProvider));

@riverpod
PaymentRepository paymentRepository(Ref ref) =>
    PaymentRepositoryImpl(ref.watch(paymentRemoteDataSourceProvider));

@riverpod
GetPaymentsForOrder getPaymentsForOrderUseCase(Ref ref) =>
    GetPaymentsForOrder(ref.watch(paymentRepositoryProvider));

@riverpod
RecordPayment recordPaymentUseCase(Ref ref) =>
    RecordPayment(ref.watch(paymentRepositoryProvider));

@riverpod
UpdatePaymentStatus updatePaymentStatusUseCase(Ref ref) =>
    UpdatePaymentStatus(ref.watch(paymentRepositoryProvider));

// ── State ─────────────────────────────────────────────────────────────────────

/// Provides all payments for a given order — family + autoDispose.
@riverpod
class OrderPayments extends _$OrderPayments {
  @override
  Future<List<Payment>> build(String orderId) => _fetch(orderId);

  Future<List<Payment>> _fetch(String orderId) async {
    final useCase = ref.read(getPaymentsForOrderUseCaseProvider);
    final result = await useCase(orderId);
    return result.fold(
      (f) => throw Exception(f.message),
      (p) => p,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(orderId));
  }

  Future<String?> recordPayment({
    required PaymentMethod method,
    required double amount,
    required PaymentStatus status,
  }) async {
    final useCase = ref.read(recordPaymentUseCaseProvider);
    final result = await useCase(
      orderId: orderId,
      method: method,
      amount: amount,
      status: status,
    );
    return result.fold(
      (f) => f.message,
      (payment) {
        state.whenData((list) {
          state = AsyncData([...list, payment]);
        });
        return null;
      },
    );
  }

  Future<bool> markAsPaid(String paymentId) async {
    final useCase = ref.read(updatePaymentStatusUseCaseProvider);
    final result = await useCase(
      paymentId: paymentId,
      newStatus: PaymentStatus.paid,
      paidAt: DateTime.now(),
    );
    return result.fold(
      (f) => false,
      (updated) {
        state.whenData((list) {
          state = AsyncData(
            list.map((p) => p.id == paymentId ? updated : p).toList(),
          );
        });
        return true;
      },
    );
  }
}
