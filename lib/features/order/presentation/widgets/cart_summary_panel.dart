import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/presentation/providers/customer_provider.dart';
import '../../../customer/presentation/widgets/customer_form_dialog.dart';
import '../providers/quick_sale_provider.dart';
import 'discount_input.dart';

class CartSummaryPanel extends ConsumerStatefulWidget {
  const CartSummaryPanel({super.key});

  @override
  ConsumerState<CartSummaryPanel> createState() => _CartSummaryPanelState();
}

class _CartSummaryPanelState extends ConsumerState<CartSummaryPanel> {
  bool _showCustomerField = false;
  late final TextEditingController _customerController;

  @override
  void initState() {
    super.initState();
    _customerController = TextEditingController(
      text: ref.read(quickSaleProvider).customerName,
    );
  }

  @override
  void dispose() {
    _customerController.dispose();
    super.dispose();
  }

  Future<void> _addNewCustomer() async {
    final newCustomer = await CustomerFormDialog.show(context);
    if (newCustomer != null && mounted) {
      _customerController.text = newCustomer.name;
      ref.read(quickSaleProvider.notifier).updateCustomer(
        name: newCustomer.name,
        id: newCustomer.id,
      );
      setState(() => _showCustomerField = true);
    }
  }

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

          // Customer / Credit Section
          () {
            final isCredit = state.paymentMethod == 'credit';
            final showCustomer =
                isCredit || _showCustomerField || state.customerName.isNotEmpty;

            if (!showCustomer) {
              return Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _showCustomerField = true),
                  icon: const Icon(
                    Icons.person_add_alt_1,
                    size: 18,
                  ),
                  label: const Text('Add customer name (Optional)'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.slate900,
                    padding: EdgeInsets.zero,
                  ),
                ),
              );
            }

            return Consumer(
              builder: (context, ref, _) {
                final customers = ref.watch(customerListProvider).value ?? [];
                final nameLower = state.customerName.trim().toLowerCase();
                final matched = nameLower.isNotEmpty
                    ? customers
                        .where((c) =>
                            c.name.toLowerCase() == nameLower ||
                            c.phone == nameLower)
                        .firstOrNull
                    : null;
                final suggestions = nameLower.isNotEmpty && matched == null
                    ? customers
                        .where((c) =>
                            c.name.toLowerCase().contains(nameLower) ||
                            c.phone.contains(nameLower))
                        .take(3)
                        .toList()
                    : <Customer>[];

                if (_customerController.text != state.customerName &&
                    !FocusScope.of(context).hasFocus) {
                  _customerController.text = state.customerName;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          Text(
                            isCredit ? 'Customer *' : 'Customer (Optional)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isCredit &&
                                      state.customerName.trim().isEmpty
                                  ? AppColors.danger
                                  : AppColors.slate700,
                            ),
                          ),
                          if (isCredit) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.danger.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Required for Credit',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.danger,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _addNewCustomer,
                            icon: const Icon(Icons.add, size: 14),
                            label: const Text('New Customer'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.greenNude,
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _customerController,
                        decoration: InputDecoration(
                          hintText: isCredit
                              ? 'Search or enter customer name (Required) *'
                              : 'Customer Name / Phone (Optional)',
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.slate50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isCredit &&
                                      state.customerName.trim().isEmpty
                                  ? AppColors.danger
                                  : AppColors.slate200,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isCredit &&
                                      state.customerName.trim().isEmpty
                                  ? AppColors.danger.withValues(alpha: 0.6)
                                  : AppColors.slate200,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              _customerController.clear();
                              notifier.updateCustomer(name: '', id: null);
                              if (!isCredit) {
                                setState(() => _showCustomerField = false);
                              }
                            },
                          ),
                        ),
                        onChanged: (val) {
                          final valLower = val.trim().toLowerCase();
                          final m = customers
                              .where((c) =>
                                  c.name.toLowerCase() == valLower ||
                                  c.phone == valLower)
                              .firstOrNull;
                          notifier.updateCustomer(name: val, id: m?.id);
                        },
                      ),
                      if (isCredit && state.customerName.trim().isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 4, left: 2),
                          child: Text(
                            'Customer is required for credit payment.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.danger,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (matched != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: matched.isLimitReached
                                  ? AppColors.danger.withValues(alpha: 0.12)
                                  : AppColors.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  matched.isLimitReached
                                      ? Icons.warning_amber_rounded
                                      : Icons.account_balance_wallet_outlined,
                                  size: 13,
                                  color: matched.isLimitReached
                                      ? AppColors.danger
                                      : AppColors.success,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  matched.hasDebt
                                      ? 'Debt: ${CurrencyFormatter.format(matched.currentDebt)}'
                                      : 'No Debt',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: matched.isLimitReached
                                        ? AppColors.danger
                                        : AppColors.success,
                                  ),
                                ),
                                if (matched.creditLimit > 0) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    '| Limit: ${CurrencyFormatter.format(matched.creditLimit)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.slate600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      if (suggestions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Wrap(
                            spacing: 6,
                            children: suggestions.map((c) {
                              return ActionChip(
                                padding: EdgeInsets.zero,
                                labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 6),
                                label: Text('${c.name} (${c.phone})',
                                    style: const TextStyle(fontSize: 11)),
                                onPressed: () {
                                  _customerController.text = c.name;
                                  notifier.updateCustomer(
                                    name: c.name,
                                    id: c.id,
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          }(),

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
                const _PaymentMethodChip('cod', 'Cash / COD'),
                const SizedBox(width: 8),
                _PaymentMethodChip('credit', 'Credit (အကြွေး)', onSelected: () {
                  setState(() => _showCustomerField = true);
                }),
                const SizedBox(width: 8),
                const _PaymentMethodChip('kbz_pay', 'KBZPay'),
                const SizedBox(width: 8),
                const _PaymentMethodChip('wave_pay', 'WavePay'),
                const SizedBox(width: 8),
                const _PaymentMethodChip('bank_transfer', 'Bank Transfer'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.slate200, height: 1),
          const SizedBox(height: 14),

          // Pricing Breakdown
          if (state.discount.hasDiscount) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate600,
                  ),
                ),
                Text(
                  CurrencyFormatter.format(state.cart.total),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          DiscountInput(
            subtotal: state.cart.total,
            discount: state.discount,
            onApply: (d) async => notifier.updateDiscount(d),
            onRemove: () async => notifier.removeDiscount(),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.slate200, height: 1),
          const SizedBox(height: 14),

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
                CurrencyFormatter.format(state.totalAmount),
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
  const _PaymentMethodChip(this.value, this.label, {this.onSelected});

  final String value;
  final String label;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickSaleProvider);
    final notifier = ref.read(quickSaleProvider.notifier);
    final isSelected = state.paymentMethod == value;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          notifier.updatePaymentMethod(value);
          onSelected?.call();
        }
      },
      selectedColor: AppColors.greenNude,
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
