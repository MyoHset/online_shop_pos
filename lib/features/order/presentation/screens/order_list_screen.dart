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
import '../../../../core/widgets/search_text_field.dart';
import '../../domain/entities/order.dart';
import '../providers/order_list_provider.dart';
import '../widgets/order_card.dart';
import '../widgets/order_status_badge.dart';

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

enum DateFilterPreset {
  allTime('All Dates'),
  today('Today'),
  thisWeek('This Week'),
  thisMonth('This Month'),
  custom('Custom Range');

  final String label;
  const DateFilterPreset(this.label);
}

class _OrderListReportViewState extends ConsumerState<_OrderListReportView> {
  int _selectedFilter = 0; // 0: All, 1: On Process, 2: Completed
  String _searchQuery = '';
  bool _sortNewestFirst = true;
  DateFilterPreset _selectedDatePreset = DateFilterPreset.allTime;
  DateTimeRange? _customDateRange;

  String get _dateFilterLabel {
    switch (_selectedDatePreset) {
      case DateFilterPreset.allTime:
        return 'All Dates';
      case DateFilterPreset.today:
        return 'Today';
      case DateFilterPreset.thisWeek:
        return 'This Week';
      case DateFilterPreset.thisMonth:
        return 'This Month';
      case DateFilterPreset.custom:
        if (_customDateRange != null) {
          final start = DateFormat('MMM d').format(_customDateRange!.start);
          final end = DateFormat('MMM d').format(_customDateRange!.end);
          return '$start - $end';
        }
        return 'Custom Range';
    }
  }

