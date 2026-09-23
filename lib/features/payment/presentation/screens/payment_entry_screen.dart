import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../order/presentation/providers/order_detail_provider.dart';
import '../../domain/entities/payment.dart';
import '../providers/payment_provider.dart';

/// Payment entry and management screen for an order.
class PaymentEntryScreen extends ConsumerWidget {
  const PaymentEntryScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(orderPaymentsProvider(orderId));
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    final double orderTotal = orderAsync.value?.totalAmount ?? 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: paymentsAsync.when(
        loading: () => const AppLoadingWidget(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.refresh(orderPaymentsProvider(orderId).future),
        ),
        data: (payments) {
          final totalPaid =
              payments.fold<double>(0, (s, p) => s + p.amount);
          final remaining = (orderTotal - totalPaid).clamp(0, orderTotal);

          return _PaymentBody(
            orderId: orderId,
            payments: payments,
            orderTotal: orderTotal,
            totalPaid: totalPaid,
            remaining: remaining.toDouble(),
          );
        },
      ),
    );
  }
}

class _PaymentBody extends ConsumerWidget {
  const _PaymentBody({
    required this.orderId,
    required this.payments,
    required this.orderTotal,
    required this.totalPaid,
    required this.remaining,
  });

  final String orderId;
  final List<Payment> payments;
  final double orderTotal;
  final double totalPaid;
  final double remaining;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxWidth = context.responsiveValue<double>(
      mobile: double.infinity,
      tablet: 600,
      desktop: 680,
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPadding,
            vertical: 24,
          ),
          children: [
            _PaymentSummaryCard(
              orderTotal: orderTotal,
              totalPaid: totalPaid,
              remaining: remaining,
            ),
            const SizedBox(height: 24),
            if (payments.isNotEmpty) ...[
              _PaymentHistorySection(
                payments: payments,
                orderId: orderId,
              ),
              const SizedBox(height: 24),
            ],
            if (remaining > 0) ...[
              _AddPaymentForm(
                orderId: orderId,
                remainingAmount: remaining,
              ),
            ] else
              _PaidInFullBanner(),
          ],
        ),
      ),
    );
  }
}

class _PaymentSummaryCard extends StatelessWidget {
  const _PaymentSummaryCard({
    required this.orderTotal,
    required this.totalPaid,
    required this.remaining,
  });

  final double orderTotal;
  final double totalPaid;
  final double remaining;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPaidInFull = remaining <= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Order Total',
                  style: TextStyle(color: AppColors.slate500, fontSize: 13)),
              Text(CurrencyFormatter.format(orderTotal),
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Paid',
                  style: TextStyle(color: AppColors.slate500, fontSize: 13)),
              Text(CurrencyFormatter.format(totalPaid),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  )),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isPaidInFull ? 'Paid in Full' : 'Remaining Balance',
                style: TextStyle(
                  color:
                      isPaidInFull ? AppColors.success : AppColors.danger,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                CurrencyFormatter.format(remaining),
                style: TextStyle(
                  color:
                      isPaidInFull ? AppColors.success : AppColors.danger,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentHistorySection extends ConsumerWidget {
  const _PaymentHistorySection({
    required this.payments,
    required this.orderId,
  });

  final List<Payment> payments;
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment History',
            style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700, color: AppColors.slate700)),
        const SizedBox(height: 12),
        ...payments.map(
          (p) => _PaymentHistoryRow(
            payment: p,
            onMarkPaid: p.status != PaymentStatus.paid
                ? () => ref
                    .read(orderPaymentsProvider(orderId).notifier)
                    .markAsPaid(p.id)
                : null,
          ),
        ),
      ],
    );
  }
}

class _PaymentHistoryRow extends StatelessWidget {
  const _PaymentHistoryRow({required this.payment, this.onMarkPaid});

  final Payment payment;
  final VoidCallback? onMarkPaid;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.method.displayLabel,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                  _formatDateTime(payment.createdAt),
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.slate400),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(CurrencyFormatter.format(payment.amount),
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(width: 12),
          _PaymentStatusBadge(status: payment.status),
          if (onMarkPaid != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.check_circle_outline,
                  color: AppColors.success, size: 22),
              tooltip: 'Mark as paid',
              onPressed: onMarkPaid,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
    );
  }

  static String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _PaymentStatusBadge extends StatelessWidget {
  const _PaymentStatusBadge({required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      PaymentStatus.paid => const StatusBadge.success(
          label: 'Paid', size: StatusBadgeSize.small),
      PaymentStatus.partial => const StatusBadge.warning(
          label: 'Partial', size: StatusBadgeSize.small),
      PaymentStatus.pending => const StatusBadge.warning(
          label: 'Pending', size: StatusBadgeSize.small),
    };
  }
}

class _AddPaymentForm extends ConsumerStatefulWidget {
  const _AddPaymentForm({
    required this.orderId,
    required this.remainingAmount,
  });

  final String orderId;
  final double remainingAmount;

  @override
  ConsumerState<_AddPaymentForm> createState() => _AddPaymentFormState();
}

class _AddPaymentFormState extends ConsumerState<_AddPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  PaymentMethod _method = PaymentMethod.cod;
  PaymentStatus _status = PaymentStatus.paid;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountCtrl.text = widget.remainingAmount.round().toString();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    final error = await ref
        .read(orderPaymentsProvider(widget.orderId).notifier)
        .recordPayment(method: _method, amount: amount, status: _status);

    if (mounted) {
      setState(() => _isLoading = false);
      if (error == null) {
        AppSnackBar.showSuccess(
          context,
          'Payment recorded successfully',
        );
      } else {
        AppSnackBar.showError(
          context,
          'Failed to record payment: $error',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Record Payment',
            style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700, color: AppColors.slate700)),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FieldLabel(label: 'Payment Method'),
              const SizedBox(height: 8),
              _PaymentMethodSelector(
                selected: _method,
                onChanged: (m) => setState(() => _method = m),
              ),
              const SizedBox(height: 16),
              const _FieldLabel(label: 'Amount (MMK) *'),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(prefixText: 'K '),
                validator: (v) =>
                    Validators.positiveNumber(v, fieldName: 'Amount'),
              ),
              const SizedBox(height: 16),
              const _FieldLabel(label: 'Payment Status'),
              DropdownButtonFormField<PaymentStatus>(
                value: _status,
                onChanged: (s) => setState(() => _status = s!),
                decoration: const InputDecoration(),
                items: PaymentStatus.values
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.displayLabel),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Record Payment',
                onPressed: _submit,
                isLoading: _isLoading,
                icon: const Icon(Icons.payment_outlined, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  const _PaymentMethodSelector({
    required this.selected,
    required this.onChanged,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: PaymentMethod.values.map((m) {
          final isSelected = m == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(m.displayLabel),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) onChanged(m);
              },
              selectedColor: AppColors.greenNude,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.slate900 : AppColors.slate600,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected ? Colors.transparent : AppColors.slate200,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PaidInFullBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle_outline_rounded,
              color: AppColors.success, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Paid in Full',
                    style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                Text('This order has been fully paid.',
                    style: TextStyle(
                        color: AppColors.success, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.slate600)),
    );
  }
}
