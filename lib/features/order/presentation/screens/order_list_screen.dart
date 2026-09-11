import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../domain/entities/order.dart';
import '../providers/order_list_provider.dart';
import '../widgets/order_card.dart';
import '../widgets/order_status_badge.dart';

/// Order list screen — delegates to the correct layout based on DeviceType.
class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return switch (DeviceType.from(context)) {
      DeviceType.mobile => const _OrderListMobileView(),
      DeviceType.tablet => const _OrderListTabletView(),
      DeviceType.desktop || DeviceType.large => const _OrderListDesktopView(),
    };
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────

class _OrderListMobileView extends ConsumerWidget {
  const _OrderListMobileView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderListProvider);
    final notifier = ref.read(orderListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New order',
            onPressed: () => context.pushNamed('orderNew'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _StatusFilterChips(
            currentFilter: notifier.currentFilter,
            onFilter: (s) => notifier.filterByStatus(s),
          ),
        ),
      ),
      body: _OrderListBody(
        ordersAsync: ordersAsync,
        onRetry: () => ref.refresh(orderListProvider.future),
      ),
    );
  }
}

// ── Tablet layout ─────────────────────────────────────────────────────────────

class _OrderListTabletView extends ConsumerWidget {
  const _OrderListTabletView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderListProvider);
    final notifier = ref.read(orderListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          FilledButton.icon(
            onPressed: () => context.pushNamed('orderNew'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Order'),
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.slate900),
          ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _StatusFilterChips(
            currentFilter: notifier.currentFilter,
            onFilter: (s) => notifier.filterByStatus(s),
          ),
        ),
      ),
      body: _OrderListBody(
        ordersAsync: ordersAsync,
        onRetry: () => ref.refresh(orderListProvider.future),
        crossAxisCount: 2,
      ),
    );
  }
}

// ── Desktop layout ────────────────────────────────────────────────────────────

class _OrderListDesktopView extends ConsumerWidget {
  const _OrderListDesktopView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderListProvider);
    final notifier = ref.read(orderListProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Text(
                  'Orders',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 24),
                _StatusFilterChips(
                  currentFilter: notifier.currentFilter,
                  onFilter: (s) => notifier.filterByStatus(s),
                  compact: true,
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => context.pushNamed('orderNew'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New Order'),
                  style: FilledButton.styleFrom(
                      backgroundColor: AppColors.slate900),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _OrderListBody(
              ordersAsync: ordersAsync,
              onRetry: () => ref.refresh(orderListProvider.future),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared sub-widgets ─────────────────────────────────────────────────────────

class _StatusFilterChips extends StatelessWidget {
  const _StatusFilterChips({
    required this.currentFilter,
    required this.onFilter,
    this.compact = false,
  });

  final OrderStatus? currentFilter;
  final void Function(OrderStatus?) onFilter;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final statuses = [null, ...OrderStatus.values];

    Widget chips = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: statuses.map((s) {
          final label = s?.displayLabel ?? 'All';
          final isSelected = currentFilter == s;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => onFilter(s),
              selectedColor: AppColors.slate900,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.slate600,
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color:
                    isSelected ? AppColors.slate900 : AppColors.slate200,
              ),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          );
        }).toList(),
      ),
    );

    return chips;
  }
}

class _OrderListBody extends StatelessWidget {
  const _OrderListBody({
    required this.ordersAsync,
    required this.onRetry,
    this.crossAxisCount = 1,
  });

  final AsyncValue<List<Order>> ordersAsync;
  final VoidCallback onRetry;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return ordersAsync.when(
      loading: () => const SkeletonListLoader(),
      error: (e, _) => AppErrorWidget(message: e.toString(), onRetry: onRetry),
      data: (orders) {
        if (orders.isEmpty) return const _EmptyOrdersView();
        if (crossAxisCount == 1) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => OrderCard(
              order: orders[i],
              onTap: () => context.pushNamed(
                'orderDetail',
                pathParameters: {'id': orders[i].id},
              ),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: orders.length,
          itemBuilder: (context, i) => OrderCard(
            order: orders[i],
            onTap: () => context.pushNamed(
              'orderDetail',
              pathParameters: {'id': orders[i].id},
            ),
          ),
        );
      },
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long_outlined,
              size: 64, color: AppColors.slate300),
          const SizedBox(height: 16),
          Text(
            'No orders yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.slate500,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first order to get started.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.slate400),
          ),
        ],
      ),
    );
  }
}
