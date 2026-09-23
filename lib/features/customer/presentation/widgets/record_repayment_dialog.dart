import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_provider.dart';

class RecordRepaymentDialog extends ConsumerStatefulWidget {
  const RecordRepaymentDialog({
    super.key,
    required this.customer,
  });

  final Customer customer;

  static Future<bool?> show(BuildContext context, Customer customer) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RecordRepaymentDialog(customer: customer),
    );
  }

  @override
  ConsumerState<RecordRepaymentDialog> createState() => _RecordRepaymentDialogState();
}

class _RecordRepaymentDialogState extends ConsumerState<RecordRepaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedMethod = 'cash';
  bool _isSaving = false;

  final _paymentMethods = [
    {'key': 'cash', 'label': 'Cash', 'icon': Icons.payments_outlined},
    {'key': 'kbzPay', 'label': 'KBZPay', 'icon': Icons.account_balance_wallet_outlined},
    {'key': 'wavePay', 'label': 'WavePay', 'icon': Icons.phone_android_outlined},
    {'key': 'bankTransfer', 'label': 'Bank Transfer', 'icon': Icons.account_balance_outlined},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _fillFullAmount() {
    _amountController.text = widget.customer.currentDebt.toInt().toString();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      AppSnackBar.showError(context, 'Amount must be greater than 0');
      return;
    }

    setState(() => _isSaving = true);

    final success = await ref.read(customerControllerProvider.notifier).recordRepayment(
          customerId: widget.customer.id,
          amount: amount,
          paymentMethod: _selectedMethod,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      AppSnackBar.showSuccess(
        context,
        'Repayment of ${CurrencyFormatter.format(amount)} recorded successfully',
      );
      Navigator.of(context).pop(true);
    } else {
      AppSnackBar.showError(context, 'Failed to record repayment');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(customerControllerProvider);
    final theme = Theme.of(context);
    final currentDebt = widget.customer.currentDebt;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Record Repayment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate900,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.close, color: AppColors.slate500),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Customer & Debt Info Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.dangerBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, size: 18, color: AppColors.slate700),
                            const SizedBox(width: 8),
                            Text(
                              widget.customer.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              widget.customer.phone,
                              style: const TextStyle(
                                color: AppColors.slate600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Outstanding Debt:',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.danger,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(currentDebt),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.danger,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Payment Amount
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            labelText: 'Repayment Amount *',
                            hintText: '50000',
                            suffixText: 'MMK',
                            prefixIcon: Icon(Icons.money_outlined),
                          ),
                          validator: (v) {
                            final err = Validators.required(v, fieldName: 'Amount');
                            if (err != null) return err;
                            final val = double.tryParse(v!.trim()) ?? 0;
                            if (val <= 0) return 'Must be greater than 0';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: OutlinedButton(
                          onPressed: _fillFullAmount,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          ),
                          child: const Text('Full Amount'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Payment Method Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedMethod,
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
                      prefixIcon: Icon(Icons.payment_outlined),
                    ),
                    items: _paymentMethods.map((m) {
                      return DropdownMenuItem<String>(
                        value: m['key'] as String,
                        child: Row(
                          children: [
                            Icon(m['icon'] as IconData, size: 18, color: AppColors.slate700),
                            const SizedBox(width: 10),
                            Text(m['label'] as String, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedMethod = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      hintText: 'Receipt number or remarks...',
                      prefixIcon: Icon(Icons.notes_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
                        child: const Text('Cancel', style: TextStyle(color: AppColors.slate600)),
                      ),
                      const SizedBox(width: 12),
                      AppButton(
                        label: 'Record Repayment',
                        icon: const Icon(Icons.check_circle_outline),
                        isLoading: _isSaving,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
