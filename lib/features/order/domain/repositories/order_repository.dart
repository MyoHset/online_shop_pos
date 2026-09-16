import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../entities/order.dart';

/// Input model for a single order line item during creation.
class OrderItemInput {
  const OrderItemInput({
    required this.variantId,
    required this.quantity,
    required this.unitPrice,
  });

  final String variantId;
  final int quantity;
  final double unitPrice;
}

/// Abstract repository interface for order operations.
///
/// All methods return [Either<Failure, T>].
abstract interface class OrderRepository {
  /// Returns orders filtered by optional [status], paginated.
  Future<Either<Failure, List<Order>>> getOrders({
    OrderStatus? status,
    int page = 0,
    int pageSize = 20,
  });

  /// Returns a single order with its full item list.
  Future<Either<Failure, Order>> getOrderById(String id);

  /// Creates a new order and atomically reserves stock for each item via RPC.
  Future<Either<Failure, Order>> createOrder({
    required String customerName,
    String? customerPhone,
    String? customerAddress,
    required List<OrderItemInput> items,
    String? shopId,
  });

  /// Creates a quick sale, atomic stock deduction, and payment record.
  Future<Either<Failure, Order>> completeInstantSale({
    String? customerName,
    required List<OrderItemInput> items,
    required String paymentMethod,
    String? shopId,
  });

  /// Transitions [orderId] to [newStatus].
  Future<Either<Failure, Order>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  });

  /// Cancels [orderId] and releases all reserved stock.
  Future<Either<Failure, Order>> cancelOrder(String orderId);

  /// Confirms stock deduction (called when order is delivered/paid).
  Future<Either<Failure, Unit>> confirmStockDeduction(String orderId);
}
