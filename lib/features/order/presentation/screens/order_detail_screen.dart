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
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final extraItems = order.items.length > 1 ? order.items.length - 1 : 0;
    
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            // Product Summary Card
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.slate200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.slate50,
                      borderRadius: BorderRadius.circular(16),
                      image: firstItem?.variantImageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(firstItem!.variantImageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: firstItem?.variantImageUrl == null
                        ? const Icon(Icons.inventory_2_outlined, color: AppColors.slate300)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstItem?.productName ?? 'Order #${order.id.substring(0, 5)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${firstItem?.variantDisplayName ?? order.customerName}${extraItems > 0 ? ' (+$extraItems items)' : ''}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.slate500,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          CurrencyFormatter.format(order.totalAmount),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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
