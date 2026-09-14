import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/order.dart';
import '../providers/order_list_provider.dart';
import '../widgets/order_card.dart';

/// Order list screen — minimalist design with Active / Completed tabs.
class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _OrderListTabbedView();
  }
}


class _OrderListTabbedView extends ConsumerStatefulWidget {
  const _OrderListTabbedView();

  @override
  ConsumerState<_OrderListTabbedView> createState() => _OrderListTabbedViewState();
}

class _OrderListTabbedViewState extends ConsumerState<_OrderListTabbedView> {
  // 0: All, 1: On Process, 2: Completed
  int _selectedFilter = 1;

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(orderListProvider);
    final theme = Theme.of(context);
    final isDesktop = DeviceType.from(context) == DeviceType.desktop ||
        DeviceType.from(context) == DeviceType.large;
    final crossAxisCount =
        isDesktop ? 3 : (DeviceType.from(context) == DeviceType.tablet ? 2 : 1);

    final dateStr = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.slate50,
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
                      'Orders',
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
                
                // Bottom Row: Filters and Search
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Filter Chips
                    Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          isSelected: _selectedFilter == 0,
                          onTap: () => setState(() => _selectedFilter = 0),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'On Process',
                          isSelected: _selectedFilter == 1,
                          onTap: () => setState(() => _selectedFilter = 1),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Completed',
                          isSelected: _selectedFilter == 2,
                          onTap: () => setState(() => _selectedFilter = 2),
                        ),
                      ],
                    ),
                    
                    // Search and Action
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {}, // Future: filter
                        ),
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
                              const Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search a name, order, or etc',
                                    hintStyle: TextStyle(fontSize: 13, color: AppColors.slate400),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    filled: false,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              const Icon(Icons.search, size: 18, color: AppColors.slate400),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        AppButton(
                          label: 'New Order',
                          icon: const Icon(Icons.add, size: 16),
                          variant: AppButtonVariant.primary,
                          minimumWidth: 120,
                          onPressed: () => context.pushNamed('orderNew'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // ── Grid Content ──
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
                  filteredOrders = orders.where((o) => o.status.isActive).toList();
                } else if (_selectedFilter == 2) {
                  filteredOrders = orders.where((o) => o.status.isFinal).toList();
                } else {
                  filteredOrders = orders;
                }

                if (filteredOrders.isEmpty) {
                  return _EmptyOrdersView(filterState: _selectedFilter);
                }

                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 320,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          mainAxisExtent: 140, // Height for compact card
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            return OrderCard(
                              order: filteredOrders[i],
                              onTap: () => context.pushNamed(
                                'orderDetail',
                                pathParameters: {'id': filteredOrders[i].id},
                              ),
                            );
                          },
                          childCount: filteredOrders.length,
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F766E) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F766E) : AppColors.slate200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.slate600,
          ),
        ),
      ),
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView({required this.filterState});
  final int filterState;

  @override
  Widget build(BuildContext context) {
    final title = filterState == 1
        ? "No active orders"
        : filterState == 2
            ? "No completed orders"
            : "No orders found";
    
    final subtitle = filterState == 1
        ? "You don't have any orders currently processing."
        : filterState == 2
            ? "You haven't completed any orders yet."
            : "Your order list is empty.";

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
            Text(
              title,
              style: const TextStyle(
                color: AppColors.slate900,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
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
