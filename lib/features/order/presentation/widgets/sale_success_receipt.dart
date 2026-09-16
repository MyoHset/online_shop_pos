import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/quick_sale_provider.dart';

class SaleSuccessReceipt extends ConsumerWidget {
  const SaleSuccessReceipt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickSaleProvider);
    final order = state.completedOrder;

    if (order == null) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 80),
          const SizedBox(height: 24),
          const Text(
            'Sale Completed Successfully!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.slate900),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.slate200),
            ),
            child: Column(
              children: [
                _ReceiptRow('Order ID', order.id.split('-').first.toUpperCase()),
                const SizedBox(height: 12),
                _ReceiptRow('Customer', order.customerName),
                const SizedBox(height: 12),
                _ReceiptRow('Payment', state.paymentMethod.toUpperCase()),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: AppColors.slate200),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Paid', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.slate600)),
                    Text(
                      CurrencyFormatter.format(order.totalAmount),
                      style:  TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.slate900),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          AppButton(
            label: 'Start New Sale',
            onPressed: () {
              ref.read(quickSaleProvider.notifier).resetSale();
            },
            minimumWidth: 200,
          ),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.slate500, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(color: AppColors.slate900, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
