import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

/// Remote data source for all order-related Supabase operations.
class OrderRemoteDataSource {
  const OrderRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _orderSelect = '''
    *,
    order_items(
      *,
      product_variants(
        *,
        products(id, name),
        variant_images(image_url, is_primary)
      )
    )
  ''';

  Future<List<OrderModel>> getOrders({
    OrderStatus? status,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      var query = _client
          .from(SupabaseConstants.ordersTable)
          .select(_orderSelect);

      if (status != null) {
        query = query.eq('status', status.name);
      }

      final data = await query
          .order('created_at', ascending: false)
          .range(page * pageSize, (page + 1) * pageSize - 1);
      return (data as List)
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<OrderModel> getOrderById(String id) async {
    try {
      final data = await _client
          .from(SupabaseConstants.ordersTable)
          .select(_orderSelect)
          .eq('id', id)
          .single();
      return OrderModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Creates the order record and uses an atomic RPC to reserve stock.
  ///
  /// The RPC `reserve_stock` is called per item — it checks available stock
  /// and increments `stock_reserved` atomically on the DB side.
  Future<OrderModel> createOrder({
    required String customerName,
    String? customerPhone,
    String? customerAddress,
    required List<OrderItemInput> items,
  }) async {
    try {
      // Calculate total
      final total = items.fold<double>(
        0,
        (sum, item) => sum + (item.unitPrice * item.quantity),
      );

      // Create the order
      final orderData = await _client
          .from(SupabaseConstants.ordersTable)
          .insert({
            'customer_name': customerName,
            'customer_phone': customerPhone,
            'customer_address': customerAddress,
            'status': OrderStatus.pending.name,
            'total_amount': total,
          })
          .select()
          .single();

      final orderId = orderData['id'] as String;

      // Insert order items
      final itemRows = items
          .map((item) => {
                'order_id': orderId,
                'variant_id': item.variantId,
                'quantity': item.quantity,
                'unit_price': item.unitPrice,
                'subtotal': item.unitPrice * item.quantity,
              })
          .toList();

      await _client
          .from(SupabaseConstants.orderItemsTable)
          .insert(itemRows);

      // Atomically reserve stock for the order via Postgres RPC
      try {
        await _client.rpc(
          SupabaseConstants.reserveStockRpc,
          params: {
            'p_order_id': orderId,
          },
        );
      } on PostgrestException catch (e) {
        // Roll back: cancel the order (best effort)
        await _client
            .from(SupabaseConstants.ordersTable)
            .update({'status': OrderStatus.cancelled.name})
            .eq('id', orderId);
        throw StockReservationException(
          'Stock reservation failed: ${e.message}',
        );
      }

      return getOrderById(orderId);
    } on StockReservationException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<OrderModel> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    try {
      if (newStatus == OrderStatus.delivered) {
        await confirmStockDeduction(orderId);
      } else if (newStatus == OrderStatus.cancelled) {
        await releaseOrderStock(orderId);
      }

      final data = await _client
          .from(SupabaseConstants.ordersTable)
          .update({
            'status': newStatus.name,
          })
          .eq('id', orderId)
          .select(_orderSelect)
          .single();
      return OrderModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<OrderModel> cancelOrder(String orderId) async {
    try {
      await releaseOrderStock(orderId);

      return updateOrderStatus(
        orderId: orderId,
        newStatus: OrderStatus.cancelled,
      );
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> releaseOrderStock(String orderId) async {
    try {
      await _client.rpc(
        SupabaseConstants.releaseStockRpc,
        params: {
          'p_order_id': orderId,
        },
      );
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> confirmStockDeduction(String orderId) async {
    try {
      await _client.rpc(
        SupabaseConstants.commitOrderStockRpc,
        params: {
          'p_order_id': orderId,
        },
      );
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
