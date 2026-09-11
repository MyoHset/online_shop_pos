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

/// Order list screen — minimalist design with Active / Completed tabs.
class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _OrderListTabbedView();
  }
}

class _OrderListTabbedView extends ConsumerWidget {
  const _OrderListTabbedView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderListProvider);
    final theme = Theme.of(context);
    final isDesktop = DeviceType.from(context) == DeviceType.desktop ||
        DeviceType.from(context) == DeviceType.large;
    final crossAxisCount =
        isDesktop ? 3 : (DeviceType.from(context) == DeviceType.tablet ? 2 : 1);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.slate50,
        appBar: AppBar(
          title: Text(
            'My Orders',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.slate900,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {}, // Future: implement search
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'New order',
              onPressed: () => context.pushNamed('orderNew'),
            ),
            const SizedBox(width: 8),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 2, color: AppColors.slate900),
            ),
          ),
        ),
        body: ordersAsync.when(
          loading: () => const SkeletonListLoader(),
          error: (e, _) => AppErrorWidget(
            message: e.toString(),
            onRetry: () => ref.refresh(orderListProvider.future),
          ),
          data: (orders) {
            final activeOrders =
                orders.where((o) => o.status.isActive).toList();
            final completedOrders =
                orders.where((o) => o.status.isFinal).toList();

            return TabBarView(
              children: [
                _OrderListBody(
                  orders: activeOrders,
                  isActiveTab: true,
                  crossAxisCount: crossAxisCount,
                ),
                _OrderListBody(
                  orders: completedOrders,
                  isActiveTab: false,
                  crossAxisCount: crossAxisCount,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrderListBody extends StatelessWidget {
  const _OrderListBody({
    required this.orders,
    required this.isActiveTab,
    required this.crossAxisCount,
  });

  final List<Order> orders;
  final bool isActiveTab;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return _EmptyOrdersView(isActiveTab: isActiveTab);
    }

    if (crossAxisCount == 1) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
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
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
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
  }
}

class _EmptyOrdersView extends StatelessWidget {
  const _EmptyOrdersView({required this.isActiveTab});
  final bool isActiveTab;

  @override
  Widget build(BuildContext context) {
    final title =
        isActiveTab ? "You don't have an order yet" : "No completed orders";
    final subtitle = isActiveTab
        ? "You don't have any active orders at this time."
        : "You haven't completed any orders yet.";

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Clipboard illustration placeholder
            Icon(
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
