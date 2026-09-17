import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/quick_sale_provider.dart';

class CartSummaryPanel extends ConsumerStatefulWidget {
  const CartSummaryPanel({super.key});

  @override
  ConsumerState<CartSummaryPanel> createState() => _CartSummaryPanelState();
}

class _CartSummaryPanelState extends ConsumerState<CartSummaryPanel> {
  bool _showCustomerField = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickSaleProvider);
    final notifier = ref.read(quickSaleProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 13),
                ),
              ),
            ),

          // Optional Customer Name Toggle
          if (!_showCustomerField)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _showCustomerField = true),
                icon: const Icon(
                  Icons.person_add_alt_1,
                  size: 18,
                ),
                label: const Text('Add customer name'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.slate900,
                  padding: EdgeInsets.zero,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Customer Name (Optional)',
                  isDense: true,
                  filled: true,
                  fillColor: AppColors.slate50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      notifier.updateCustomerName('');
                      setState(() => _showCustomerField = false);
                    },
                  ),
                ),
                onChanged: notifier.updateCustomerName,
              ),
            ),

          // Payment Method Selector
          const Text('Payment Method',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.slate500)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _PaymentMethodChip('cod', 'Cash / COD'),
                const SizedBox(width: 8),
                _PaymentMethodChip('kbzPay', 'KBZPay'),
                const SizedBox(width: 8),
                _PaymentMethodChip('wavePay', 'WavePay'),
                const SizedBox(width: 8),
                _PaymentMethodChip('bankTransfer', 'Bank Transfer'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.slate200, height: 1),
          const SizedBox(height: 16),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate500)),
              Text(
                CurrencyFormatter.format(state.cart.total),
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.slate900),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Submit
          AppButton(
            label: 'Complete Sale',
            isLoading: state.isLoading,
            backgroundColor: AppColors.greenNude,
            textColor: AppColors.slate900,
            onPressed: state.cart.isEmpty ? null : notifier.submitSale,
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodChip extends ConsumerWidget {
  const _PaymentMethodChip(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickSaleProvider);
    final notifier = ref.read(quickSaleProvider.notifier);
    final isSelected = state.paymentMethod == value;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) notifier.updatePaymentMethod(value);
      },
      selectedColor: AppColors.greenNude.withValues(alpha: 0.3),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.slate900 : AppColors.slate600,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: isSelected ? Colors.transparent : AppColors.slate200,
      ),
    );
  }
}
