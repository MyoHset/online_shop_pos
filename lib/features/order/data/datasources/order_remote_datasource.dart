import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/discount.dart';
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

  String _parsePostgrestErrorMessage(PostgrestException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('discount') &&
        (msg.contains('limit') || msg.contains('exceed') || msg.contains('allowed'))) {
      return 'Discount exceeds your limit — ask a manager';
    }
    return e.message;
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
    DiscountType discountType = DiscountType.none,
    double discountValue = 0.0,
    String? discountReason,
    String? shopId,
  }) async {
    try {
      // Calculate total
      final subtotal = items.fold<double>(
        0,
        (sum, item) => sum + (item.unitPrice * item.quantity),
      );
      final discountObj = Discount(type: discountType, value: discountValue);
      final discountAmount = discountObj.calculateAmount(subtotal);
      final estimatedTotal =
          (subtotal - discountAmount).clamp(0.0, double.infinity);

      // Create the order
      final orderPayload = {
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'customer_address': customerAddress,
        'status': OrderStatus.pending.name,
        'total_amount': estimatedTotal,
        'discount_type': discountType.value,
        'discount_value': discountValue,
        if (discountReason != null && discountReason.isNotEmpty)
          'discount_reason': discountReason,
        if (shopId != null) 'shop_id': shopId,
      };
      
      AppLogger.logEvent('createOrder_request', details: {'payload': orderPayload});

      final orderData = await _client
          .from(SupabaseConstants.ordersTable)
          .insert(orderPayload)
          .select()
          .single();

      final orderId = orderData['id'] as String;
      AppLogger.logDataSuccess('createOrder_response', data: orderData);

      try {
        // Insert order items
        final itemRows = items
            .map((item) => <String, dynamic>{
                  'order_id': orderId,
                  'variant_id': item.variantId,
                  'quantity': item.quantity,
                  'unit_price': item.unitPrice,
                })
            .toList();
            
        AppLogger.logEvent('createOrder_items_request', details: {'payload': itemRows});

        final itemsResponse = await _client
            .from(SupabaseConstants.orderItemsTable)
            .insert(itemRows)
            .select();
            
        AppLogger.logDataSuccess('createOrder_items_response', data: itemsResponse);

        // Atomically reserve stock for the order via Postgres RPC
        final params = {'p_order_id': orderId};
        await _client.rpc(
          SupabaseConstants.reserveStockRpc,
          params: params,
        );
        AppLogger.logRpcSuccess(SupabaseConstants.reserveStockRpc, params: params);
      } catch (e, st) {
        AppLogger.logRpcError(
          'createOrder_items_or_stock_failed',
          e,
          params: {'p_order_id': orderId},
          stackTrace: st,
        );
        
        // Roll back: delete the order completely to avoid partial records
        await _client
            .from(SupabaseConstants.ordersTable)
            .delete()
            .eq('id', orderId);

        if (e is PostgrestException) {
          throw StockReservationException(
            'Order failed: ${_parsePostgrestErrorMessage(e)}',
          );
        }
        rethrow;
      }

      return getOrderById(orderId);
    } on StockReservationException catch (e, st) {
      AppLogger.logDataError('createOrder', e, stackTrace: st);
      rethrow;
    } on PostgrestException catch (e, st) {
      AppLogger.logDataError('createOrder_supabase_error', e, stackTrace: st);
      throw ServerException(_parsePostgrestErrorMessage(e));
    } catch (e, st) {
      AppLogger.logDataError('createOrder_unexpected_error', e, stackTrace: st);
      throw ServerException(e.toString());
    }
  }

  /// Creates a quick sale order, atomic stock deduction, and payment record.
  Future<OrderModel> completeInstantSale({
    String? customerName,
    required List<OrderItemInput> items,
    required String paymentMethod,
    DiscountType discountType = DiscountType.none,
    double discountValue = 0.0,
    String? discountReason,
    String? shopId,
  }) async {
    try {
      final subtotal = items.fold<double>(
        0,
        (sum, item) => sum + (item.unitPrice * item.quantity),
      );
      final discountObj = Discount(type: discountType, value: discountValue);
      final discountAmount = discountObj.calculateAmount(subtotal);
      final finalAmount = (subtotal - discountAmount).clamp(0.0, double.infinity);

      final orderPayload = {
        if (customerName != null && customerName.isNotEmpty) 'customer_name': customerName,
        'status': OrderStatus.pending.name,
        'order_type': 'in_store',
        'total_amount': finalAmount,
        'discount_type': discountType.value,
        'discount_value': discountValue,
        if (discountReason != null && discountReason.isNotEmpty)
          'discount_reason': discountReason,
        if (shopId != null) 'shop_id': shopId,
      };

      final orderData = await _client
          .from(SupabaseConstants.ordersTable)
          .insert(orderPayload)
          .select()
          .single();

      final orderId = orderData['id'] as String;

      try {
        final itemRows = items
            .map((item) => <String, dynamic>{
                  'order_id': orderId,
                  'variant_id': item.variantId,
                  'quantity': item.quantity,
                  'unit_price': item.unitPrice,
                })
            .toList();

        await _client
            .from(SupabaseConstants.orderItemsTable)
            .insert(itemRows)
            .select();

        final params = {'p_order_id': orderId};
        await _client.rpc('complete_instant_sale', params: params);

        await _client.from(SupabaseConstants.paymentsTable).insert({
          'order_id': orderId,
          'method': paymentMethod,
          'amount': finalAmount,
          'status': 'paid',
          'paid_at': DateTime.now().toUtc().toIso8601String(),
        });
      } catch (e) {
        await _client
            .from(SupabaseConstants.ordersTable)
            .delete()
            .eq('id', orderId);

        if (e is PostgrestException) {
          throw StockReservationException('Quick sale failed: ${_parsePostgrestErrorMessage(e)}');
        }
        rethrow;
      }

      return getOrderById(orderId);
    } on StockReservationException {
      rethrow;
    } on PostgrestException catch (e) {
      throw ServerException(_parsePostgrestErrorMessage(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Updates discount fields on an existing order.
  ///
  /// The database triggers automatically recompute `discount_amount` and `total_amount`.
  /// Re-fetches the order afterward to return the authoritative server state.
  Future<OrderModel> updateOrderDiscount({
    required String orderId,
    required DiscountType discountType,
    required double discountValue,
    String? discountReason,
  }) async {
    try {
      final updatePayload = <String, dynamic>{
        'discount_type': discountType.value,
        'discount_value': discountValue,
        'discount_reason': discountReason,
      };

      AppLogger.logEvent('updateOrderDiscount_request', details: {
        'order_id': orderId,
        'payload': updatePayload,
      });

      await _client
          .from(SupabaseConstants.ordersTable)
          .update(updatePayload)
          .eq('id', orderId);

      // Re-fetch to obtain server-calculated discount_amount and total_amount
      return getOrderById(orderId);
    } on PostgrestException catch (e, st) {
      AppLogger.logDataError('updateOrderDiscount_supabase_error', e, stackTrace: st);
      throw ServerException(_parsePostgrestErrorMessage(e));
    } catch (e, st) {
      AppLogger.logDataError('updateOrderDiscount_error', e, stackTrace: st);
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
    final params = {'p_order_id': orderId};
    try {
      await _client.rpc(
        SupabaseConstants.releaseStockRpc,
        params: params,
      );
      AppLogger.logRpcSuccess(SupabaseConstants.releaseStockRpc, params: params);
    } on PostgrestException catch (e, st) {
      AppLogger.logRpcError(SupabaseConstants.releaseStockRpc, e.message, params: params, stackTrace: st);
      throw ServerException(e.message);
    } catch (e, st) {
      AppLogger.logRpcError(SupabaseConstants.releaseStockRpc, e, params: params, stackTrace: st);
      throw ServerException(e.toString());
    }
  }

  Future<void> confirmStockDeduction(String orderId) async {
    final params = {'p_order_id': orderId};
    try {
      await _client.rpc(
        SupabaseConstants.commitOrderStockRpc,
        params: params,
      );
      AppLogger.logRpcSuccess(SupabaseConstants.commitOrderStockRpc, params: params);
    } on PostgrestException catch (e, st) {
      AppLogger.logRpcError(SupabaseConstants.commitOrderStockRpc, e.message, params: params, stackTrace: st);
      throw ServerException(e.message);
    } catch (e, st) {
      AppLogger.logRpcError(SupabaseConstants.commitOrderStockRpc, e, params: params, stackTrace: st);
      throw ServerException(e.toString());
    }
  }
}
