import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/get_orders.dart';

part 'order_list_provider.g.dart';

// ── Infrastructure providers ──────────────────────────────────────────────────

@riverpod
OrderRemoteDataSource orderRemoteDataSource(Ref ref) {
  return OrderRemoteDataSource(ref.watch(supabaseClientProvider));
}

@riverpod
OrderRepository orderRepository(Ref ref) {
  return OrderRepositoryImpl(ref.watch(orderRemoteDataSourceProvider));
}

@riverpod
GetOrders getOrdersUseCase(Ref ref) {
  return GetOrders(ref.watch(orderRepositoryProvider));
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Provides the order list, optionally filtered by status.
@riverpod
class OrderList extends _$OrderList {
  OrderStatus? _statusFilter;

  @override
  Future<List<Order>> build() => _fetch();

  Future<List<Order>> _fetch() {
    final useCase = ref.read(getOrdersUseCaseProvider);
    return useCase(status: _statusFilter).then(
      (result) => result.fold(
        (f) => throw Exception(f.message),
        (orders) => orders,
      ),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> filterByStatus(OrderStatus? status) async {
    _statusFilter = status;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  OrderStatus? get currentFilter => _statusFilter;
}
