import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../domain/entities/order.dart';
import '../providers/order_detail_provider.dart';
import '../widgets/horizontal_status_tracker.dart';
import '../widgets/vertical_status_timeline.dart';

/// Minimalist order detail screen incorporating the tracking UI.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Track Order'),
        centerTitle: false,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: orderAsync.when(
        loading: () => const AppLoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.refresh(orderDetailProvider(orderId).future),
        ),
        data: (order) => _OrderDetailBody(
          order: order,
          onStatusUpdate: (status) =>
              ref.read(orderDetailProvider(orderId).notifier).updateStatus(status),
          onCancel: () =>
              ref.read(orderDetailProvider(orderId).notifier).cancel(),
        ),
      ),
    );
  }
}

class _OrderDetailBody extends StatelessWidget {
  const _OrderDetailBody({
    required this.order,
    required this.onStatusUpdate,
    required this.onCancel,
  });

  final Order order;
  final Future<bool> Function(OrderStatus) onStatusUpdate;
  final Future<bool> Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            // Order Items Comprehensive List
            _OrderItemsSection(order: order),

            // Horizontal Progress
            HorizontalStatusTracker(status: order.status),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(height: 32),
            ),

            // Vertical Timeline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: VerticalStatusTimeline(order: order),
            ),
          ],
        ),

        // Admin Bottom Action Bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: 16 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Payment',
                    variant: AppButtonVariant.secondary,
                    onPressed: () => context.pushNamed(
                      'orderPayment',
                      pathParameters: {'id': order.id},
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: 'Update Status',
                    onPressed: () => _showUpdateStatusModal(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showUpdateStatusModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final nextStatuses = order.status.nextStatuses;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Update Order Status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 24),
                if (nextStatuses.isEmpty)
                  const Text('Order is finalized and cannot be updated.')
                else
                  ...nextStatuses.map((s) {
                    final isDanger = s == OrderStatus.cancelled;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppButton(
                        label: isDanger ? 'Cancel Order' : 'Mark as ${s.displayLabel}',
                        variant: isDanger ? AppButtonVariant.danger : AppButtonVariant.primary,
                        onPressed: () {
                          Navigator.pop(context);
                          if (isDanger) {
                            onCancel();
                          } else {
                            onStatusUpdate(s);
                          }
                        },
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OrderItemsSection extends StatelessWidget {
  const _OrderItemsSection({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                ),
              ),
              Text(
                '${order.items.length} items',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.slate500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Table Header
          Row(
            children: const [
              Expanded(
                flex: 3,
                child: Text('Item', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slate500)),
              ),
              Expanded(
                flex: 1,
                child: Text('Qty', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slate500)),
              ),
              Expanded(
                flex: 2,
                child: Text('Total', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.slate500)),
              ),
            ],
          ),
          const Divider(height: 16, color: AppColors.slate200),
          // Items
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName ?? 'Unknown',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.slate900),
                        ),
                        if (item.variantDisplayName != null && item.variantDisplayName!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.variantDisplayName!,
                            style: const TextStyle(fontSize: 12, color: AppColors.slate500),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${item.quantity}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.slate700),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(item.subtotal),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.slate900),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(item.unitPrice),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 11, color: AppColors.slate400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 24, color: AppColors.slate200),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate600,
                ),
              ),
              Text(
                CurrencyFormatter.format(order.totalAmount),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.slate900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
