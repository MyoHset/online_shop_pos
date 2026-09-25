import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../payment/domain/entities/payment.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../../domain/entities/discount.dart';
import '../../domain/entities/order.dart';
import '../providers/order_detail_provider.dart';
import '../widgets/discount_input.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        Widget content;
        if (isWide) {
          content = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 120),
                  children: [
                    _OrderMetaCard(order: order),
                    _OrderItemsSection(order: order),
                    _PaymentPanel(orderId: order.id),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 120, top: 16),
                  children: [
                    HorizontalStatusTracker(status: order.status),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(height: 32),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: VerticalStatusTimeline(order: order),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          content = ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              _OrderMetaCard(order: order),
              _OrderItemsSection(order: order),
              _PaymentPanel(orderId: order.id),
              HorizontalStatusTracker(status: order.status),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(height: 32),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: VerticalStatusTimeline(order: order),
              ),
            ],
          );
        }

        return Stack(
          children: [
            content,

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
                      color: Colors.black.withValues(alpha: 0.05),
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
      },
    );
  }

  void _showUpdateStatusModal(BuildContext context) {
    if (context.isMobile) {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => SafeArea(
          child: _UpdateStatusModalContent(
            order: order,
            onStatusUpdate: onStatusUpdate,
            onCancel: onCancel,
            isDialog: false,
          ),
        ),
      );
    } else {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: _UpdateStatusModalContent(
              order: order,
              onStatusUpdate: onStatusUpdate,
              onCancel: onCancel,
              isDialog: true,
            ),
          ),
        ),
      );
    }
  }
}

class _UpdateStatusModalContent extends StatelessWidget {
  const _UpdateStatusModalContent({
    required this.order,
    required this.onStatusUpdate,
    required this.onCancel,
    this.isDialog = false,
  });

  final Order order;
  final ValueChanged<OrderStatus> onStatusUpdate;
  final VoidCallback onCancel;
  final bool isDialog;

