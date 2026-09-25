import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_data_table.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/search_text_field.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_provider.dart';
import '../widgets/customer_form_dialog.dart';
import '../widgets/customer_overdue_section.dart';
import '../widgets/record_repayment_dialog.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  int _viewMode = 0; // 0: Customer Directory, 1: Overdue & Schedules
  int _selectedFilter = 0; // 0: All, 1: With Debt Only, 2: Limit Reached

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customerListProvider);
    final theme = Theme.of(context);
    final deviceType = DeviceType.from(context);
    final isDesktop = deviceType == DeviceType.desktop ||
        deviceType == DeviceType.large ||
        deviceType == DeviceType.tablet;
    final enablePullToRefresh =
        deviceType == DeviceType.mobile || deviceType == DeviceType.tablet;

    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: CustomAppBar(
        title: Text(
          'Customer Management',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.slate900,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.refresh, size: 20, color: AppColors.slate700),
            tooltip: 'Refresh Customers',
            onPressed: () => ref.read(customerListProvider.notifier).refresh(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: customersAsync.when(
        loading: () => const AppLoadingWidget(),
        error: (err, _) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.read(customerListProvider.notifier).refresh(),
        ),
        data: (allCustomers) {
          // Compute summary stats
          final totalCustomers = allCustomers.length;
          final totalDebt = allCustomers.fold<double>(
            0.0,
            (sum, c) => sum + c.currentDebt,
          );
          final debtCustomerCount = allCustomers.where((c) => c.hasDebt).length;

          // Apply local filter
          final filteredList = allCustomers.where((c) {
            if (_selectedFilter == 1) return c.hasDebt;
            if (_selectedFilter == 2) return c.isLimitReached;
            return true;
          }).toList();

          final content = ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Top Metrics Cards
              _buildMetricsRow(
                isDesktop: isDesktop,
                totalCustomers: totalCustomers,
                totalDebt: totalDebt,
                debtCustomerCount: debtCustomerCount,
              ),
              const SizedBox(height: 24),

              // View Mode Tabs: [Customer Directory] / [Overdue & Schedules]
              Row(
                children: [
                  _buildViewModeTab(
                    title: 'Customer Directory',
                    index: 0,
                    icon: Icons.people_alt_outlined,
                  ),
                  const SizedBox(width: 8),
                  _buildViewModeTab(
                    title: 'Overdue & Schedules',
                    index: 1,
                    icon: Icons.schedule_outlined,
                    badgeCount: debtCustomerCount,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Body content based on View Mode
              if (_viewMode == 1)
                const CustomerOverdueSection()
              else ...[
                // Controls Row: Search Bar, Filters, and Add Button
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Search box (Name & Phone)
                    SearchTextField(
                      value: ref.watch(customerSearchQueryProvider),
                      hintText: 'Search by Name or Phone...',
                      prefixIcon: const Icon(
                        Icons.person_search_outlined,
                        size: 18,
                      ),
                      width: 280,
                      onChanged: (val) {
                        ref
                            .read(customerSearchQueryProvider.notifier)
                            .updateQuery(val);
                      },
                      onClear: () {
                        ref.read(customerSearchQueryProvider.notifier).clear();
                      },
                    ),

                    // Filter Chips
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterChip(
                          label: 'All',
                          count: totalCustomers,
                          index: 0,
                        ),
                        _buildFilterChip(
                          label: 'With Debt',
                          count: debtCustomerCount,
                          index: 1,
                          badgeHighlightColor: AppColors.danger,
                        ),
                        _buildFilterChip(
                          label: 'Limit Reached',
                          count: allCustomers
                              .where((c) => c.isLimitReached)
                              .length,
                          index: 2,
                          badgeHighlightColor: AppColors.warning,
                        ),
                      ],
                    ),

                    // Add Customer Button
                    AppButton(
                      label: '+ Add Customer',
                      icon: const Icon(Icons.person_add_alt_1),
                      onPressed: () => CustomerFormDialog.show(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Customer Table
                if (filteredList.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(48),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.slate200),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 48,
                          color: AppColors.slate400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No customers found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.slate600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  _buildCustomerTable(context, filteredList),
              ],
            ],
          );

          if (enablePullToRefresh) {
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(customerListProvider.notifier).refresh(),
              child: content,
            );
          }

          return content;
        },
      ),
    );
  }

  Widget _buildViewModeTab({
    required String title,
    required int index,
    required IconData icon,
    int? badgeCount,
  }) {
    final isSelected = _viewMode == index;
    return InkWell(
      onTap: () => setState(() => _viewMode = index),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.slate900 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.slate900 : AppColors.slate200,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.slate900.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.slate500,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.slate700,
              ),
            ),
            if (badgeCount != null && badgeCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.danger,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required int count,
    required int index,
    Color? badgeHighlightColor,
  }) {
    final isSelected = _selectedFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = index),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.slate900 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.slate900 : AppColors.slate200,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.slate900.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.slate700,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : (badgeHighlightColor != null && count > 0)
                        ? badgeHighlightColor.withValues(alpha: 0.12)
                        : AppColors.slate100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : (badgeHighlightColor != null && count > 0)
                          ? badgeHighlightColor
                          : AppColors.slate600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsRow({
    required bool isDesktop,
    required int totalCustomers,
    required double totalDebt,
    required int debtCustomerCount,
  }) {
    final cards = [
      const _MetricCard(
        title: 'Total Customers',
        value: '',
        countNumber: 0,
        icon: Icons.groups_outlined,
        color: AppColors.info,
      ),
      _MetricCard(
        title: 'Total Outstanding Debt',
        value: CurrencyFormatter.format(totalDebt),
        icon: Icons.account_balance_wallet_outlined,
        color: AppColors.danger,
        isHighlight: true,
      ),
      _MetricCard(
        title: 'Accounts with Debt',
        value: '$debtCustomerCount',
        icon: Icons.person_search_outlined,
        color: AppColors.warning,
      ),
    ];

    final updatedCards = [
      _MetricCard(
        title: 'Total Customers',
        value: '$totalCustomers',
        icon: Icons.groups_outlined,
        color: AppColors.info,
      ),
      cards[1],
      cards[2],
    ];

    if (isDesktop) {
      return Row(
        children: updatedCards
            .map(
              (c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: c,
                ),
              ),
            )
            .toList(),
      );
    } else {
      return Column(
        children: updatedCards
            .map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: c,
              ),
            )
            .toList(),
      );
    }
  }

  Widget _buildCustomerTable(BuildContext context, List<Customer> customers) {
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
          horizontalMargin: 20,
          columnSpacing: 24,
          columns: const [
            DataColumn(
              label: Text(
                'Customer',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.slate700,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Address',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.slate700,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Outstanding Debt',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.slate700,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Credit Limit',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.slate700,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Cycle',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.slate700,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.slate700,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Actions',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.slate700,
                ),
              ),
            ),
          ],
          rows: customers.map((c) {
            return DataRow(
              cells: [
                // Customer / Phone with Avatar
                DataCell(
                  _CustomerTableInfoCell(
                    name: c.name,
                    phone: c.phone,
                    onTap: () => context.push('${AppRoutes.customers}/${c.id}'),
                  ),
                ),
                // Address
                DataCell(
                  Text(
                    c.address != null && c.address!.trim().isNotEmpty
                        ? c.address!
                        : '-',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.slate600,
                    ),
                  ),
                ),
                // Outstanding Debt
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          c.hasDebt ? AppColors.dangerBg : AppColors.successBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: c.hasDebt
                            ? AppColors.danger.withValues(alpha: 0.25)
                            : AppColors.success.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      CurrencyFormatter.format(c.currentDebt),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: c.hasDebt ? AppColors.danger : AppColors.success,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                // Credit Limit
                DataCell(
                  Text(
                    c.creditLimit > 0
                        ? CurrencyFormatter.format(c.creditLimit)
                        : 'Unlimited',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: c.creditLimit > 0
                          ? (c.isLimitReached
                              ? AppColors.danger
                              : AppColors.slate800)
                          : AppColors.slate500,
                    ),
                  ),
                ),
                // Cycle
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.slate100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      c.repaymentCycle.displayLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.slate700,
                      ),
                    ),
                  ),
                ),
                // Status
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: c.isSuspended
                          ? AppColors.dangerBg
                          : AppColors.successBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: c.isSuspended
                                ? AppColors.danger
                                : AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          c.isSuspended ? 'Suspended' : 'Active',
                          style: TextStyle(
                            color: c.isSuspended
                                ? AppColors.danger
                                : AppColors.success,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Actions
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        label: 'View',
                        variant: AppButtonVariant.secondary,
                        onPressed: () =>
                            context.push('${AppRoutes.customers}/${c.id}'),
                      ),
                      const SizedBox(width: 4),
                      if (c.hasDebt)
                        IconButton(
                          icon: const Icon(
                            Icons.payments_outlined,
                            size: 18,
                            color: AppColors.success,
                          ),
                          tooltip: 'Record Repayment',
                          onPressed: () =>
                              RecordRepaymentDialog.show(context, c),
                        ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: AppColors.slate500,
                        ),
                        tooltip: 'Edit Customer',
                        onPressed: () =>
                            CustomerFormDialog.show(context, customer: c),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CustomerTableInfoCell extends StatelessWidget {
  const _CustomerTableInfoCell({
    required this.name,
    required this.phone,
    required this.onTap,
  });

  final String name;
  final String phone;
  final VoidCallback onTap;

  String _getInitials(String str) {
    final parts = str.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.slate300),
              ),
              alignment: Alignment.center,
              child: Text(
                _getInitials(name),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate800,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.slate900,
                  ),
                ),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.slate500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    this.countNumber,
    required this.icon,
    required this.color,
    this.isHighlight = false,
  });

  final String title;
  final String value;
  final int? countNumber;
  final IconData icon;
  final Color color;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isHighlight ? color.withValues(alpha: 0.5) : AppColors.slate200,
          width: isHighlight ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.slate500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isHighlight ? color : AppColors.slate900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
