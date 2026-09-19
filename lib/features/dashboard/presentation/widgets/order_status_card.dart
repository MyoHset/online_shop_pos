import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';
import 'status_chip.dart';

class OrderStatusCard extends ConsumerWidget {
  const OrderStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusCountsAsync = ref.watch(orderStatusCountsProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.slate200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Status',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.slate800,
              ),
            ),
            const SizedBox(height: 16),
            statusCountsAsync.when(
              data: (counts) {
                if (counts.isEmpty) {
                  return const Text('No active orders.', style: TextStyle(color: AppColors.slate500));
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: counts.map((count) => StatusChip(
                    status: count.status,
                    count: count.count,
                    onTap: () {
                      context.pushNamed('orders', queryParameters: {'status': count.status});
                    },
                  )).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.danger),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Failed to load statuses', style: TextStyle(color: AppColors.danger))),
                  TextButton(
                    onPressed: () => ref.refresh(orderStatusCountsProvider.future),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
