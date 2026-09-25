import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_provider.dart';
import 'record_repayment_dialog.dart';

class CustomerOverdueSection extends ConsumerStatefulWidget {
  const CustomerOverdueSection({super.key});

  @override
  ConsumerState<CustomerOverdueSection> createState() => _CustomerOverdueSectionState();
}

class _CustomerOverdueSectionState extends ConsumerState<CustomerOverdueSection> {
  int _tabIndex = 0; // 0: Overdue, 1: Due This Week

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customerListProvider);
    final theme = Theme.of(context);

    return customersAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Center(
        child: Text('Error: $e', style: const TextStyle(color: AppColors.danger)),
      ),
      data: (customers) {
        final now = DateTime.now();

        // Filter customers who have active debt
        final debtCustomers = customers.where((c) => c.hasDebt).toList();

        // Calculate approximate due date based on cycle and customer creation or last updated
        // For accurate tracking, overdue is based on whether updated/created exceeds the cycle duration
        final overdueList = <_OverdueItem>[];
        final dueThisWeekList = <_OverdueItem>[];

        for (final c in debtCustomers) {
          final estimatedDueDate = c.calculateDueDate(c.updatedAt);
          final diffDays = now.difference(estimatedDueDate).inDays;

          if (diffDays > 0) {
            overdueList.add(_OverdueItem(customer: c, dueDate: estimatedDueDate, daysDiff: diffDays));
          } else if (diffDays >= -7) {
            dueThisWeekList.add(_OverdueItem(customer: c, dueDate: estimatedDueDate, daysDiff: diffDays.abs()));
          }
        }

        final activeList = _tabIndex == 0 ? overdueList : dueThisWeekList;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sub-tabs
            Row(
              children: [
                ChoiceChip(
                  label: Text('Overdue Debts (${overdueList.length})'),
                  selected: _tabIndex == 0,
                  selectedColor: AppColors.danger.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    fontWeight: _tabIndex == 0 ? FontWeight.w700 : FontWeight.w500,
                    color: _tabIndex == 0 ? AppColors.danger : AppColors.slate700,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _tabIndex = 0);
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Due This Week (${dueThisWeekList.length})'),
                  selected: _tabIndex == 1,
                  selectedColor: AppColors.warning.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    fontWeight: _tabIndex == 1 ? FontWeight.w700 : FontWeight.w500,
                    color: _tabIndex == 1 ? AppColors.warning : AppColors.slate700,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _tabIndex = 1);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Content Table
            if (activeList.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.slate200),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      _tabIndex == 0 ? Icons.check_circle_outline : Icons.event_available_outlined,
                      size: 40,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _tabIndex == 0
                          ? 'No overdue customer debts!'
                          : 'No upcoming due debts this week.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.slate700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.slate200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 800),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(AppColors.slate100),
                        columns: const [
                          DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Outstanding Debt', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Cycle', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Due Date', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Status / Aging', style: TextStyle(fontWeight: FontWeight.w700))),
                          DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700))),
                        ],
                        rows: activeList.map((item) {
                          final c = item.customer;
                          final isOverdue = _tabIndex == 0;

                          return DataRow(
                            cells: [
                              DataCell(
                                InkWell(
                                  onTap: () => context.push('${AppRoutes.customers}/${c.id}'),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        c.name,
                                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.slate900),
                                      ),
                                      Text(
                                        c.phone,
                                        style: const TextStyle(fontSize: 12, color: AppColors.slate500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  CurrencyFormatter.format(c.currentDebt),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.danger,
                                  ),
                                ),
                              ),
                              DataCell(Text(c.repaymentCycle.displayLabel, style: const TextStyle(fontSize: 13))),
                              DataCell(
                                Text(
                                  DateFormat('MMM dd, yyyy').format(item.dueDate),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              DataCell(_buildAgingBadge(item.daysDiff, isOverdue)),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.copy_outlined, size: 18, color: AppColors.info),
                                      tooltip: 'Copy Reminder Message (Viber / SMS)',
                                      onPressed: () => _copyReminderText(context, c, item.dueDate),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.payments_outlined, size: 18, color: AppColors.success),
                                      tooltip: 'Record Repayment',
                                      onPressed: () => RecordRepaymentDialog.show(context, c),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.slate400),
                                      tooltip: 'View Details',
                                      onPressed: () => context.push('${AppRoutes.customers}/${c.id}'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAgingBadge(int days, bool isOverdue) {
    if (!isOverdue) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.warningBg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'Due in $days days',
          style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.w700, fontSize: 12),
        ),
      );
    }

    final Color badgeColor;
    final String label;

    if (days <= 15) {
      badgeColor = AppColors.warning;
      label = '$days days overdue';
    } else if (days <= 30) {
      badgeColor = const Color(0xFFE65100);
      label = '$days days overdue';
    } else {
      badgeColor = AppColors.danger;
      label = '$days+ days overdue';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: badgeColor, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  void _copyReminderText(BuildContext context, Customer customer, DateTime dueDate) {
    final dateStr = DateFormat('MMM dd, yyyy').format(dueDate);
    final text = 'Dear ${customer.name},\n'
        'This is a friendly payment reminder from our shop regarding your outstanding balance of ${CurrencyFormatter.format(customer.currentDebt)} (Due Date: $dateStr).\n'
        'Please kindly settle the payment when convenient. Thank you for your continued support!';

    Clipboard.setData(ClipboardData(text: text));
    AppSnackBar.showSuccess(
      context,
      'Payment reminder message copied to clipboard!',
    );
  }
}

class _OverdueItem {
  const _OverdueItem({
    required this.customer,
    required this.dueDate,
    required this.daysDiff,
  });

  final Customer customer;
  final DateTime dueDate;
  final int daysDiff;
}
