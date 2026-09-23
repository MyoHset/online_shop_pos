import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_data_table.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_transaction.dart';
import '../providers/customer_provider.dart';
import '../widgets/customer_form_dialog.dart';
import '../widgets/record_repayment_dialog.dart';

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

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
      ),
      body: customerAsync.when(
        loading: () => const AppLoadingWidget(),
        error: (err, _) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(customerDetailProvider(customerId)),
        ),
        data: (customer) {
          final listView = ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Top Info & Credit Status
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 3,
                        child: _CustomerProfileCard(customer: customer),),
                    const SizedBox(width: 20),
                    Expanded(
                        flex: 2,
                        child: _CustomerCreditCard(customer: customer),),
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
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    tooltip: 'Refresh',
                    onPressed: () => ref
                        .read(customerTransactionsProvider(customerId).notifier)
                        .refresh(),
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
                    style: const TextStyle(color: AppColors.danger),),
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
                        'No transaction records yet',
                        style: TextStyle(color: AppColors.slate500),
                      ),
                    );
                  }

                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.slate200),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AppDataTable(
                        minWidth: 700,
                        headingRowColor: AppColors.slate100,
                        columns: const [
                          DataColumn(
                              label: Text('Date',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700),),),
                          DataColumn(
                              label: Text('Type',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700),),),
                          DataColumn(
                              label: Text('Amount',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700),),),
                          DataColumn(
                              label: Text('Method',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700),),),
                          DataColumn(
                              label: Text('Balance',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700),),),
                          DataColumn(
                              label: Text('Notes',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700),),),
                        ],
                        rows: transactions.map((t) {
                          final isRepayment = t.transactionType ==
                              CustomerTransactionType.repayment;
                          final dateStr = DateFormat('yyyy-MM-dd HH:mm')
                              .format(t.createdAt.toLocal());

                          return DataRow(
                            cells: [
                              DataCell(Text(dateStr,
                                  style: const TextStyle(fontSize: 12),),),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3,),
                                  decoration: BoxDecoration(
                                    color: isRepayment
                                        ? AppColors.successBg
                                        : AppColors.dangerBg,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    t.transactionType.displayLabel,
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
                                  style: const TextStyle(fontSize: 12),),),
                              DataCell(
                                Text(
                                  CurrencyFormatter.format(t.balanceAfter),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,),
                                ),
                              ),
                              DataCell(Text(t.notes ?? '-',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.slate600,),),),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          );

          if (isDesktop) {
            return listView;
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(customerDetailProvider(customerId));
              await ref
                  .read(customerTransactionsProvider(customerId).notifier)
                  .refresh();
            },
            child: listView,
          );
        },
      ),
    );
  }
}

class _CustomerProfileCard extends StatelessWidget {
  const _CustomerProfileCard({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.slate100,
                      child: Text(
                        customer.name.isNotEmpty
                            ? customer.name.characters.first.toUpperCase()
                            : '?',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.slate800,),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.name,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            customer.phone,
                            style: const TextStyle(
                                color: AppColors.slate500, fontSize: 14,),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              AppButton(
                label: 'Edit',
                icon: const Icon(Icons.edit, size: 16),
                variant: AppButtonVariant.secondary,
                onPressed: () =>
                    CustomerFormDialog.show(context, customer: customer),
              ),
            ],
          ),
          const Divider(height: 32),
          _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: customer.address ?? '-',),
          const SizedBox(height: 12),
          _InfoRow(
              icon: Icons.schedule_outlined,
              label: 'Payment Cycle',
              value: customer.repaymentCycle.displayLabel,),
          if (customer.notes != null && customer.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoRow(
                icon: Icons.note_outlined,
                label: 'Notes',
                value: customer.notes!,),
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
                color: AppColors.slate900,),
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
                    style: TextStyle(fontSize: 12, color: AppColors.slate600),),
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
                  style: TextStyle(color: AppColors.slate600, fontSize: 13),),
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
                  style: TextStyle(color: AppColors.slate600, fontSize: 13),),
              Text(
                customer.creditLimit > 0
                    ? CurrencyFormatter.format(customer.remainingCredit)
                    : '-',
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.info,),
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
      {required this.icon, required this.label, required this.value,});

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
          width: 100,
          child: Text(label,
              style: const TextStyle(color: AppColors.slate500, fontSize: 13),),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.slate800,),),
        ),
      ],
    );
  }
}
