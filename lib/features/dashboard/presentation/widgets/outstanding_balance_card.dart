import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';
import 'outstanding_balance_row.dart';

class OutstandingBalanceCard extends ConsumerWidget {
  const OutstandingBalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesAsync = ref.watch(outstandingBalancesProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Outstanding Balances',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate800,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pushNamed('orders', queryParameters: {'payment_status': 'unpaid'});
                  },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          balancesAsync.when(
            data: (balances) {
              if (balances.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No outstanding balances.', style: TextStyle(color: AppColors.slate500)),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: balances.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return OutstandingBalanceRow(balance: balances[index]);
                },
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.danger),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Failed to load balances', style: TextStyle(color: AppColors.danger))),
                  TextButton(
                    onPressed: () => ref.refresh(outstandingBalancesProvider.future),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
