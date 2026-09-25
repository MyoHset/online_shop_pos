import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_data_table.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_transaction.dart';
import '../providers/customer_provider.dart';
import '../widgets/customer_form_dialog.dart';
import '../widgets/record_repayment_dialog.dart';

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  void _copyStatement(BuildContext context, Customer customer,
      List<CustomerTransaction> transactions) {
    final buffer = StringBuffer();
    buffer.writeln('===================================');
    buffer.writeln('CUSTOMER STATEMENT - ${customer.name.toUpperCase()}');
    buffer.writeln('Phone: ${customer.phone}');
    if (customer.address != null)
      buffer.writeln('Address: ${customer.address}');
    buffer.writeln('Repayment Terms: ${customer.repaymentCycle.displayLabel}');
    buffer.writeln(
        'Outstanding Debt: ${CurrencyFormatter.format(customer.currentDebt)}');
    buffer.writeln(
        'Credit Limit: ${customer.creditLimit > 0 ? CurrencyFormatter.format(customer.creditLimit) : 'Unlimited'}');
    buffer.writeln(
        'Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}');
    buffer.writeln('-----------------------------------');
    buffer.writeln('DATE        | TYPE        | AMOUNT       | BALANCE');
    buffer.writeln('-----------------------------------');

    for (final t in transactions) {
      final dateStr = DateFormat('yyyy-MM-dd').format(t.createdAt);
      final isRepay = t.transactionType == CustomerTransactionType.repayment;
      final typeStr = isRepay ? 'Repayment ' : 'CreditSale';
      final amtStr =
          '${isRepay ? '-' : '+'}${CurrencyFormatter.format(t.amount)}';
      final balStr = CurrencyFormatter.format(t.balanceAfter);
      buffer.writeln('$dateStr | $typeStr | $amtStr | $balStr');
    }
    buffer.writeln('===================================');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    AppSnackBar.showSuccess(context, 'Statement copied to clipboard!');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerAsync = ref.watch(customerDetailProvider(customerId));
    final transactionsAsync =
        ref.watch(customerTransactionsProvider(customerId));
    final theme = Theme.of(context);
    final isDesktop = DeviceType.from(context) == DeviceType.desktop ||
        DeviceType.from(context) == DeviceType.large ||
        DeviceType.from(context) == DeviceType.tablet;

    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        title: const Text('Customer Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.slate900),
        actions: [
          if (customerAsync.hasValue)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Copy Statement to Clipboard',
              onPressed: () {
                final customer = customerAsync.value!;
                final txs = transactionsAsync.value ?? [];
                _copyStatement(context, customer, txs);
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: customerAsync.when(
        loading: () => const AppLoadingWidget(),
        error: (err, _) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(customerDetailProvider(customerId)),
        ),
        data: (customer) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(customerDetailProvider(customerId));
              await ref
                  .read(customerTransactionsProvider(customerId).notifier)
                  .refresh();
            },
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Top Info & Credit Status
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: _CustomerProfileCard(customer: customer)),
                      const SizedBox(width: 20),
                      Expanded(
                          flex: 2,
                          child: _CustomerCreditCard(customer: customer)),
                    ],
                  )
                else ...[
                  _CustomerProfileCard(customer: customer),
                  const SizedBox(height: 16),
                  _CustomerCreditCard(customer: customer),
                ],

                const SizedBox(height: 32),

                // Transactions / Ledger Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction & Repayment History (Ledger)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            final txs = transactionsAsync.value ?? [];
                            _copyStatement(context, customer, txs);
                          },
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy Statement'),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 20),
                          tooltip: 'Refresh',
                          onPressed: () => ref
                              .read(customerTransactionsProvider(customerId)
                                  .notifier)
                              .refresh(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Transactions Table
                transactionsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (err, _) => Text('Error: $err',
                      style: const TextStyle(color: AppColors.danger)),
                  data: (transactions) {
                    if (transactions.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.slate200),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'No transaction history found',
                          style: TextStyle(color: AppColors.slate500),
                        ),
                      );
                    }

                    return AppDataTable(
                      columns: const [
                        DataColumn(
                            label: Text('Date & Time',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700))),
                        DataColumn(
                            label: Text('Type',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700))),
                        DataColumn(
                            label: Text('Amount',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700))),
                        DataColumn(
                            label: Text('Method',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700))),
                        DataColumn(
                            label: Text('Balance After',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700))),
                        DataColumn(
                            label: Text('Notes',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700))),
                      ],
                      rows: transactions.map((t) {
                        final isRepayment = t.transactionType ==
                            CustomerTransactionType.repayment;
                        final dateStr = DateFormat('yyyy-MM-dd HH:mm')
                            .format(t.createdAt.toLocal());
                    
                        return DataRow(
                          cells: [
                            DataCell(Text(dateStr,
                                style: const TextStyle(fontSize: 12))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isRepayment
                                      ? AppColors.successBg
                                      : AppColors.dangerBg,
                                  borderRadius:
                                      BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isRepayment
                                      ? 'Repayment'
                                      : (t.transactionType ==
                                              CustomerTransactionType
                                                  .openingBalance
                                          ? 'Opening Debt'
                                          : 'Credit Sale'),
                                  style: TextStyle(
                                    color: isRepayment
                                        ? AppColors.success
                                        : AppColors.danger,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${isRepayment ? '-' : '+'} ${CurrencyFormatter.format(t.amount)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: isRepayment
                                      ? AppColors.success
                                      : AppColors.slate900,
                                ),
                              ),
                            ),
                            DataCell(Text(t.paymentMethod.toUpperCase(),
                                style: const TextStyle(fontSize: 12))),
                            DataCell(
                              Text(
                                CurrencyFormatter.format(
                                    t.balanceAfter),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13),
                              ),
                            ),
                            DataCell(Text(t.notes ?? '-',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.slate600))),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomerProfileCard extends ConsumerWidget {
  const _CustomerProfileCard({required this.customer});

  final Customer customer;

  Future<void> _toggleSuspension(BuildContext context, WidgetRef ref) async {
    final willSuspend = !customer.isSuspended;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(willSuspend
            ? 'Suspend Customer Account?'
            : 'Reactivate Customer Account?'),
        content: Text(
          willSuspend
              ? 'Suspending this account will block future credit sales for ${customer.name}.'
              : 'Reactivating this account will allow future credit sales for ${customer.name}.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor:
                  willSuspend ? AppColors.danger : AppColors.success,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(willSuspend ? 'Suspend' : 'Reactivate'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    final success = await ref
        .read(customerControllerProvider.notifier)
        .toggleSuspendCustomer(id: customer.id, isSuspended: willSuspend);

    if (context.mounted && success) {
      AppSnackBar.showSuccess(
        context,
        willSuspend
            ? 'Account has been suspended.'
            : 'Account has been reactivated.',
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: customer.isSuspended
                        ? AppColors.dangerBg
                        : AppColors.slate100,
                    child: Text(
                      customer.name.isNotEmpty
                          ? customer.name.characters.first.toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: customer.isSuspended
                            ? AppColors.danger
                            : AppColors.slate800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(customer.name,
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: customer.isSuspended
                                  ? AppColors.dangerBg
                                  : AppColors.successBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              customer.isSuspended ? 'Suspended' : 'Active',
                              style: TextStyle(
                                color: customer.isSuspended
                                    ? AppColors.danger
                                    : AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(customer.phone,
                          style: const TextStyle(
                              color: AppColors.slate500, fontSize: 14)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      customer.isSuspended
                          ? Icons.lock_open_outlined
                          : Icons.lock_outline,
                      color: customer.isSuspended
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                    tooltip: customer.isSuspended
                        ? 'Reactivate Account'
                        : 'Suspend Account',
                    onPressed: () => _toggleSuspension(context, ref),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        CustomerFormDialog.show(context, customer: customer),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 32),
          _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: customer.address ?? '-'),
          const SizedBox(height: 12),
          _InfoRow(
              icon: Icons.schedule_outlined,
              label: 'Repayment Cycle',
              value: customer.repaymentCycle.displayLabel),
          if (customer.notes != null && customer.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoRow(
                icon: Icons.note_outlined,
                label: 'Notes',
                value: customer.notes!),
          ],
        ],
      ),
    );
  }
}

class _CustomerCreditCard extends StatelessWidget {
  const _CustomerCreditCard({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Credit & Debt Status',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.slate900),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  customer.hasDebt ? AppColors.dangerBg : AppColors.successBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Outstanding Debt',
                    style: TextStyle(fontSize: 12, color: AppColors.slate600)),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(customer.currentDebt),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color:
                        customer.hasDebt ? AppColors.danger : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Credit Limit:',
                  style: TextStyle(color: AppColors.slate600, fontSize: 13)),
              Text(
                customer.creditLimit > 0
                    ? CurrencyFormatter.format(customer.creditLimit)
                    : 'Unlimited',
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Remaining Credit:',
                  style: TextStyle(color: AppColors.slate600, fontSize: 13)),
              Text(
                customer.creditLimit > 0
                    ? CurrencyFormatter.format(customer.remainingCredit)
                    : '-',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.info),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Record Repayment',
            icon: const Icon(Icons.payments_outlined),
            onPressed: () => RecordRepaymentDialog.show(context, customer),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.slate500),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: Text(label,
              style: const TextStyle(color: AppColors.slate500, fontSize: 13)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.slate800)),
        ),
      ],
    );
  }
}
