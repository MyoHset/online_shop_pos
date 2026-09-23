import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/discount.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/cancel_order.dart';
import '../../domain/usecases/get_order_detail.dart';
import '../../domain/usecases/update_order_discount.dart';
import '../../domain/usecases/update_order_status.dart';
import 'order_list_provider.dart';

part 'order_detail_provider.g.dart';

@riverpod
GetOrderDetail getOrderDetailUseCase(Ref ref) =>
    GetOrderDetail(ref.watch(orderRepositoryProvider));

@riverpod
UpdateOrderStatus updateOrderStatusUseCase(Ref ref) =>
    UpdateOrderStatus(ref.watch(orderRepositoryProvider));

@riverpod
CancelOrder cancelOrderUseCase(Ref ref) =>
    CancelOrder(ref.watch(orderRepositoryProvider));

@riverpod
UpdateOrderDiscount updateOrderDiscountUseCase(Ref ref) =>
    UpdateOrderDiscount(ref.watch(orderRepositoryProvider));

/// Provides a single order's detail — family + autoDispose.
@riverpod
class OrderDetail extends _$OrderDetail {
  @override
  Future<Order> build(String orderId) => _fetch(orderId);

  Future<Order> _fetch(String orderId) async {
    final useCase = ref.read(getOrderDetailUseCaseProvider);
    final result = await useCase(orderId);
    return result.fold(
      (f) => throw Exception(f.message),
      (o) => o,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(orderId));
  }

  Future<bool> updateStatus(OrderStatus newStatus) async {
    final useCase = ref.read(updateOrderStatusUseCaseProvider);
    final result = await useCase(orderId: orderId, newStatus: newStatus);
    return result.fold(
      (f) => false,
      (order) {
        state = AsyncData(order);
        ref.invalidate(orderListProvider);
        return true;
      },
    );
  }

  Future<bool> updateDiscount(Discount discount) async {
    final useCase = ref.read(updateOrderDiscountUseCaseProvider);
    final result = await useCase(
      orderId: orderId,
      discountType: discount.type,
      discountValue: discount.value,
      discountReason: discount.reason,
    );
    return result.fold(
      (f) => throw Exception(f.message),
      (order) {
        state = AsyncData(order);
        ref.invalidate(orderListProvider);
        return true;
      },
    );
  }

  Future<bool> cancel() async {
    final useCase = ref.read(cancelOrderUseCaseProvider);
    final result = await useCase(orderId);
    return result.fold(
      (f) => false,
      (order) {
        state = AsyncData(order);
        ref.invalidate(orderListProvider);
        return true;
      },
    );
  }
}