  Future<void> _pickCustomDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _customDateRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 7)),
            end: now,
          ),
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.slate900,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.slate900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDatePreset = DateFilterPreset.custom;
        _customDateRange = picked;
      });
    }
  }

  PopupMenuItem<DateFilterPreset> _buildDateFilterItem(
    DateFilterPreset preset,
    String title, {
    IconData? icon,
  }) {
    final isSelected = _selectedDatePreset == preset;
    return PopupMenuItem<DateFilterPreset>(
      value: preset,
      height: 38,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 16,
                color: isSelected ? AppColors.slate900 : AppColors.slate500),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.slate900 : AppColors.slate700,
              ),
            ),
          ),
          if (isSelected)
            const Icon(Icons.check, size: 16, color: AppColors.slate900),
        ],
      ),
    );
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
          'Order Report',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.slate900,
          ),
        ),
        actions: [
          Text(
            dateStr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.slate600,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // ── Dashboard Header ──
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bottom Row: Filters and Search (Responsive wrapping)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    // Search and Filter Group
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Customer & Order Search Field
                        SearchTextField(
                          value: _searchQuery,
                          hintText: 'Search customer, phone, ID...',
                          prefixIcon: const Icon(
                            Icons.person_search_outlined,
                            size: 18,
                          ),
                          width: 280,
                          debounceDuration: Duration.zero,
                          onChanged: (val) => setState(
                            () => _searchQuery = val.toLowerCase().trim(),
                          ),
                          onClear: () => setState(() => _searchQuery = ''),
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
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 18),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.slate700,
                                  fontWeight: FontWeight.w500),
                              items: const [
                                DropdownMenuItem(
                                    value: 0, child: Text('All Statuses')),
                                DropdownMenuItem(
                                    value: 1,
                                    child: Text('Active (On Process)')),
                                DropdownMenuItem(
                                    value: 2, child: Text('Completed')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedFilter = val);
                                }
                              },
                            ),
                          ),
                        ),

                        // Date Filter Dropdown / Preset Picker
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _selectedDatePreset !=
                                      DateFilterPreset.allTime
                                  ? AppColors.slate900
                                  : AppColors.slate200,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PopupMenuButton<DateFilterPreset>(
                                tooltip: 'Filter by date',
                                color: Colors.white,
                                offset: const Offset(0, 44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onSelected: (preset) {
                                  if (preset == DateFilterPreset.custom) {
                                    _pickCustomDateRange();
                                  } else {
                                    setState(() {
                                      _selectedDatePreset = preset;
                                      _customDateRange = null;
                                    });
                                  }
                                },
                                itemBuilder: (context) => [
                                  _buildDateFilterItem(
                                      DateFilterPreset.allTime, 'All Dates'),
                                  _buildDateFilterItem(
                                      DateFilterPreset.today, 'Today'),
                                  _buildDateFilterItem(
                                      DateFilterPreset.thisWeek, 'This Week'),
                                  _buildDateFilterItem(
                                      DateFilterPreset.thisMonth, 'This Month'),
                                  const PopupMenuDivider(),
                                  _buildDateFilterItem(
                                    DateFilterPreset.custom,
                                    'Custom Range...',
                                    icon: Icons.date_range_outlined,
                                  ),
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 15,
                                        color: _selectedDatePreset !=
                                                DateFilterPreset.allTime
                                            ? AppColors.slate900
                                            : AppColors.slate600,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _dateFilterLabel,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: _selectedDatePreset !=
                                                  DateFilterPreset.allTime
                                              ? AppColors.slate900
                                              : AppColors.slate700,
                                          fontWeight: _selectedDatePreset !=
                                                  DateFilterPreset.allTime
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 18,
                                        color: AppColors.slate500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_selectedDatePreset !=
                                  DateFilterPreset.allTime)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedDatePreset =
                                            DateFilterPreset.allTime;
                                        _customDateRange = null;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(Icons.close,
                                          size: 14, color: AppColors.slate500),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Date Sort Toggle
                        InkWell(
                          onTap: () => setState(
                              () => _sortNewestFirst = !_sortNewestFirst),
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
                                  _sortNewestFirst
                                      ? 'Newest First'
                                      : 'Oldest First',
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
                          icon: const Icon(Icons.refresh,
                              color: AppColors.slate500),
                          onPressed: () =>
                              ref.refresh(orderListProvider.future),
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
              ],
            ),
          ),

          // ── Data Content ──
          Expanded(
            child: ordersAsync.when(
              loading: () => const SkeletonListLoader(),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.refresh(orderListProvider.future),
              ),
              data: (orders) {
                // 1. Filter Logic by Status
                List<Order> filteredOrders;
                if (_selectedFilter == 1) {
                  filteredOrders =
                      orders.where((o) => o.status.isActive).toList();
                } else if (_selectedFilter == 2) {
                  filteredOrders =
                      orders.where((o) => o.status.isFinal).toList();
                } else {
                  filteredOrders = orders.toList();
                }

                // 2. Date Filter Logic
                if (_selectedDatePreset != DateFilterPreset.allTime) {
                  final now = DateTime.now();
                  filteredOrders = filteredOrders.where((o) {
                    final d = o.createdAt;
                    switch (_selectedDatePreset) {
                      case DateFilterPreset.allTime:
                        return true;
                      case DateFilterPreset.today:
                        final start = DateTime(now.year, now.month, now.day);
                        final end = DateTime(
                            now.year, now.month, now.day, 23, 59, 59, 999);
                        return !d.isBefore(start) && !d.isAfter(end);
                      case DateFilterPreset.thisWeek:
                        final startOfWeek =
                            DateTime(now.year, now.month, now.day)
                                .subtract(Duration(days: now.weekday - 1));
                        final endOfWeek = DateTime(
                            startOfWeek.year,
                            startOfWeek.month,
                            startOfWeek.day + 6,
                            23,
                            59,
                            59,
                            999);
                        return !d.isBefore(startOfWeek) &&
                            !d.isAfter(endOfWeek);
                      case DateFilterPreset.thisMonth:
                        final startOfMonth = DateTime(now.year, now.month, 1);
                        final endOfMonth = DateTime(
                            now.year, now.month + 1, 0, 23, 59, 59, 999);
                        return !d.isBefore(startOfMonth) &&
                            !d.isAfter(endOfMonth);
                      case DateFilterPreset.custom:
                        if (_customDateRange == null) return true;
                        final start = DateTime(
                            _customDateRange!.start.year,
                            _customDateRange!.start.month,
                            _customDateRange!.start.day);
                        final end = DateTime(
                            _customDateRange!.end.year,
                            _customDateRange!.end.month,
                            _customDateRange!.end.day,
                            23,
                            59,
                            59,
                            999);
                        return !d.isBefore(start) && !d.isAfter(end);
                    }
                  }).toList();
                }

                // 3. Search Filter Logic (Order ID, Customer Name, Phone)
                if (_searchQuery.isNotEmpty) {
                  filteredOrders = filteredOrders.where((o) {
                    final cName = o.customerName.toLowerCase();
                    final id = o.id.toLowerCase();
                    final phone = (o.customerPhone ?? '').toLowerCase();
                    return cName.contains(_searchQuery) ||
                        id.contains(_searchQuery) ||
                        phone.contains(_searchQuery);
                  }).toList();
                }

                // 4. Sort Logic
                filteredOrders.sort((a, b) {
                  if (_sortNewestFirst) {
                    return b.createdAt.compareTo(a.createdAt);
                  } else {
                    return a.createdAt.compareTo(b.createdAt);
                  }
                });

                final totalSales =
                    filteredOrders.fold(0.0, (sum, o) => sum + o.totalAmount);
                final totalItems = filteredOrders.fold(
                    0,
                    (sum, o) =>
                        sum +
                        o.items.fold(0, (iSum, item) => iSum + item.quantity));

                return Stack(
                  children: [
                    if (filteredOrders.isEmpty)
                      const _EmptyOrdersView()
                    else if (isDesktop)
                      // Tabular Report View for Desktop
                      SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          24,
                          0,
                          24,
                          _selectedDatePreset != DateFilterPreset.allTime
                              ? 96
                              : 24,
                        ),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                DataColumn(
                                    label: Text('Date & Time',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                DataColumn(
                                    label: Text('Customer',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                DataColumn(
                                    label: Text('Items',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                DataColumn(
                                    label: Text('Total',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                DataColumn(
                                    label: Text('Status',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                DataColumn(
                                    label: Text('Action',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                              ],
                              rows: filteredOrders.map((o) {
                                final date = DateFormat('MMM d, yyyy HH:mm')
                                    .format(o.createdAt);
                                final itemCount = o.items.fold(
                                    0, (sum, item) => sum + item.quantity);

                                return DataRow(cells: [
                                  DataCell(Text('#${o.id.substring(0, 8)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.slate900))),
                                  DataCell(Text(date,
                                      style: const TextStyle(
                                          color: AppColors.slate600))),
                                  DataCell(_CustomerCell(
                                    customerName: o.customerName,
                                    customerPhone: o.customerPhone,
                                    orderType: o.orderType,
                                  )),
                                  DataCell(Text('$itemCount items',
                                      style: const TextStyle(
                                          color: AppColors.slate600))),
                                  DataCell(Text(
                                      CurrencyFormatter.format(o.totalAmount),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600))),
                                  DataCell(OrderStatusBadge(status: o.status)),
                                  DataCell(AppButton(
                                    label: 'View',
                                    variant: AppButtonVariant.secondary,
                                    onPressed: () => context.pushNamed(
                                        'orderDetail',
                                        pathParameters: {'id': o.id}),
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    else
                      // Fallback for mobile: standard ListView builder
                      ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          _selectedDatePreset != DateFilterPreset.allTime
                              ? 96
                              : 16,
                        ),
                        itemCount: filteredOrders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final o = filteredOrders[i];
                          return OrderCard(
                            order: o,
                            onTap: () => context.pushNamed('orderDetail',
                                pathParameters: {'id': o.id}),
                          );
                        },
                      ),

                    // Floating Sale Summary Bar when Date Filter is active
                    if (_selectedDatePreset != DateFilterPreset.allTime)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 20,
                        child: Center(
                          child: _FloatingSaleSummaryBar(
                            dateLabel: _dateFilterLabel,
                            totalOrders: filteredOrders.length,
                            totalSales: totalSales,
                            totalItems: totalItems,
                            isCompact: !isDesktop,
                            onClearDateFilter: () {
                              setState(() {
                                _selectedDatePreset = DateFilterPreset.allTime;
                                _customDateRange = null;
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCell extends StatelessWidget {
  const _CustomerCell({
    required this.customerName,
    required this.customerPhone,
    required this.orderType,
  });

  final String customerName;
  final String? customerPhone;
  final OrderType orderType;

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isWalkIn = customerName.isEmpty || customerName == 'Walk-in Customer';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isWalkIn ? AppColors.slate100 : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
              border: Border.all(
                color: isWalkIn ? AppColors.slate200 : AppColors.slate300,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: isWalkIn
                ? const Icon(
                    Icons.storefront_outlined,
                    size: 16,
                    color: AppColors.slate500,
                  )
                : Text(
                    _getInitials(customerName),
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
                isWalkIn ? 'Walk-in Customer' : customerName,
                style: TextStyle(
                  fontWeight: isWalkIn ? FontWeight.w600 : FontWeight.w700,
                  fontSize: 13,
                  color: isWalkIn ? AppColors.slate700 : AppColors.slate900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              if (customerPhone != null && customerPhone!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 11,
                      color: AppColors.slate400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      customerPhone!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.slate500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  orderType.displayLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.slate400,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.content_paste_outlined,
              size: 100,
              color: AppColors.slate200,
            ),
            SizedBox(height: 32),
            Text(
              'No orders found',
              style: TextStyle(
                color: AppColors.slate900,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria.',
              style: TextStyle(
                color: AppColors.slate400,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}

class _FloatingSaleSummaryBar extends StatelessWidget {
  const _FloatingSaleSummaryBar({
    required this.dateLabel,
    required this.totalOrders,
    required this.totalSales,
    required this.totalItems,
    required this.onClearDateFilter,
    required this.isCompact,
  });

  final String dateLabel;
  final int totalOrders;
  final double totalSales;
  final int totalItems;
  final VoidCallback onClearDateFilter;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isCompact ? 360 : 660,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 14 : 20,
          vertical: isCompact ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A), // Deep slate 900
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: isCompact ? _buildCompactView() : _buildFullView(),
      ),
    );
  }

  Widget _buildCompactView() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.greenNude.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.insights_rounded,
            size: 16,
            color: AppColors.greenNude,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$dateLabel • $totalOrders Orders ($totalItems items)',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Text(
                CurrencyFormatter.format(totalSales),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 16, color: Colors.white60),
          onPressed: onClearDateFilter,
          tooltip: 'Clear Date Filter',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildFullView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Date Icon & Label Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: AppColors.greenNude,
              ),
              const SizedBox(width: 6),
              Text(
                dateLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _divider(),
        const SizedBox(width: 16),

        // Orders Count
        _metricItem(
          label: 'ORDERS',
          value: '$totalOrders',
        ),
        const SizedBox(width: 16),
        _divider(),
        const SizedBox(width: 16),

        // Items Count
        _metricItem(
          label: 'ITEMS SOLD',
          value: '$totalItems',
        ),
        const SizedBox(width: 16),
        _divider(),
        const SizedBox(width: 16),

        // Total Revenue
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TOTAL SALES',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.greenNude,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              CurrencyFormatter.format(totalSales),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),

        // Clear Button
        InkWell(
          onTap: onClearDateFilter,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.white.withValues(alpha: 0.15),
    );
  }

  Widget _metricItem({required String label, required String value}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.6),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
