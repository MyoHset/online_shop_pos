import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/custom_app_bar.dart';
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
  final _searchController = TextEditingController();
  int _viewMode = 0; // 0: Customer Directory, 1: Overdue & Schedules
  int _selectedFilter = 0; // 0: All, 1: With Debt Only, 2: Limit Reached

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customerListProvider);
    final theme = Theme.of(context);
    final isDesktop = DeviceType.from(context) == DeviceType.desktop ||
        DeviceType.from(context) == DeviceType.large ||
        DeviceType.from(context) == DeviceType.tablet;

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
          final debtCustomerCount =
              allCustomers.where((c) => c.hasDebt).length;

          // Apply local filter
          final filteredList = allCustomers.where((c) {
            if (_selectedFilter == 1) return c.hasDebt;
            if (_selectedFilter == 2) return c.isLimitReached;
            return true;
          }).toList();

          return RefreshIndicator(
            onRefresh: () => ref.read(customerListProvider.notifier).refresh(),
            child: ListView(
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
                    ChoiceChip(
                      label: const Text('Customer Directory'),
                      selected: _viewMode == 0,
                      selectedColor: AppColors.slate900,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _viewMode == 0 ? Colors.white : AppColors.slate700,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _viewMode = 0);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Overdue & Schedules'),
                          if (debtCustomerCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.danger,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$debtCustomerCount',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      selected: _viewMode == 1,
                      selectedColor: AppColors.slate900,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _viewMode == 1 ? Colors.white : AppColors.slate700,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _viewMode = 1);
                      },
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
                      Container(
                        width: 280,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.slate200),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by Name or Phone...',
                            hintStyle: const TextStyle(fontSize: 13, color: AppColors.slate400),
                            prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.slate500),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 16),
                                    onPressed: () {
                                      _searchController.clear();
                                      ref.read(customerSearchQueryProvider.notifier).clear();
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onChanged: (val) {
                            ref.read(customerSearchQueryProvider.notifier).updateQuery(val);
                          },
                        ),
                      ),

                      // Filter Chips
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildFilterChip('All ($totalCustomers)', 0),
                          _buildFilterChip('With Debt ($debtCustomerCount)', 1),
                          _buildFilterChip('Limit Reached', 2),
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
                      padding: const EdgeInsets.all(48),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Icon(Icons.people_outline, size: 48, color: AppColors.slate400),
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.black : AppColors.slate600,
      ),
      selectedColor: AppColors.greenNude,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? Colors.transparent : AppColors.slate200,
      ),
      onSelected: (val) {
        if (val) setState(() => _selectedFilter = index);
      },
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
              horizontalMargin: 20,
              columnSpacing: 24,
              columns: const [
                DataColumn(label: Text('Customer / Phone', style: TextStyle(fontWeight: FontWeight.w700))),
                DataColumn(label: Text('Address', style: TextStyle(fontWeight: FontWeight.w700))),
                DataColumn(label: Text('Outstanding Debt', style: TextStyle(fontWeight: FontWeight.w700))),
                DataColumn(label: Text('Credit Limit', style: TextStyle(fontWeight: FontWeight.w700))),
                DataColumn(label: Text('Cycle', style: TextStyle(fontWeight: FontWeight.w700))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700))),
                DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700))),
              ],
              rows: customers.map((c) {
                return DataRow(
                  cells: [
                    // Name & Phone
                    DataCell(
                      InkWell(
                        onTap: () => context.push('${AppRoutes.customers}/${c.id}'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                c.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate900,
                                ),
                              ),
                              Text(
                                c.phone,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.slate500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Address
                    DataCell(
                      Text(
                        c.address ?? '-',
                        style: const TextStyle(fontSize: 13, color: AppColors.slate700),
                      ),
                    ),
                    // Current Debt
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.hasDebt ? AppColors.dangerBg : AppColors.successBg,
                          borderRadius: BorderRadius.circular(6),
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
                        c.creditLimit > 0 ? CurrencyFormatter.format(c.creditLimit) : 'Unlimited',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    // Cycle
                    DataCell(
                      Text(
                        c.repaymentCycle.displayLabel,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    // Status
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: c.isSuspended ? AppColors.dangerBg : AppColors.successBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          c.isSuspended ? 'Suspended' : 'Active',
                          style: TextStyle(
                            color: c.isSuspended ? AppColors.danger : AppColors.success,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    // Actions
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (c.hasDebt)
                            IconButton(
                              icon: const Icon(Icons.payments_outlined, color: AppColors.success),
                              tooltip: 'Record Repayment',
                              onPressed: () => RecordRepaymentDialog.show(context, c),
                            ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: AppColors.slate600),
                            tooltip: 'Edit Customer',
                            onPressed: () => CustomerFormDialog.show(context, customer: c),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.slate400),
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
          color: isHighlight ? color.withValues(alpha: 0.5) : AppColors.slate200,
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
