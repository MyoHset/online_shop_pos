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
import '../widgets/order_item_row.dart';
import '../widgets/order_status_badge.dart';

/// Order detail screen — shows customer info, items, status actions.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return orderAsync.when(
      loading: () => const Scaffold(body: AppLoadingWidget()),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorWidget(
          message: e.toString(),
          onRetry: () =>
              ref.refresh(orderDetailProvider(orderId).future),
        ),
      ),
      data: (order) => _OrderDetailView(
        order: order,
        onStatusUpdate: (status) =>
            ref.read(orderDetailProvider(orderId).notifier).updateStatus(status),
        onCancel: () =>
            ref.read(orderDetailProvider(orderId).notifier).cancel(),
      ),
    );
  }
}

class _OrderDetailView extends StatelessWidget {
  const _OrderDetailView({
    required this.order,
    required this.onStatusUpdate,
    required this.onCancel,
  });

  final Order order;
  final Future<bool> Function(OrderStatus) onStatusUpdate;
  final Future<bool> Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: OrderStatusBadge(status: order.status),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _CustomerInfoSection(order: order),
          ),
          SliverToBoxAdapter(
            child: _ItemsSection(order: order),
          ),
          SliverToBoxAdapter(
            child: _TotalSection(order: order),
          ),
          if (!order.status.isFinal)
            SliverToBoxAdapter(
              child: _StatusActionsSection(
                order: order,
                onStatusUpdate: onStatusUpdate,
                onCancel: onCancel,
              ),
            ),
          SliverToBoxAdapter(
            child: _PaymentActionSection(order: order),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _CustomerInfoSection extends StatelessWidget {
  const _CustomerInfoSection({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.slate500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            order.customerName,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (order.customerPhone != null) ...[
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.phone_outlined,
                  size: 14, color: AppColors.slate400),
              const SizedBox(width: 6),
              Text(order.customerPhone!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.slate500)),
            ]),
          ],
          if (order.customerAddress != null) ...[
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: AppColors.slate400),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(order.customerAddress!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.slate500)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ItemsSection extends StatelessWidget {
  const _ItemsSection({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.slate500,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 12),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OrderItemRow(item: item),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalSection extends StatelessWidget {
  const _TotalSection({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            CurrencyFormatter.format(order.totalAmount),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.slate900,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusActionsSection extends StatefulWidget {
  const _StatusActionsSection({
    required this.order,
    required this.onStatusUpdate,
    required this.onCancel,
  });

  final Order order;
  final Future<bool> Function(OrderStatus) onStatusUpdate;
  final Future<bool> Function() onCancel;

  @override
  State<_StatusActionsSection> createState() => _StatusActionsSectionState();
}

class _StatusActionsSectionState extends State<_StatusActionsSection> {
  bool _isLoading = false;

  Future<void> _handleStatusChange(OrderStatus newStatus) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _StatusChangeDialog(
        currentStatus: widget.order.status,
        newStatus: newStatus,
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);
    if (newStatus == OrderStatus.cancelled) {
      await widget.onCancel();
    } else {
      await widget.onStatusUpdate(newStatus);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final nextStatuses = widget.order.status.nextStatuses;

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Status',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.slate500,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            const Center(child: AppLoadingWidget())
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: nextStatuses.map((s) {
                final isDanger = s == OrderStatus.cancelled;
                return AppButton(
                  label: s.displayLabel,
                  variant: isDanger
                      ? AppButtonVariant.danger
                      : AppButtonVariant.secondary,
                  onPressed: () => _handleStatusChange(s),
                  minimumWidth: 120,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _StatusChangeDialog extends StatelessWidget {
  const _StatusChangeDialog({
    required this.currentStatus,
    required this.newStatus,
  });

  final OrderStatus currentStatus;
  final OrderStatus newStatus;

  @override
  Widget build(BuildContext context) {
    final isCancellation = newStatus == OrderStatus.cancelled;

    return AlertDialog(
      title: Text(
        isCancellation ? 'Cancel Order?' : 'Update Status',
      ),
      content: Text(
        isCancellation
            ? 'This will cancel the order and release all reserved stock back to inventory. This cannot be undone.'
            : 'Change order status from "${currentStatus.displayLabel}" to "${newStatus.displayLabel}"?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: isCancellation
              ? FilledButton.styleFrom(
                  backgroundColor: AppColors.danger)
              : null,
          child: Text(isCancellation ? 'Cancel Order' : 'Confirm'),
        ),
      ],
    );
  }
}

class _PaymentActionSection extends StatelessWidget {
  const _PaymentActionSection({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    if (order.status == OrderStatus.cancelled) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      child: AppButton(
        label: 'Manage Payment',
        icon: const Icon(Icons.payment_outlined, size: 18),
        variant: AppButtonVariant.secondary,
        onPressed: () => context.pushNamed(
          'orderPayment',
          pathParameters: {'id': order.id},
        ),
      ),
    );
  }
}
