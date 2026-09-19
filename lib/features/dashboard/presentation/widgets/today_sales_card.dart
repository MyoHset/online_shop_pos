import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/currency_formatter.dart';
import '../providers/dashboard_provider.dart';

class TodaySalesCard extends ConsumerWidget {
  const TodaySalesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(todaySalesSummaryProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.slate200),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to orders filtered for today
          context.pushNamed('orders'); // query parameters can be added to filter if supported
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: summaryAsync.when(
            data: (summary) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Sales",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  CurrencyFormatter.format(summary.totalRevenue),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${summary.orderCount} Orders Today',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSplit('Online', summary.onlineRevenue),
                    _buildSplit('In-Store', summary.inStoreRevenue),
                  ],
                ),
              ],
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.danger),
                const SizedBox(width: 8),
                const Expanded(child: Text('Failed to load sales', style: TextStyle(color: AppColors.danger))),
                TextButton(
                  onPressed: () => ref.refresh(todaySalesSummaryProvider.future),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSplit(String label, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.slate500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          CurrencyFormatter.format(amount),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.slate700,
          ),
        ),
      ],
    );
  }
}
