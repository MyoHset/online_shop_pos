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
import '../../../../core/widgets/custom_app_bar.dart';
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

class _OrderListReportViewState extends ConsumerState<_OrderListReportView> {
  int _selectedFilter = 0; // 0: All, 1: On Process, 2: Completed
  String _searchQuery = '';
  bool _sortNewestFirst = true;

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
      appBar: const CustomAppBar(titleText: 'Order Management'),
      body: Column(
        children: [
          // ── Dashboard Header ──
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Row: Title and Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Order Report',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.slate900,
                      ),
                    ),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

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
                                  onChanged: (val) => setState(
                                      () => _searchQuery = val.toLowerCase()),
                                  decoration: const InputDecoration(
                                    hintText: 'Search order or customer',
                                    hintStyle: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.slate400),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
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
                                if (val != null)
                                  setState(() => _selectedFilter = val);
                              },
                            ),
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
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Exporting to CSV...')));
                          },
                        ),
                        AppButton(
                          label: 'New Order',
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
                // Filter Logic
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

                if (_searchQuery.isNotEmpty) {
                  filteredOrders = filteredOrders.where((o) {
                    final cName = o.customerName.toLowerCase();
                    final id = o.id.toLowerCase();
                    return cName.contains(_searchQuery) ||
                        id.contains(_searchQuery);
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

                if (filteredOrders.isEmpty) {
                  return const _EmptyOrdersView();
                }

                if (isDesktop) {
                  // Tabular Report View for Desktop
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
                          // minWidth: 900,
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
                            final itemCount = o.items
                                .fold(0, (sum, item) => sum + item.quantity);

                            return DataRow(cells: [
                              DataCell(Text('#${o.id.substring(0, 8)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.slate900))),
                              DataCell(Text(date,
                                  style: const TextStyle(
                                      color: AppColors.slate600))),
                              DataCell(Text(
                                  o.customerName.isEmpty
                                      ? 'Walk-in Customer'
                                      : o.customerName,
                                  style: const TextStyle(
                                      color: AppColors.slate800))),
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
                  );
                } else {
                  // Fallback for mobile: standard ListView builder
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
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
                  );
                }
              },
            ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.content_paste_outlined,
              size: 100,
              color: AppColors.slate200,
            ),
            const SizedBox(height: 32),
            const Text(
              'No orders found',
              style: TextStyle(
                color: AppColors.slate900,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or filter criteria.',
              style: TextStyle(
                color: AppColors.slate400,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
