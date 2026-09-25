import 'package:fpdart/fpdart.dart' hide Order;
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/discount.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

/// Concrete implementation of [OrderRepository].
class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this._dataSource);

  final OrderRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<Order>>> getOrders({
    OrderStatus? status,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final models = await _dataSource.getOrders(
        status: status,
        page: page,
        pageSize: pageSize,
      );
      return right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(String id) async {
    try {
      final model = await _dataSource.getOrderById(id);
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> createOrder({
    required String customerName,
    String? customerPhone,
    String? customerAddress,
    required List<OrderItemInput> items,
    DiscountType discountType = DiscountType.none,
    double discountValue = 0.0,
    String? discountReason,
    String? shopId,
  }) async {
    try {
      final model = await _dataSource.createOrder(
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        items: items,
        discountType: discountType,
        discountValue: discountValue,
        discountReason: discountReason,
        shopId: shopId,
      );
      return right(model.toEntity());
    } on StockReservationException catch (e) {
      return left(StockReservationFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> completeInstantSale({
    String? customerName,
    String? customerId,
    required List<OrderItemInput> items,
    required String paymentMethod,
    bool isCredit = false,
    double paidAmount = 0.0,
    DateTime? dueDate,
    DiscountType discountType = DiscountType.none,
    double discountValue = 0.0,
    String? discountReason,
    String? shopId,
  }) async {
    try {
      final model = await _dataSource.completeInstantSale(
        customerName: customerName,
        customerId: customerId,
        items: items,
        paymentMethod: paymentMethod,
        isCredit: isCredit,
        paidAmount: paidAmount,
        dueDate: dueDate,
        discountType: discountType,
        discountValue: discountValue,
        discountReason: discountReason,
        shopId: shopId,
      );
      return right(model.toEntity());
    } on StockReservationException catch (e) {
      return left(StockReservationFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> updateOrderDiscount({
    required String orderId,
    required DiscountType discountType,
    required double discountValue,
    String? discountReason,
  }) async {
    try {
      final model = await _dataSource.updateOrderDiscount(
        orderId: orderId,
        discountType: discountType,
        discountValue: discountValue,
        discountReason: discountReason,
      );
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    try {
      final model = await _dataSource.updateOrderStatus(
        orderId: orderId,
        newStatus: newStatus,
      );
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> cancelOrder(String orderId) async {
    try {
      final model = await _dataSource.cancelOrder(orderId);
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmStockDeduction(String orderId) async {
    try {
      await _dataSource.confirmStockDeduction(orderId);
      return right(unit);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
