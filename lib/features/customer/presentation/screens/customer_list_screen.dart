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
import '../../domain/entities/customer.dart';
import '../providers/customer_provider.dart';
import '../widgets/customer_form_dialog.dart';
import '../widgets/record_repayment_dialog.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _searchController = TextEditingController();
  int _selectedFilter = 0; // 0: All, 1: Has Debt Only, 2: Limit Reached
  bool _sortByDebtFirst = true; // true: Highest Debt First, false: Name A-Z

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _searchController.clear();
    ref.read(customerSearchQueryProvider.notifier).clear();
    setState(() {
      _selectedFilter = 0;
    });
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
          isDesktop ? 'Customer Management' : 'Customers',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: isDesktop ? 22 : 18,
            color: AppColors.slate900,
          ),
        ),
        actions: [
          if (isDesktop) ...[
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.slate500),
              onPressed: () => ref.read(customerListProvider.notifier).refresh(),
              tooltip: 'Refresh',
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.slate700),
              tooltip: 'Refresh',
              visualDensity: VisualDensity.compact,
              onPressed: () => ref.read(customerListProvider.notifier).refresh(),
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.greenNude.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_add_rounded,
                  color: AppColors.slate900,
                  size: 18,
                ),
              ),
              tooltip: 'Add Customer',
              visualDensity: VisualDensity.compact,
              onPressed: () => CustomerFormDialog.show(context),
            ),
            const SizedBox(width: 8),
          ],
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
          final debtCustomerCount =
              allCustomers.where((c) => c.hasDebt).length;
          final limitReachedCount =
              allCustomers.where((c) => c.isLimitReached).length;

          // Apply local filter
          var filteredList = allCustomers.where((c) {
            if (_selectedFilter == 1) return c.hasDebt;
            if (_selectedFilter == 2) return c.isLimitReached;
            return true;
          }).toList();

          // Sort logic
          filteredList.sort((a, b) {
            if (_sortByDebtFirst) {
              final debtComp = b.currentDebt.compareTo(a.currentDebt);
              if (debtComp != 0) return debtComp;
              return a.name.toLowerCase().compareTo(b.name.toLowerCase());
            } else {
              return a.name.toLowerCase().compareTo(b.name.toLowerCase());
            }
          });

          if (isDesktop) {
            return _buildDesktopLayout(
              context: context,
              isDesktop: isDesktop,
              totalCustomers: totalCustomers,
              totalDebt: totalDebt,
              debtCustomerCount: debtCustomerCount,
              filteredList: filteredList,
              theme: theme,
            );
          }

          return Column(
            children: [
              _buildMobileHeader(
                totalCustomers: totalCustomers,
                totalDebt: totalDebt,
                debtCustomerCount: debtCustomerCount,
                limitReachedCount: limitReachedCount,
              ),
              Expanded(
                child: filteredList.isEmpty
                    ? _EmptyCustomersView(
                        hasFilters: _searchController.text.isNotEmpty ||
                            _selectedFilter != 0,
                        onReset: _clearFilters,
                        onAddCustomer: () => CustomerFormDialog.show(context),
                      )
                    : _buildMobileList(filteredList),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Mobile Header ──────────────────────────────────────────
  Widget _buildMobileHeader({
    required int totalCustomers,
    required double totalDebt,
    required int debtCustomerCount,
    required int limitReachedCount,
  }) {
    final hasActiveFilter =
        _searchController.text.isNotEmpty || _selectedFilter != 0;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Compact KPI Bar (Classic 3-item strip) ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.slate200, width: 0.8),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Total Customers
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customers',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$totalCustomers',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.slate900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    color: AppColors.slate200,
                    thickness: 1,
                    width: 20,
                  ),
                  // Total Outstanding Debt
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Debt',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(totalDebt),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: totalDebt > 0
                                ? AppColors.danger
                                : AppColors.slate900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    color: AppColors.slate200,
                    thickness: 1,
                    width: 20,
                  ),
                  // In Debt Count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'In Debt',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '$debtCustomerCount',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: debtCustomerCount > 0
                                    ? AppColors.warning
                                    : AppColors.slate900,
                              ),
                            ),
                            if (limitReachedCount > 0) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.dangerBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '$limitReachedCount!',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.danger,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Search Field + Sort Pill ──
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.slate100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.slate200, width: 0.8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      ref
                          .read(customerSearchQueryProvider.notifier)
                          .updateQuery(val);
                    },
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.slate900,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search by name or phone...',
                      hintStyle: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.slate400,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: AppColors.slate400,
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 34,
                        minHeight: 34,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.cancel_rounded,
                                size: 16,
                                color: AppColors.slate400,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                ref
                                    .read(customerSearchQueryProvider.notifier)
                                    .clear();
                              },
                              splashRadius: 16,
                              padding: EdgeInsets.zero,
                            )
                          : null,
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 9,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Sort Toggle Pill
              InkWell(
                onTap: () =>
                    setState(() => _sortByDebtFirst = !_sortByDebtFirst),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: _sortByDebtFirst
                        ? AppColors.greenNude.withValues(alpha: 0.18)
                        : AppColors.slate100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _sortByDebtFirst
                          ? AppColors.greenNude
                          : AppColors.slate200,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sort_rounded,
                        size: 16,
                        color: _sortByDebtFirst
                            ? AppColors.slate900
                            : AppColors.slate600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _sortByDebtFirst ? 'Debt First' : 'A-Z',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: _sortByDebtFirst
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _sortByDebtFirst
                              ? AppColors.slate900
                              : AppColors.slate600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Filter Pills Row ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMobileFilterChip(
                  index: 0,
                  label: 'All',
                  count: totalCustomers,
                ),
                const SizedBox(width: 8),
                _buildMobileFilterChip(
                  index: 1,
                  label: 'Has Debt',
                  count: debtCustomerCount,
                ),
                const SizedBox(width: 8),
                _buildMobileFilterChip(
                  index: 2,
                  label: 'Limit Reached',
                  count: limitReachedCount,
                ),
                if (hasActiveFilter) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _clearFilters,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Text(
                        'Reset filters',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFilterChip({
    required int index,
    required String label,
    required int count,
  }) {
    final isSelected = _selectedFilter == index;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = index),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenNude : AppColors.slate50,
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
                    : AppColors.slate200,
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

  // ── Mobile Customer List ────────────────────────────────────
  Widget _buildMobileList(List<Customer> customers) {
    return RefreshIndicator(
      color: AppColors.greenNude,
      onRefresh: () => ref.read(customerListProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: customers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final c = customers[i];
          return _CustomerMobileCard(
            customer: c,
            onTap: () => context.push('${AppRoutes.customers}/${c.id}'),
            onRecordRepayment: () => RecordRepaymentDialog.show(context, c),
            onEdit: () => CustomerFormDialog.show(context, customer: c),
          );
        },
      ),
    );
  }

  // ── Desktop Layout ──────────────────────────────────────────
  Widget _buildDesktopLayout({
    required BuildContext context,
    required bool isDesktop,
    required int totalCustomers,
    required double totalDebt,
    required int debtCustomerCount,
    required List<Customer> filteredList,
    required ThemeData theme,
  }) {
    return ListView(
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
                  hintText: 'Search by name or phone...',
                  hintStyle: const TextStyle(
                      fontSize: 13, color: AppColors.slate400),
                  prefixIcon: const Icon(Icons.search,
                      size: 20, color: AppColors.slate500),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(customerSearchQueryProvider.notifier)
                                .clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (val) {
                  ref
                      .read(customerSearchQueryProvider.notifier)
                      .updateQuery(val);
                },
              ),
            ),

            // Filter Chips & Refresh Button
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _buildDesktopFilterChip('All ($totalCustomers)', 0),
                _buildDesktopFilterChip('Has Debt ($debtCustomerCount)', 1),
                _buildDesktopFilterChip('Limit Reached', 2),
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.slate500),
                  onPressed: () =>
                      ref.read(customerListProvider.notifier).refresh(),
                  tooltip: 'Refresh',
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

        // Customer Cards or Table
        if (filteredList.isEmpty)
          Container(
            padding: const EdgeInsets.all(48),
            alignment: Alignment.center,
            child: Column(
              children: [
                const Icon(Icons.people_outline,
                    size: 48, color: AppColors.slate400),
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
    );
  }

  Widget _buildDesktopFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.black : AppColors.slate700,
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
      _MetricCard(
        title: 'Total Customers',
        value: '$totalCustomers',
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
        title: 'Customers with Debt',
        value: '$debtCustomerCount',
        icon: Icons.person_search_outlined,
        color: AppColors.warning,
      ),
    ];

    return Row(
      children: cards
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: c,
                ),
              ))
          .toList(),
    );
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
          minWidth: 800,
          headingRowColor: AppColors.slate100,
          horizontalMargin: 20,
          columnSpacing: 24,
          columns: const [
            DataColumn(
                label: Text('Name / Phone',
                    style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(
                label: Text('Address',
                    style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(
                label: Text('Current Debt',
                    style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(
                label: Text('Credit Limit',
                    style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(
                label: Text('Cycle',
                    style: TextStyle(fontWeight: FontWeight.w700))),
            DataColumn(
                label: Text('Actions',
                    style: TextStyle(fontWeight: FontWeight.w700))),
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
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.slate700),
                  ),
                ),
                // Current Debt
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          c.hasDebt ? AppColors.dangerBg : AppColors.successBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      CurrencyFormatter.format(c.currentDebt),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color:
                            c.hasDebt ? AppColors.danger : AppColors.success,
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
                // Actions
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (c.hasDebt)
                        IconButton(
                          icon: const Icon(Icons.payments_outlined,
                              color: AppColors.success),
                          tooltip: 'Record Repayment',
                          onPressed: () =>
                              RecordRepaymentDialog.show(context, c),
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: AppColors.slate600),
                        tooltip: 'Edit',
                        onPressed: () =>
                            CustomerFormDialog.show(context, customer: c),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            size: 16, color: AppColors.slate400),
                        tooltip: 'View Details',
                        onPressed: () =>
                            context.push('${AppRoutes.customers}/${c.id}'),
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

// ── Mobile Customer Card ──────────────────────────────────────
class _CustomerMobileCard extends StatelessWidget {
  const _CustomerMobileCard({
    required this.customer,
    required this.onTap,
    required this.onRecordRepayment,
    required this.onEdit,
  });

  final Customer customer;
  final VoidCallback onTap;
  final VoidCallback onRecordRepayment;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final c = customer;
    final initials = c.name.trim().isNotEmpty
        ? c.name.trim().substring(0, 1).toUpperCase()
        : 'C';

    final hasLimit = c.creditLimit > 0;
    final usageRatio = hasLimit
        ? (c.currentDebt / c.creditLimit).clamp(0.0, 1.0)
        : 0.0;
    final usagePercent = hasLimit ? (usageRatio * 100).toInt() : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: c.isLimitReached
              ? AppColors.danger.withValues(alpha: 0.35)
              : (c.hasDebt
                  ? AppColors.warning.withValues(alpha: 0.35)
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Row: Avatar + Name/Phone + Status Badge ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: c.isLimitReached
                            ? AppColors.dangerBg
                            : (c.hasDebt
                                ? AppColors.warningBg
                                : AppColors.greenNude.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: c.isLimitReached
                              ? AppColors.danger
                              : (c.hasDebt
                                  ? AppColors.warning
                                  : AppColors.slate900),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Name, Phone & Cycle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone_outlined,
                                size: 12,
                                color: AppColors.slate400,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                c.phone,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.slate600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: AppColors.slate100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  c.repaymentCycle.displayLabel,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.slate600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Status Badge
                    if (c.isLimitReached)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: AppColors.dangerBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.warning_amber_rounded,
                                size: 12, color: AppColors.danger),
                            SizedBox(width: 4),
                            Text(
                              'Limit Reached',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.danger,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (c.hasDebt)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: AppColors.warningBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.error_outline_rounded,
                                size: 12, color: AppColors.warning),
                            SizedBox(width: 4),
                            Text(
                              'In Debt',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: AppColors.successBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check_circle_outline_rounded,
                                size: 12, color: AppColors.success),
                            SizedBox(width: 4),
                            Text(
                              'Good',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                // ── Address (if present) ──
                if (c.address != null && c.address!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.slate400,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          c.address!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.slate500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 10),

                // ── Financial Info Box ──
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.slate50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.slate200.withValues(alpha: 0.8),
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Outstanding Debt
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Current Debt',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.slate500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  CurrencyFormatter.format(c.currentDebt),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: c.hasDebt
                                        ? AppColors.danger
                                        : AppColors.slate700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 28,
                            width: 1,
                            color: AppColors.slate200,
                          ),
                          const SizedBox(width: 12),
                          // Credit Limit
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Credit Limit',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.slate500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  hasLimit
                                      ? CurrencyFormatter.format(c.creditLimit)
                                      : 'Unlimited',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.slate800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (hasLimit) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: usageRatio,
                            minHeight: 4,
                            backgroundColor: AppColors.slate200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              c.isLimitReached
                                  ? AppColors.danger
                                  : (usageRatio > 0.7
                                      ? AppColors.warning
                                      : AppColors.greenNude),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Used: $usagePercent%',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate500,
                              ),
                            ),
                            Text(
                              c.isLimitReached
                                  ? 'Limit Exceeded'
                                  : 'Remaining: ${CurrencyFormatter.format(c.remainingCredit)}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: c.isLimitReached
                                    ? AppColors.danger
                                    : AppColors.slate600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ── Quick Actions Row ──
                Row(
                  children: [
                    if (c.hasDebt) ...[
                      InkWell(
                        onTap: onRecordRepayment,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.successBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.payments_outlined,
                                size: 14,
                                color: AppColors.success,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Repay',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    InkWell(
                      onTap: onEdit,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.slate100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.slate200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.edit_outlined,
                              size: 14,
                              color: AppColors.slate700,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate500,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: AppColors.slate400,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────
class _EmptyCustomersView extends StatelessWidget {
  const _EmptyCustomersView({
    required this.hasFilters,
    required this.onReset,
    required this.onAddCustomer,
  });

  final bool hasFilters;
  final VoidCallback onReset;
  final VoidCallback onAddCustomer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.slate100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size: 32,
                color: AppColors.slate400,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No customers found',
              style: TextStyle(
                color: AppColors.slate900,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              hasFilters
                  ? 'No customers match your search or filter criteria.'
                  : 'Customers will appear here once added.',
              style: const TextStyle(
                color: AppColors.slate500,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            if (hasFilters)
              OutlinedButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Reset filters'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.slate700,
                  side: const BorderSide(color: AppColors.slate300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: onAddCustomer,
                icon: const Icon(Icons.person_add_rounded, size: 16),
                label: const Text('Add Customer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenNude,
                  foregroundColor: AppColors.slate900,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Metric Card ───────────────────────────────────────────────
class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isHighlight = false,
  });

  final String title;
  final String value;
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
          color: isHighlight
              ? color.withValues(alpha: 0.5)
              : AppColors.slate200,
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
