import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_data_table.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/entities/order.dart';
import '../providers/order_list_provider.dart';
import '../widgets/order_card.dart';
import '../widgets/order_status_badge.dart';

/// Preset date filter options for orders report.
enum OrderDatePreset {
  all('All Dates'),
  today('Today'),
  yesterday('Yesterday'),
  thisWeek('This Week'),
  thisMonth('This Month'),
  custom('Custom Range');

  final String label;
  const OrderDatePreset(this.label);
}

/// Order list screen — Comprehensive Dashboard / Report UI.
class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _OrderListReportView();
  }
}

class _OrderListReportView extends ConsumerStatefulWidget {
  const _OrderListReportView();

  @override
  ConsumerState<_OrderListReportView> createState() =>
      _OrderListReportViewState();
}

class _OrderListReportViewState extends ConsumerState<_OrderListReportView> {
  int _selectedFilter = 0; // 0: All, 1: On Process, 2: Completed
  String _searchQuery = '';
  final _searchController = TextEditingController();
  bool _sortNewestFirst = true;

  OrderDatePreset _datePreset = OrderDatePreset.all;
  DateTimeRange? _customDateRange;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  DateTimeRange? get _effectiveDateRange {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    switch (_datePreset) {
      case OrderDatePreset.all:
        return null;
      case OrderDatePreset.today:
        return DateTimeRange(start: todayStart, end: todayEnd);
      case OrderDatePreset.yesterday:
        final yesterdayStart = todayStart.subtract(const Duration(days: 1));
        final yesterdayEnd = DateTime(
          yesterdayStart.year,
          yesterdayStart.month,
          yesterdayStart.day,
          23,
          59,
          59,
          999,
        );
        return DateTimeRange(start: yesterdayStart, end: yesterdayEnd);
      case OrderDatePreset.thisWeek:
        final monday = todayStart.subtract(Duration(days: todayStart.weekday - 1));
        final sunday = DateTime(
          monday.year,
          monday.month,
          monday.day + 6,
          23,
          59,
          59,
          999,
        );
        return DateTimeRange(start: monday, end: sunday);
      case OrderDatePreset.thisMonth:
        final firstDay = DateTime(now.year, now.month, 1);
        final lastDay = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
        return DateTimeRange(start: firstDay, end: lastDay);
      case OrderDatePreset.custom:
        if (_customDateRange == null) return null;
        return DateTimeRange(
          start: DateTime(
            _customDateRange!.start.year,
            _customDateRange!.start.month,
            _customDateRange!.start.day,
          ),
          end: DateTime(
            _customDateRange!.end.year,
            _customDateRange!.end.month,
            _customDateRange!.end.day,
            23,
            59,
            59,
            999,
          ),
        );
    }
  }

