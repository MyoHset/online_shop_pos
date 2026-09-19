import 'package:flutter/material.dart';
import 'today_sales_card.dart';
import 'order_status_card.dart';
import 'outstanding_balance_card.dart';

class OwnerDashboardView extends StatelessWidget {
  const OwnerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return const _DesktopLayout();
        } else if (constraints.maxWidth >= 600) {
          return const _TabletLayout();
        } else {
          return const _MobileLayout();
        }
      },
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        TodaySalesCard(),
        SizedBox(height: 16),
        OrderStatusCard(),
        SizedBox(height: 16),
        OutstandingBalanceCard(),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: TodaySalesCard()),
            SizedBox(width: 16),
            Expanded(child: OrderStatusCard()),
          ],
        ),
        const SizedBox(height: 16),
        const OutstandingBalanceCard(),
      ],
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: TodaySalesCard()),
            SizedBox(width: 24),
            Expanded(child: OrderStatusCard()),
            SizedBox(width: 24),
            Expanded(child: OutstandingBalanceCard()),
          ],
        ),
      ],
    );
  }
}
