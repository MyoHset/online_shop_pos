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
  final _searchController = TextEditingController();
  int _viewMode = 0; // 0: Customer Directory, 1: Overdue & Schedules
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
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.slate200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CUSTOMERS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate500,
                          letterSpacing: 0.5,
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
                Container(
                  height: 28,
                  width: 1,
                  color: AppColors.slate200,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL DEBT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.danger,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        CurrencyFormatter.format(totalDebt),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.danger,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 28,
                  width: 1,
                  color: AppColors.slate200,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WITH DEBT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warning,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$debtCustomerCount',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Search Field with Clear Button ──
          Container(
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.slate200),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(customerSearchQueryProvider.notifier).updateQuery(val);
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search name or phone...',
                hintStyle: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.slate400,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: AppColors.slate400,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 16),
                        color: AppColors.slate400,
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(customerSearchQueryProvider.notifier)
                              .clear();
                          setState(() {});
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.slate900,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Filter Chips + Sort Toggle Row ──
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildMobileFilterChip(
                        index: 0,
                        label: 'All',
                        count: totalCustomers,
                      ),
                      const SizedBox(width: 6),
                      _buildMobileFilterChip(
                        index: 1,
                        label: 'With Debt',
                        count: debtCustomerCount,
                      ),
                      const SizedBox(width: 6),
                      _buildMobileFilterChip(
                        index: 2,
                        label: 'Limit Reached',
                        count: limitReachedCount,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Sort Toggle Button
              InkWell(
                onTap: () =>
                    setState(() => _sortByDebtFirst = !_sortByDebtFirst),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  decoration: BoxDecoration(
                    color: _sortByDebtFirst
                        ? AppColors.greenNude.withValues(alpha: 0.15)
                        : AppColors.slate100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.swap_vert_rounded,
                        size: 14,
                        color: _sortByDebtFirst
                            ? AppColors.slate900
                            : AppColors.slate600,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        _sortByDebtFirst ? 'Debt' : 'A-Z',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
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
                value: _searchController.text,
                hintText: 'Search by name or phone...',
                width: 280,
                onChanged: (val) {
                  _searchController.text = val;
                  ref.read(customerSearchQueryProvider.notifier).updateQuery(val);
                },
                onClear: () {
                  _searchController.clear();
                  ref.read(customerSearchQueryProvider.notifier).clear();
                },
              ),

              // Filter Chips
              Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip(
                    label: 'All Customers',
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
                    count: filteredList.where((c) => c.isLimitReached).length,
                    index: 2,
                    badgeHighlightColor: AppColors.warning,
                  ),
                ],
              ),

              // Add Customer Button
              AppButton(
                label: 'Add Customer',
                icon: const Icon(Icons.add, size: 16),
                variant: AppButtonVariant.primary,
                onPressed: () => CustomerFormDialog.show(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (filteredList.isEmpty)
            _EmptyCustomersView(
              hasFilters:
                  _searchController.text.isNotEmpty || _selectedFilter != 0,
              onReset: _clearFilters,
              onAddCustomer: () => CustomerFormDialog.show(context),
            )
          else
            _buildCustomerTable(context, filteredList),
        ],
      ],
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
                        ? badgeHighlightColor.withValues(alpha: 0.15)
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
        color: totalDebt > 0 ? AppColors.danger : AppColors.success,
        isHighlight: totalDebt > 0,
      ),
      _MetricCard(
        title: 'Customers with Debt',
        value: '$debtCustomerCount',
        icon: Icons.person_search_outlined,
        color: AppColors.warning,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards
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
        children: cards
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