  String get _dateFilterLabel {
    switch (_datePreset) {
      case OrderDatePreset.all:
        return 'All Dates';
      case OrderDatePreset.today:
        return 'Today';
      case OrderDatePreset.yesterday:
        return 'Yesterday';
      case OrderDatePreset.thisWeek:
        return 'This Week';
      case OrderDatePreset.thisMonth:
        return 'This Month';
      case OrderDatePreset.custom:
        if (_customDateRange != null) {
          final start = DateFormat('d MMM').format(_customDateRange!.start);
          final end = DateFormat('d MMM').format(_customDateRange!.end);
          return '$start - $end';
        }
        return 'Custom';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(orderListProvider);
    final theme = Theme.of(context);
    final isDesktop = DeviceType.from(context) == DeviceType.desktop ||
        DeviceType.from(context) == DeviceType.large ||
        DeviceType.from(context) == DeviceType.tablet;

    final dateStr = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: CustomAppBar(
        title: Text(
          isDesktop ? 'Order Report' : 'Orders',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: isDesktop ? 22 : 18,
            color: AppColors.slate900,
          ),
        ),
        actions: [
          if (isDesktop) ...[
            Text(
              dateStr,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.slate600,
              ),
            ),
            const SizedBox(width: 16),
          ] else ...[
            IconButton(
              icon:
                  const Icon(Icons.refresh_rounded, color: AppColors.slate700),
              tooltip: 'Refresh',
              visualDensity: VisualDensity.compact,
              onPressed: () => ref.refresh(orderListProvider.future),
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.greenNude.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.greenNude,
                  size: 18,
                ),
              ),
              tooltip: 'Create Online Order',
              visualDensity: VisualDensity.compact,
              onPressed: () => context.pushNamed('orderNew'),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
      body: ordersAsync.when(
        loading: () => const SkeletonListLoader(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.refresh(orderListProvider.future),
        ),
        data: (orders) {
          // ── Date Filtering ──
          final dateRange = _effectiveDateRange;
          List<Order> dateFilteredOrders = orders;
          if (dateRange != null) {
            dateFilteredOrders = orders.where((o) {
              return (o.createdAt.isAfter(dateRange.start) ||
                      o.createdAt.isAtSameMomentAs(dateRange.start)) &&
                  (o.createdAt.isBefore(dateRange.end) ||
                      o.createdAt.isAtSameMomentAs(dateRange.end));
            }).toList();
          }

          // Dynamic Counts for filters (based on date-filtered set)
          final allCount = dateFilteredOrders.length;
          final activeCount =
              dateFilteredOrders.where((o) => o.status.isActive).length;
          final completedCount =
              dateFilteredOrders.where((o) => o.status.isFinal).length;
          final totalSales = dateFilteredOrders
              .where((o) => o.status != OrderStatus.cancelled)
              .fold<double>(0.0, (sum, o) => sum + o.totalAmount);

          // Status Filter Logic
          List<Order> filteredOrders;
          if (_selectedFilter == 1) {
            filteredOrders =
                dateFilteredOrders.where((o) => o.status.isActive).toList();
          } else if (_selectedFilter == 2) {
            filteredOrders =
                dateFilteredOrders.where((o) => o.status.isFinal).toList();
          } else {
            filteredOrders = dateFilteredOrders.toList();
          }

          if (_searchQuery.isNotEmpty) {
            filteredOrders = filteredOrders.where((o) {
              final cName = o.customerName.toLowerCase();
              final id = o.id.toLowerCase();
              final phone = o.customerPhone?.toLowerCase() ?? '';
              return cName.contains(_searchQuery) ||
                  id.contains(_searchQuery) ||
                  phone.contains(_searchQuery);
            }).toList();
          }

          // Sort Logic
          filteredOrders.sort((a, b) {
            if (_sortNewestFirst) {
              return b.createdAt.compareTo(a.createdAt);
            } else {
              return a.createdAt.compareTo(b.createdAt);
            }
          });

          return Column(
            children: [
              // ── Header (Desktop vs Mobile) ──
              if (isDesktop) ...[
                _buildDesktopHeader(),
                if (_datePreset != OrderDatePreset.all)
                  _buildDesktopMetrics(
                    allCount: allCount,
                    totalSales: totalSales,
                    activeCount: activeCount,
                    completedCount: completedCount,
                  ),
              ] else
                _buildMobileHeader(
                  allCount: allCount,
                  activeCount: activeCount,
                  completedCount: completedCount,
                  filteredCount: filteredOrders.length,
                ),

              // ── Data Content ──
              Expanded(
                child: Stack(
                  children: [
                    filteredOrders.isEmpty
                        ? _EmptyOrdersView(
                            hasFilters: _searchQuery.isNotEmpty ||
                                _selectedFilter != 0 ||
                                _datePreset != OrderDatePreset.all,
                            onReset: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _selectedFilter = 0;
                                _datePreset = OrderDatePreset.all;
                                _customDateRange = null;
                              });
                            },
                          )
                        : (isDesktop
                            ? _buildDesktopTable(filteredOrders)
                            : _buildMobileList(
                                filteredOrders,
                                bottomPadding:
                                    _datePreset != OrderDatePreset.all
                                        ? 90.0
                                        : 24.0,
                              )),

                    // Floating Summary Bar on Mobile (Only shown when date filter is applied)
                    if (!isDesktop && _datePreset != OrderDatePreset.all)
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: _buildMobileFloatingSummaryBar(
                          allCount: allCount,
                          totalSales: totalSales,
                          activeCount: activeCount,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Desktop Dashboard Header ──
  Widget _buildDesktopHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Search Bar
              Container(
                width: 240,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.slate200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        size: 18, color: AppColors.slate400),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(
                            () => _searchQuery = val.toLowerCase().trim()),
                        decoration: const InputDecoration(
                          hintText: 'Search order or customer',
                          hintStyle: TextStyle(
                              fontSize: 13, color: AppColors.slate400),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: const Icon(Icons.close,
                            size: 16, color: AppColors.slate400),
                      ),
                  ],
                ),
              ),

              // Date Filter Dropdown
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.slate200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<OrderDatePreset>(
                    value: _datePreset,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.slate700,
                        fontWeight: FontWeight.w500),
                    items: OrderDatePreset.values.map((p) {
                      String label = p.label;
                      if (p == OrderDatePreset.custom && _customDateRange != null) {
                        label =
                            '${DateFormat('d MMM').format(_customDateRange!.start)} - ${DateFormat('d MMM').format(_customDateRange!.end)}';
                      }
                      return DropdownMenuItem(
                        value: p,
                        child: Text(label),
                      );
                    }).toList(),
                    onChanged: (val) async {
                      if (val == OrderDatePreset.custom) {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          initialDateRange: _customDateRange ??
                              DateTimeRange(
                                start: DateTime.now().subtract(const Duration(days: 7)),
                                end: DateTime.now(),
                              ),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme:
                                    Theme.of(context).colorScheme.copyWith(
                                          primary: AppColors.greenNude,
                                          onPrimary: Colors.black,
                                        ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _datePreset = OrderDatePreset.custom;
                            _customDateRange = picked;
                          });
                        }
                      } else if (val != null) {
                        setState(() => _datePreset = val);
                      }
                    },
                  ),
                ),
              ),

              // Status Filter Dropdown
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.slate200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedFilter,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.slate700,
                        fontWeight: FontWeight.w500),
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('All Statuses')),
                      DropdownMenuItem(
                          value: 1, child: Text('Active (On Process)')),
                      DropdownMenuItem(value: 2, child: Text('Completed')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedFilter = val);
                    },
                  ),
                ),
              ),

              // Date Sort Toggle
              InkWell(
                onTap: () =>
                    setState(() => _sortNewestFirst = !_sortNewestFirst),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.slate200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sort,
                          size: 16, color: AppColors.slate600),
                      const SizedBox(width: 6),
                      Text(
                        _sortNewestFirst ? 'Newest First' : 'Oldest First',
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.slate700,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),

              // Refresh Button
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.slate500),
                onPressed: () => ref.refresh(orderListProvider.future),
                tooltip: 'Refresh',
              ),
            ],
          ),

          // Actions
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppButton(
                label: 'Export CSV',
                icon: const Icon(Icons.download, size: 16),
                variant: AppButtonVariant.secondary,
                onPressed: () {
                  AppSnackBar.showInfo(
                    context,
                    'Exporting to CSV...',
                  );
                },
              ),
              AppButton(
                label: 'Online Order',
                icon: const Icon(Icons.add, size: 16),
                variant: AppButtonVariant.primary,
                onPressed: () => context.pushNamed('orderNew'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Desktop Dashboard Metrics Row ──
  Widget _buildDesktopMetrics({
    required int allCount,
    required double totalSales,
    required int activeCount,
    required int completedCount,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: _buildDesktopMetricCard(
              title: 'Total Orders',
              value: '$allCount',
              icon: Icons.receipt_long_rounded,
              color: AppColors.info,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDesktopMetricCard(
              title: 'Total Sales',
              value: CurrencyFormatter.format(totalSales),
              icon: Icons.payments_outlined,
              color: AppColors.greenNude,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDesktopMetricCard(
              title: 'Active Orders',
              value: '$activeCount',
              icon: Icons.pending_actions_rounded,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDesktopMetricCard(
              title: 'Completed',
              value: '$completedCount',
              icon: Icons.check_circle_outline_rounded,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.slate900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Floating Summary Bar on Mobile (Appears only when Date Filter is active) ──
  Widget _buildMobileFloatingSummaryBar({
    required int allCount,
    required double totalSales,
    required int activeCount,
  }) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.slate900,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Calendar Icon & Date Label
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.greenNude,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),

            // Date label + Total Sales
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _dateFilterLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.greenNude.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$allCount orders',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.greenNude,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.format(totalSales),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Active count badge (if any active)
            if (activeCount > 0) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.4),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                    Text(
                      '$activeCount',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],

            // Close / Clear Date Filter Button
            InkWell(
              onTap: () {
                setState(() {
                  _datePreset = OrderDatePreset.all;
                  _customDateRange = null;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Mobile Header (Compact, Classic & Comprehensive) ──
  Widget _buildMobileHeader({
    required int allCount,
    required int activeCount,
    required int completedCount,
    required int filteredCount,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Field + Date Filter Pill + Sort Toggle
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
                    onChanged: (val) =>
                        setState(() => _searchQuery = val.toLowerCase().trim()),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.slate900,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search order #, customer...',
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
                        minWidth: 32,
                        minHeight: 34,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.cancel_rounded,
                                size: 16,
                                color: AppColors.slate400,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              splashRadius: 16,
                              padding: EdgeInsets.zero,
                            )
                          : null,
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 28,
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

              // Date Filter Pill
              InkWell(
                onTap: () => _showDateFilterBottomSheet(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    color: _datePreset != OrderDatePreset.all
                        ? AppColors.greenNude.withValues(alpha: 0.18)
                        : AppColors.slate100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _datePreset != OrderDatePreset.all
                          ? AppColors.greenNude
                          : AppColors.slate200,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: _datePreset != OrderDatePreset.all
                            ? AppColors.slate900
                            : AppColors.slate600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _dateFilterLabel,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: _datePreset != OrderDatePreset.all
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _datePreset != OrderDatePreset.all
                              ? AppColors.slate900
                              : AppColors.slate700,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 15,
                        color: _datePreset != OrderDatePreset.all
                            ? AppColors.slate900
                            : AppColors.slate400,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),

              // Sort Toggle Pill
              InkWell(
                onTap: () =>
                    setState(() => _sortNewestFirst = !_sortNewestFirst),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: _sortNewestFirst
                        ? AppColors.slate100
                        : AppColors.greenNude.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _sortNewestFirst
                          ? AppColors.slate200
                          : AppColors.greenNude,
                      width: 0.8,
                    ),
                  ),
                  child: Icon(
                    _sortNewestFirst
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    size: 15,
                    color: _sortNewestFirst
                        ? AppColors.slate700
                        : AppColors.greenNude,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Horizontal Status Filter Chips + Active Date Badge
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  index: 0,
                  label: 'All Orders',
                  count: allCount,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  index: 1,
                  label: 'Active',
                  count: activeCount,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  index: 2,
                  label: 'Completed',
                  count: completedCount,
                ),
                if (_datePreset != OrderDatePreset.all) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.greenNude.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: AppColors.greenNude, width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.event_note_rounded,
                          size: 13,
                          color: AppColors.slate900,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _dateFilterLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _datePreset = OrderDatePreset.all;
                              _customDateRange = null;
                            });
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: AppColors.slate900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Result Summary & Reset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$filteredCount ${filteredCount == 1 ? 'order' : 'orders'} found',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate500,
                ),
              ),
              if (_selectedFilter != 0 ||
                  _searchQuery.isNotEmpty ||
                  _datePreset != OrderDatePreset.all)
                InkWell(
                  onTap: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _selectedFilter = 0;
                      _datePreset = OrderDatePreset.all;
                      _customDateRange = null;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      'Reset all filters',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Date Filter Bottom Sheet ──
  void _showDateFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.slate300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Orders by Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                    ),
                    if (_datePreset != OrderDatePreset.all)
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _datePreset = OrderDatePreset.all;
                            _customDateRange = null;
                          });
                        },
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                ...OrderDatePreset.values.map((preset) {
                  final isSelected = _datePreset == preset;
                  String? subtitle;
                  final now = DateTime.now();
                  if (preset == OrderDatePreset.today) {
                    subtitle = DateFormat('d MMMM yyyy').format(now);
                  } else if (preset == OrderDatePreset.yesterday) {
                    subtitle = DateFormat('d MMMM yyyy')
                        .format(now.subtract(const Duration(days: 1)));
                  } else if (preset == OrderDatePreset.thisWeek) {
                    final mon = now.subtract(Duration(days: now.weekday - 1));
                    final sun = mon.add(const Duration(days: 6));
                    subtitle =
                        '${DateFormat('d MMM').format(mon)} - ${DateFormat('d MMM').format(sun)}';
                  } else if (preset == OrderDatePreset.thisMonth) {
                    subtitle = DateFormat('MMMM yyyy').format(now);
                  } else if (preset == OrderDatePreset.custom &&
                      _customDateRange != null) {
                    subtitle =
                        '${DateFormat('d MMM yyyy').format(_customDateRange!.start)} - ${DateFormat('d MMM yyyy').format(_customDateRange!.end)}';
                  }

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.greenNude.withValues(alpha: 0.18)
                            : AppColors.slate100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        preset == OrderDatePreset.custom
                            ? Icons.date_range_rounded
                            : Icons.calendar_today_rounded,
                        size: 18,
                        color: isSelected
                            ? AppColors.slate900
                            : AppColors.slate600,
                      ),
                    ),
                    title: Text(
                      preset.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.slate900
                            : AppColors.slate800,
                      ),
                    ),
                    subtitle: subtitle != null
                        ? Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.slate500,
                            ),
                          )
                        : null,
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded,
                            color: AppColors.greenNude, size: 20)
                        : null,
                    onTap: () async {
                      if (preset == OrderDatePreset.custom) {
                        Navigator.pop(ctx);
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          initialDateRange: _customDateRange ??
                              DateTimeRange(
                                start: DateTime.now()
                                    .subtract(const Duration(days: 7)),
                                end: DateTime.now(),
                              ),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme:
                                    Theme.of(context).colorScheme.copyWith(
                                          primary: AppColors.greenNude,
                                          onPrimary: Colors.black,
                                        ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _datePreset = OrderDatePreset.custom;
                            _customDateRange = picked;
                          });
                        }
                      } else {
                        Navigator.pop(ctx);
                        setState(() {
                          _datePreset = preset;
                        });
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
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
                color: isSelected ? Colors.white : AppColors.slate700,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : AppColors.slate200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.slate700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Desktop Table ──
  Widget _buildDesktopTable(List<Order> filteredOrders) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.slate200),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AppDataTable(
            columns: const [
              DataColumn(
                  label: Text('Order ID',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              DataColumn(
                  label: Text('Date & Time',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              DataColumn(
                  label: Text('Customer',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              DataColumn(
                  label: Text('Items',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              DataColumn(
                  label: Text('Total',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              DataColumn(
                  label: Text('Status',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              DataColumn(
                  label: Text('Action',
                      style: TextStyle(fontWeight: FontWeight.w600))),
            ],
            rows: filteredOrders.map((o) {
              final date = DateFormat('MMM d, yyyy HH:mm').format(o.createdAt);
              final itemCount =
                  o.items.fold(0, (sum, item) => sum + item.quantity);

              return DataRow(cells: [
                DataCell(Text('#${o.id.substring(0, 8)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.slate900))),
                DataCell(Text(date,
                    style: const TextStyle(color: AppColors.slate600))),
                DataCell(Text(
                    o.customerName.isEmpty
                        ? 'Walk-in Customer'
                        : o.customerName,
                    style: const TextStyle(color: AppColors.slate800))),
                DataCell(Text('$itemCount items',
                    style: const TextStyle(color: AppColors.slate600))),
                DataCell(Text(CurrencyFormatter.format(o.totalAmount),
                    style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(OrderStatusBadge(status: o.status)),
                DataCell(AppButton(
                  label: 'View',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context
                      .pushNamed('orderDetail', pathParameters: {'id': o.id}),
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ── Mobile Orders List ──
  Widget _buildMobileList(
    List<Order> filteredOrders, {
    double bottomPadding = 24.0,
  }) {
    return RefreshIndicator(
      color: AppColors.greenNude,
      onRefresh: () => ref.refresh(orderListProvider.future),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
        itemCount: filteredOrders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final o = filteredOrders[i];
          return OrderCard(
            order: o,
            onTap: () =>
                context.pushNamed('orderDetail', pathParameters: {'id': o.id}),
          );
        },
      ),
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView({
    this.hasFilters = false,
    this.onReset,
  });

  final bool hasFilters;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
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
                Icons.assignment_outlined,
                size: 32,
                color: AppColors.slate400,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No orders found',
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
                  ? 'No orders matched your search or status filter.'
                  : 'Orders will appear here once created.',
              style: const TextStyle(
                color: AppColors.slate500,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilters && onReset != null) ...[
              const SizedBox(height: 16),
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}
