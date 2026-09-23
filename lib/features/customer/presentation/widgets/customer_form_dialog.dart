import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_provider.dart';

class CustomerFormDialog extends ConsumerStatefulWidget {
  const CustomerFormDialog({
    super.key,
    this.customer,
    this.initialName,
    this.initialPhone,
  });

  /// Existing customer to edit, or null to create new
  final Customer? customer;

  /// Optional prefill values (e.g. from POS checkout search)
  final String? initialName;
  final String? initialPhone;

  static Future<Customer?> show(
    BuildContext context, {
    Customer? customer,
    String? initialName,
    String? initialPhone,
  }) {
    return showDialog<Customer>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomerFormDialog(
        customer: customer,
        initialName: initialName,
        initialPhone: initialPhone,
      ),
    );
  }

  @override
  ConsumerState<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends ConsumerState<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _creditLimitController;
  late final TextEditingController _initialDebtController;
  late final TextEditingController _notesController;

  late RepaymentCycle _selectedCycle;
  bool _isSaving = false;

  bool get isEdit => widget.customer != null;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _nameController = TextEditingController(text: c?.name ?? widget.initialName ?? '');
    _phoneController = TextEditingController(text: c?.phone ?? widget.initialPhone ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _creditLimitController = TextEditingController(
      text: c != null ? (c.creditLimit > 0 ? c.creditLimit.toInt().toString() : '') : '',
    );
    _initialDebtController = TextEditingController(text: '');
    _notesController = TextEditingController(text: c?.notes ?? '');
    _selectedCycle = c?.repaymentCycle ?? RepaymentCycle.monthly;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _creditLimitController.dispose();
    _initialDebtController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final creditLimit = double.tryParse(_creditLimitController.text.trim()) ?? 0.0;
    final initialDebt = double.tryParse(_initialDebtController.text.trim()) ?? 0.0;

    final controller = ref.read(customerControllerProvider.notifier);

    Customer? result;
    if (isEdit) {
      result = await controller.updateCustomer(
        id: widget.customer!.id,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        creditLimit: creditLimit,
        repaymentCycle: _selectedCycle,
        notes: _notesController.text.trim(),
      );
    } else {
      result = await controller.createCustomer(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        creditLimit: creditLimit,
        initialDebt: initialDebt,
        repaymentCycle: _selectedCycle,
        notes: _notesController.text.trim(),
      );
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (result != null) {
      AppSnackBar.showSuccess(
        context,
        isEdit ? 'Customer updated successfully' : 'Customer added successfully',
      );
      Navigator.of(context).pop(result);
    } else {
      AppSnackBar.showError(
        context,
        isEdit ? 'Failed to update customer' : 'Failed to add customer',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(customerControllerProvider);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
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
                      Text(
                        isEdit ? 'Edit Customer' : 'Add New Customer',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate900,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: AppColors.slate500),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name *',
                      hintText: 'John Doe',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => Validators.required(v, fieldName: 'Name'),
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number *',
                      hintText: '09xxxxxxxxx',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: Validators.phoneNumber,
                  ),
                  const SizedBox(height: 16),

                  // Address
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      hintText: 'No. 12, 50th Street, Yangon',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Credit Limit & Repayment Cycle Row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _creditLimitController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            labelText: 'Credit Limit',
                            hintText: '500000',
                            suffixText: 'MMK',
                            prefixIcon: Icon(Icons.credit_card_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<RepaymentCycle>(
                          initialValue: _selectedCycle,
                          decoration: const InputDecoration(
                            labelText: 'Payment Cycle',
                            prefixIcon: Icon(Icons.schedule_outlined),
                          ),
                          items: RepaymentCycle.values.map((cycle) {
                            return DropdownMenuItem(
                              value: cycle,
                              child: Text(
                                cycle.displayLabel,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCycle = val);
                          },
                        ),
                      ),
                    ],
                  ),

                  // Initial Opening Debt (only on create)
                  if (!isEdit) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _initialDebtController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Opening Debt (if any)',
                        hintText: '0',
                        suffixText: 'MMK',
                        prefixIcon: Icon(Icons.receipt_outlined),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                  // Notes
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Wholesale buyer, etc...',
                      prefixIcon: Icon(Icons.note_alt_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                        child: const Text('Cancel', style: TextStyle(color: AppColors.slate600)),
                      ),
                      const SizedBox(width: 12),
                      AppButton(
                        label: isEdit ? 'Save Changes' : 'Add Customer',
                        icon: const Icon(Icons.check),
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