  @override
  Widget build(BuildContext context) {
    final nextStatuses = order.status.nextStatuses;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isDialog
            ? BorderRadius.circular(16)
            : const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: isDialog
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.fromLTRB(24, isDialog ? 24 : 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle (mobile sheet only)
          if (!isDialog)
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.slate300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Update Order Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                ),
              ),
              IconButton(
                icon:
                    const Icon(Icons.close, color: AppColors.slate500, size: 20),
                onPressed: () => Navigator.of(context).pop(),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (nextStatuses.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Order is finalized and cannot be updated.',
                style: TextStyle(color: AppColors.slate500),
              ),
            )
          else
            ...nextStatuses.map((s) {
              final isDanger = s == OrderStatus.cancelled;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppButton(
                  label:
                      isDanger ? 'Cancel Order' : 'Mark as ${s.displayLabel}',
                  variant: isDanger
                      ? AppButtonVariant.danger
                      : AppButtonVariant.primary,
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
    );
  }
}

// ── Order Meta Card (Type + Customer Info) ──────────────────────────────────

class _OrderMetaCard extends StatelessWidget {
  const _OrderMetaCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final isOnline = order.orderType == OrderType.online;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Type + ID Row
          Row(
            children: [
              _OrderTypeBadge(orderType: order.orderType),
              const Spacer(),
              Text(
                'Order #${order.id.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.slate100, height: 1),
          const SizedBox(height: 16),

          // Customer Info
          _MetaRow(
            icon: Icons.person_outline,
            label: 'Customer',
            value: order.customerName.isEmpty ? 'Walk-in Customer' : order.customerName,
          ),
          if (order.customerPhone != null && order.customerPhone!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _MetaRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              value: order.customerPhone!,
            ),
          ],
          if (isOnline && order.customerAddress != null && order.customerAddress!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _MetaRow(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: order.customerAddress!,
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderTypeBadge extends StatelessWidget {
  const _OrderTypeBadge({required this.orderType});
  final OrderType orderType;

  @override
  Widget build(BuildContext context) {
    final isOnline = orderType == OrderType.online;
    final bgColor = isOnline ? AppColors.infoBg : AppColors.successBg;
    final fgColor = isOnline ? AppColors.info : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fgColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(orderType.iconLabel, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(
            orderType.displayLabel,
            style: TextStyle(
              color: fgColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.slate400),
        const SizedBox(width: 8),
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.slate500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.slate800,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Payment Panel ────────────────────────────────────────────────────────────

class _PaymentPanel extends ConsumerWidget {
  const _PaymentPanel({required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(orderPaymentsProvider(orderId));

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
            children: [
              const Icon(Icons.payment_outlined, size: 18, color: AppColors.slate700),
              const SizedBox(width: 8),
              const Text(
                'Payment',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                ),
              ),
              const Spacer(),
              paymentsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (payments) {
                  final isPaid = payments.any((p) => p.status == PaymentStatus.paid);
                  final hasPartial = payments.any((p) => p.status == PaymentStatus.partial);
                  if (isPaid) return _PaymentStatusPill.paid();
                  if (hasPartial) return _PaymentStatusPill.partial();
                  if (payments.isNotEmpty) return _PaymentStatusPill.pending();
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          paymentsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('Failed to load payments', style: const TextStyle(color: AppColors.danger, fontSize: 13)),
            ),
            data: (payments) {
              if (payments.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    'No payment recorded yet.',
                    style: TextStyle(color: AppColors.slate400, fontSize: 13),
                  ),
                );
              }
              return Column(
                children: [
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.slate100, height: 1),
                  const SizedBox(height: 12),
                  ...payments.map((p) => _PaymentMethodRow(payment: p)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  const _PaymentMethodRow({required this.payment});
  final Payment payment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          _PaymentMethodIcon(method: payment.method),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.method.displayLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate800,
                  ),
                ),
                if (payment.paidAt != null)
                  Text(
                    _formatDate(payment.paidAt!),
                    style: const TextStyle(fontSize: 11, color: AppColors.slate400),
                  ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(payment.amount),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(width: 8),
          _PaymentStatusDot(status: payment.status),
        ],
      ),
    );
  }

  static String _formatDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}';
}

class _PaymentMethodIcon extends StatelessWidget {
  const _PaymentMethodIcon({required this.method});
  final PaymentMethod method;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color color) = switch (method) {
      PaymentMethod.cod => (Icons.money_outlined, AppColors.success),
      PaymentMethod.kbzPay => (Icons.account_balance_wallet_outlined, const Color(0xFF1565C0)),
      PaymentMethod.wavePay => (Icons.waves_outlined, const Color(0xFFE65100)),
      PaymentMethod.bankTransfer => (Icons.account_balance_outlined, AppColors.slate700),
      PaymentMethod.credit => (Icons.credit_card_outlined, const Color(0xFF7C3AED)),
    };

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

class _PaymentStatusDot extends StatelessWidget {
  const _PaymentStatusDot({required this.status});
  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color color, String label) = switch (status) {
      PaymentStatus.paid => (AppColors.success, 'Paid'),
      PaymentStatus.partial => (AppColors.warning, 'Partial'),
      PaymentStatus.pending => (AppColors.slate400, 'Pending'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PaymentStatusPill extends StatelessWidget {
  const _PaymentStatusPill({required this.label, required this.color});
  final String label;
  final Color color;

  factory _PaymentStatusPill.paid() =>
      const _PaymentStatusPill(label: '✓ Paid', color: AppColors.success);
  factory _PaymentStatusPill.partial() =>
      const _PaymentStatusPill(label: '~ Partial', color: AppColors.warning);
  factory _PaymentStatusPill.pending() =>
      const _PaymentStatusPill(label: '○ Pending', color: AppColors.slate500);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Order Items Section ──────────────────────────────────────────────────────

class _OrderItemsSection extends ConsumerWidget {
  const _OrderItemsSection({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate900,
                ),
              ),
              Text(
                '${order.items.length} items',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.slate500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Table Header
          const Row(
            children: [
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

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.slate600,
                ),
              ),
              Text(
                CurrencyFormatter.format(order.subtotalAmount),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Discount line (interactive if active, read-only if final)
          DiscountInput(
            subtotal: order.subtotalAmount,
            discount: order.discount,
            readOnly: order.status.isFinal,
            onApply: (discount) async {
              await ref
                  .read(orderDetailProvider(order.id).notifier)
                  .updateDiscount(discount);
            },
            onRemove: () async {
              await ref
                  .read(orderDetailProvider(order.id).notifier)
                  .updateDiscount(const Discount.none());
            },
          ),
          const SizedBox(height: 10),
          const Divider(height: 16, color: AppColors.slate200),
          const SizedBox(height: 8),

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
