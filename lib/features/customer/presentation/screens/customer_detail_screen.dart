import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_data_table.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_transaction.dart';
import '../providers/customer_provider.dart';
import '../widgets/customer_form_dialog.dart';
import '../widgets/record_repayment_dialog.dart';

class CustomerDetailScreen extends ConsumerStatefulWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  ConsumerState<CustomerDetailScreen> createState() =>
      _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  int _selectedTxFilter = 0; // 0: All, 1: Sales (Debt), 2: Repayments

  Future<void> _refresh() async {
    ref.invalidate(customerDetailProvider(widget.customerId));
    await ref
        .read(customerTransactionsProvider(widget.customerId).notifier)
        .refresh();
  }

  @override
  Widget build(BuildContext context) {
    final customerAsync = ref.watch(customerDetailProvider(widget.customerId));
    final transactionsAsync =
        ref.watch(customerTransactionsProvider(widget.customerId));
    final theme = Theme.of(context);
    final isDesktop = DeviceType.from(context) == DeviceType.desktop ||
        DeviceType.from(context) == DeviceType.large ||
        DeviceType.from(context) == DeviceType.tablet;

    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.slate800,
          ),
          tooltip: 'Back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/customers');
            }
          },
        ),
        title: Text(
          isDesktop
              ? 'Customer Details'
              : (customerAsync.value?.name ?? 'Customer Profile'),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: isDesktop ? 22 : 17,
            color: AppColors.slate900,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.slate700),
            tooltip: 'Refresh',
            visualDensity: VisualDensity.compact,
            onPressed: _refresh,
          ),
          if (customerAsync.value != null) ...[
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.slate100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.slate200, width: 0.8),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.slate800,
                  size: 17,
                ),
              ),
              tooltip: 'Edit Profile',
              visualDensity: VisualDensity.compact,
              onPressed: () => CustomerFormDialog.show(
                context,
                customer: customerAsync.value,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
      body: customerAsync.when(
        loading: () => const AppLoadingWidget(),
        error: (err, _) => AppErrorWidget(
          message: err.toString(),
          onRetry: _refresh,
        ),
        data: (customer) {
          if (isDesktop) {
            return _buildDesktopLayout(
              context: context,
              customer: customer,
              transactionsAsync: transactionsAsync,
              theme: theme,
            );
          }

          return _buildMobileLayout(
            context: context,
            customer: customer,
            transactionsAsync: transactionsAsync,
            theme: theme,
          );
        },
      ),
    );
  }

  // ── Mobile Layout ───────────────────────────────────────────
  Widget _buildMobileLayout({
    required BuildContext context,
    required Customer customer,
    required AsyncValue<List<CustomerTransaction>> transactionsAsync,
    required ThemeData theme,
  }) {
    return RefreshIndicator(
      color: AppColors.greenNude,
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // ── Card 1: Profile & Identity Overview ──
          _MobileProfileCard(
            customer: customer,
            onEdit: () =>
                CustomerFormDialog.show(context, customer: customer),
          ),
          const SizedBox(height: 12),

          // ── Card 2: Financial & Credit Balance ──
          _MobileFinancialCard(
            customer: customer,
            onRecordRepayment: () =>
                RecordRepaymentDialog.show(context, customer),
          ),
          const SizedBox(height: 20),

          // ── Ledger / Transactions Section ──
          transactionsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Failed to load transactions: $err',
                style: const TextStyle(color: AppColors.danger),
              ),
            ),
            data: (allTransactions) {
              // Apply filter
              final filteredTx = allTransactions.where((t) {
                if (_selectedTxFilter == 1) {
                  return t.transactionType == CustomerTransactionType.debt ||
                      t.transactionType ==
                          CustomerTransactionType.openingBalance;
                }
                if (_selectedTxFilter == 2) {
                  return t.transactionType ==
                      CustomerTransactionType.repayment;
                }
                return true;
              }).toList();

              final salesCount = allTransactions
                  .where((t) =>
                      t.transactionType == CustomerTransactionType.debt ||
                      t.transactionType ==
                          CustomerTransactionType.openingBalance)
                  .length;
              final repaymentCount = allTransactions
                  .where((t) =>
                      t.transactionType == CustomerTransactionType.repayment)
                  .length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ledger Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.receipt_long_rounded,
                            size: 18,
                            color: AppColors.slate800,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Ledger History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.slate900,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.slate200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${allTransactions.length}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Ledger Filter Pills
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTxFilterChip(0, 'All', allTransactions.length),
                        const SizedBox(width: 8),
                        _buildTxFilterChip(1, 'Credit Sales', salesCount),
                        const SizedBox(width: 8),
                        _buildTxFilterChip(2, 'Repayments', repaymentCount),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Transactions List
                  if (filteredTx.isEmpty)
                    _EmptyTransactionsCard(
                      hasFilter: _selectedTxFilter != 0,
                      onReset: () => setState(() => _selectedTxFilter = 0),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredTx.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return _TransactionMobileCard(
                          transaction: filteredTx[index],
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTxFilterChip(int index, String label, int count) {
    final isSelected = _selectedTxFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedTxFilter = index),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenNude : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.greenNude : AppColors.slate200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.black : AppColors.slate700,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.35)
                    : AppColors.slate100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.black : AppColors.slate700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Desktop Layout ──────────────────────────────────────────
  Widget _buildDesktopLayout({
    required BuildContext context,
    required Customer customer,
    required AsyncValue<List<CustomerTransaction>> transactionsAsync,
    required ThemeData theme,
  }) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Top Info & Credit Status
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _CustomerProfileCard(customer: customer),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: _CustomerCreditCard(customer: customer),
            ),
          ],
        ),
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
                  .read(
                      customerTransactionsProvider(widget.customerId).notifier)
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
          error: (err, _) => Text(
            'Error: $err',
            style: const TextStyle(color: AppColors.danger),
          ),
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
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    DataColumn(
                      label: Text('Type',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    DataColumn(
                      label: Text('Amount',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    DataColumn(
                      label: Text('Method',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    DataColumn(
                      label: Text('Balance',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    DataColumn(
                      label: Text('Notes',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                  rows: transactions.map((t) {
                    final isRepayment = t.transactionType ==
                        CustomerTransactionType.repayment;
                    final dateStr = DateFormat('yyyy-MM-dd HH:mm')
                        .format(t.createdAt.toLocal());

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(dateStr, style: const TextStyle(fontSize: 12)),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
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
                        DataCell(
                          Text(t.paymentMethod.toUpperCase(),
                              style: const TextStyle(fontSize: 12)),
                        ),
                        DataCell(
                          Text(
                            CurrencyFormatter.format(t.balanceAfter),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(t.notes ?? '-',
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.slate600)),
                        ),
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
  }
}

// ── Mobile Profile Card ───────────────────────────────────────
class _MobileProfileCard extends StatelessWidget {
  const _MobileProfileCard({
    required this.customer,
    required this.onEdit,
  });

  final Customer customer;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final initials = customer.name.trim().isNotEmpty
        ? customer.name.trim().substring(0, 1).toUpperCase()
        : 'C';

    final memberSince =
        DateFormat('MMM yyyy').format(customer.createdAt.toLocal());

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.slate900.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Avatar + Name/Phone + Status Pill ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: customer.isLimitReached
                      ? AppColors.dangerBg
                      : (customer.hasDebt
                          ? AppColors.warningBg
                          : AppColors.greenNude.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: customer.isLimitReached
                        ? AppColors.danger
                        : (customer.hasDebt
                            ? AppColors.warning
                            : AppColors.slate900),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name, Phone & Member Since
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 13,
                          color: AppColors.slate500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          customer.phone,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Customer since $memberSince',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.slate400,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Pill
              if (customer.isLimitReached)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: AppColors.dangerBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.warning_amber_rounded,
                          size: 12, color: AppColors.danger),
                      SizedBox(width: 3),
                      Text(
                        'Limit Reached',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                )
              else if (customer.hasDebt)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.error_outline_rounded,
                          size: 12, color: AppColors.warning),
                      SizedBox(width: 3),
                      Text(
                        'In Debt',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle_outline_rounded,
                          size: 12, color: AppColors.success),
                      SizedBox(width: 3),
                      Text(
                        'Good Standing',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: AppColors.slate200, height: 1),
          const SizedBox(height: 12),

          // ── Detailed Info Rows ──
          _DetailMiniRow(
            icon: Icons.schedule_outlined,
            label: 'Repayment Cycle',
            value: customer.repaymentCycle.displayLabel,
          ),
          if (customer.address != null &&
              customer.address!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _DetailMiniRow(
              icon: Icons.location_on_outlined,
              label: 'Address',
              value: customer.address!,
            ),
          ],
          if (customer.notes != null && customer.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _DetailMiniRow(
              icon: Icons.notes_rounded,
              label: 'Notes',
              value: customer.notes!,
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailMiniRow extends StatelessWidget {
  const _DetailMiniRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.slate400),
        const SizedBox(width: 6),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.slate500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.slate800,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Mobile Financial & Credit Balance Card ────────────────────
class _MobileFinancialCard extends StatelessWidget {
  const _MobileFinancialCard({
    required this.customer,
    required this.onRecordRepayment,
  });

  final Customer customer;
  final VoidCallback onRecordRepayment;

  @override
  Widget build(BuildContext context) {
    final hasLimit = customer.creditLimit > 0;
    final usageRatio = hasLimit
        ? (customer.currentDebt / customer.creditLimit).clamp(0.0, 1.0)
        : 0.0;
    final usagePercent = hasLimit ? (usageRatio * 100).toInt() : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: customer.isLimitReached
              ? AppColors.danger.withValues(alpha: 0.4)
              : (customer.hasDebt
                  ? AppColors.warning.withValues(alpha: 0.4)
                  : AppColors.slate200),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.slate900.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Credit & Debt Status',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 12),

          // ── Two Columns: Current Debt vs Credit Limit ──
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: customer.hasDebt
                  ? (customer.isLimitReached
                      ? AppColors.dangerBg
                      : AppColors.warning.withValues(alpha: 0.1))
                  : AppColors.successBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Outstanding Debt
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Outstanding Debt',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        CurrencyFormatter.format(customer.currentDebt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: customer.hasDebt
                              ? AppColors.danger
                              : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 32,
                  width: 1,
                  color: AppColors.slate300.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 14),
                // Credit Limit
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Credit Limit',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        hasLimit
                            ? CurrencyFormatter.format(customer.creditLimit)
                            : 'Unlimited',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
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

          // ── Progress Bar & Remaining Credit ──
          if (hasLimit) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: usageRatio,
                minHeight: 6,
                backgroundColor: AppColors.slate200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  customer.isLimitReached
                      ? AppColors.danger
                      : (usageRatio > 0.7
                          ? AppColors.warning
                          : AppColors.greenNude),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Credit Used: $usagePercent%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate500,
                  ),
                ),
                Text(
                  customer.isLimitReached
                      ? 'Credit Limit Exceeded'
                      : 'Remaining: ${CurrencyFormatter.format(customer.remainingCredit)}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: customer.isLimitReached
                        ? AppColors.danger
                        : AppColors.info,
                  ),
                ),
              ],
            ),
          ],

          // ── Action: Record Repayment Button ──
          if (customer.hasDebt) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton.icon(
                onPressed: onRecordRepayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenNude,
                  foregroundColor: AppColors.slate900,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.payments_outlined, size: 18),
                label: const Text(
                  'Record Repayment (အကြွေးဆပ်ငွေသွင်း)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Mobile Transaction Ledger Card ────────────────────────────
class _TransactionMobileCard extends StatelessWidget {
  const _TransactionMobileCard({required this.transaction});

  final CustomerTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final isRepayment =
        t.transactionType == CustomerTransactionType.repayment;
    final isOpening =
        t.transactionType == CustomerTransactionType.openingBalance;

    final dateStr =
        DateFormat('MMM d, yyyy • HH:mm').format(t.createdAt.toLocal());

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200, width: 0.8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isRepayment
                  ? AppColors.successBg
                  : (isOpening ? AppColors.infoBg : AppColors.dangerBg),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isRepayment
                  ? Icons.arrow_downward_rounded
                  : (isOpening
                      ? Icons.account_balance_outlined
                      : Icons.arrow_upward_rounded),
              size: 20,
              color: isRepayment
                  ? AppColors.success
                  : (isOpening ? AppColors.info : AppColors.danger),
            ),
          ),
          const SizedBox(width: 10),

          // Details (Type, Date, Method, Notes)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      t.transactionType.displayLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        t.paymentMethod.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.slate400,
                  ),
                ),
                if (t.orderId != null && t.orderId!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Order #${t.orderId!.length > 8 ? t.orderId!.substring(0, 8) : t.orderId}',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate600,
                    ),
                  ),
                ],
                if (t.notes != null && t.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    t.notes!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: AppColors.slate500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Amount & Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isRepayment ? '-' : '+'} ${CurrencyFormatter.format(t.amount)}',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: isRepayment
                      ? AppColors.success
                      : (isOpening ? AppColors.info : AppColors.slate900),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Bal: ${CurrencyFormatter.format(t.balanceAfter)}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.slate500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Empty Transactions View ───────────────────────────────────
class _EmptyTransactionsCard extends StatelessWidget {
  const _EmptyTransactionsCard({
    required this.hasFilter,
    required this.onReset,
  });

  final bool hasFilter;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.slate200, width: 0.8),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 36,
            color: AppColors.slate400,
          ),
          const SizedBox(height: 10),
          const Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.slate800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasFilter
                ? 'No transactions match the selected filter.'
                : 'Credit sales and repayments will be recorded here.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.slate500,
            ),
          ),
          if (hasFilter) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: onReset,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.greenNude,
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
              child: const Text('Reset filter'),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Desktop Subcomponents ─────────────────────────────────────
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
                          color: AppColors.slate800,
                        ),
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
                              color: AppColors.slate500,
                              fontSize: 14,
                            ),
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
            value: customer.address ?? '-',
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.schedule_outlined,
            label: 'Payment Cycle',
            value: customer.repaymentCycle.displayLabel,
          ),
          if (customer.notes != null && customer.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.note_outlined,
              label: 'Notes',
              value: customer.notes!,
            ),
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
              color: AppColors.slate900,
            ),
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
                const Text(
                  'Current Outstanding Debt',
                  style: TextStyle(fontSize: 12, color: AppColors.slate600),
                ),
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
                  color: AppColors.info,
                ),
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
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

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
          child: Text(
            label,
            style: const TextStyle(color: AppColors.slate500, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.slate800,
            ),
          ),
        ),
      ],
    );
  }
}
