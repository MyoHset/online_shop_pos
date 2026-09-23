import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/discount.dart';

/// Modal bottom sheet (on mobile) or dialog (on tablet/desktop) allowing staff
/// to set, edit, or remove an order-level discount.
///
/// Features:
/// - Uses BottomSheet only on mobile, centered Dialog on tablet & desktop
/// - Fixed (ks) vs Percentage (%) toggle
/// - Live instant calculation preview of discount amount and resulting total
/// - Client-side validation: percentage capped 0-100, fixed capped at subtotal
/// - Optional discount reason with common quick chips
/// - Surface clear messages on server limit errors
class DiscountEditSheet extends StatefulWidget {
  const DiscountEditSheet({
    super.key,
    required this.subtotal,
    required this.currentDiscount,
    required this.onApply,
    this.onRemove,
    this.isDialog = false,
  });

  final double subtotal;
  final Discount currentDiscount;
  final Future<void> Function(Discount discount) onApply;
  final Future<void> Function()? onRemove;
  final bool isDialog;

  /// Convenience static helper to show the sheet (mobile) or dialog (tablet/desktop).
  static Future<void> show({
    required BuildContext context,
    required double subtotal,
    required Discount currentDiscount,
    required Future<void> Function(Discount discount) onApply,
    Future<void> Function()? onRemove,
  }) {
    if (context.isMobile) {
      return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => DiscountEditSheet(
          subtotal: subtotal,
          currentDiscount: currentDiscount,
          onApply: onApply,
          onRemove: onRemove,
          isDialog: false,
        ),
      );
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: DiscountEditSheet(
            subtotal: subtotal,
            currentDiscount: currentDiscount,
            onApply: onApply,
            onRemove: onRemove,
            isDialog: true,
          ),
        ),
      ),
    );
  }

  @override
  State<DiscountEditSheet> createState() => _DiscountEditSheetState();
}

class _DiscountEditSheetState extends State<DiscountEditSheet> {
  late DiscountType _selectedType;
  late final TextEditingController _valueController;
  late final TextEditingController _reasonController;

  bool _isSubmitting = false;
  String? _errorMessage;

  static const List<String> _reasonSuggestions = [
    'Regular customer',
    'Bulk purchase',
    'Minor defect adjustment',
    'Promotion',
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.currentDiscount.hasDiscount
        ? widget.currentDiscount.type
        : DiscountType.fixed;

    final initialVal = widget.currentDiscount.hasDiscount
        ? (widget.currentDiscount.value % 1 == 0
            ? widget.currentDiscount.value.toInt().toString()
            : widget.currentDiscount.value.toString())
        : '';
    _valueController = TextEditingController(text: initialVal);
    _reasonController =
        TextEditingController(text: widget.currentDiscount.reason ?? '');

    _valueController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _valueController.removeListener(_onInputChanged);
    _valueController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    setState(() {
      _errorMessage = null;
    });
  }

  double get _enteredValue =>
      double.tryParse(_valueController.text.trim()) ?? 0.0;

  Discount get _previewDiscount => Discount(
        type: _selectedType,
        value: _enteredValue,
        reason: _reasonController.text.trim().isEmpty
            ? null
            : _reasonController.text.trim(),
      );

  double get _calculatedDiscountAmount =>
      _previewDiscount.calculateAmount(widget.subtotal);

  double get _previewTotal =>
      (widget.subtotal - _calculatedDiscountAmount).clamp(0.0, double.infinity);

  bool get _isCappedAtSubtotal =>
      _selectedType == DiscountType.fixed &&
      _enteredValue > widget.subtotal &&
      widget.subtotal > 0;

  bool get _canApply => _enteredValue > 0 && !_isSubmitting;

  Future<void> _handleApply() async {
    if (!_canApply) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await widget.onApply(_previewDiscount);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  Future<void> _handleRemove() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      if (widget.onRemove != null) {
        await widget.onRemove!();
      } else {
        await widget.onApply(const Discount.none());
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: widget.isDialog
            ? BorderRadius.circular(16)
            : const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: widget.isDialog
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        widget.isDialog ? 24 : 16,
        24,
        widget.isDialog ? 24 : (24 + bottomInset),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle (mobile bottom sheet only)
            if (!widget.isDialog)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.slate300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Discount',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.slate500),
                  onPressed: () => Navigator.of(context).pop(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Error Banner
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.danger,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Discount Type Toggle
            Row(
              children: [
                Expanded(
                  child: _TypeSelectionButton(
                    label: 'Fixed Amount (ks)',
                    icon: Icons.payments_outlined,
                    isSelected: _selectedType == DiscountType.fixed,
                    onTap: () {
                      if (_selectedType != DiscountType.fixed) {
                        setState(() {
                          _selectedType = DiscountType.fixed;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TypeSelectionButton(
                    label: 'Percentage (%)',
                    icon: Icons.percent,
                    isSelected: _selectedType == DiscountType.percentage,
                    onTap: () {
                      if (_selectedType != DiscountType.percentage) {
                        setState(() {
                          _selectedType = DiscountType.percentage;
                          // If current value > 100, clamp to 100
                          if (_enteredValue > 100) {
                            _valueController.text = '100';
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Value Input Field
            TextField(
              controller: _valueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                if (_selectedType == DiscountType.percentage)
                  _PercentageRangeInputFormatter(),
              ],
              decoration: InputDecoration(
                labelText: _selectedType == DiscountType.fixed
                    ? 'Discount Amount (ks)'
                    : 'Discount Percentage (0-100%)',
                prefixText: _selectedType == DiscountType.fixed ? 'ks ' : '% ',
                prefixStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate700,
                ),
                hintText: _selectedType == DiscountType.fixed ? '1000' : '10',
                filled: true,
                fillColor: AppColors.slate50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.slate300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.slate200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.greenNude,
                    width: 2,
                  ),
                ),
              ),
            ),

            // Live preview & inline capped note
            if (_enteredValue > 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _isCappedAtSubtotal
                      ? AppColors.warning.withValues(alpha: 0.1)
                      : AppColors.success.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isCappedAtSubtotal
                              ? Icons.info_outline
                              : Icons.check_circle_outline,
                          size: 16,
                          color: _isCappedAtSubtotal
                              ? AppColors.warning
                              : AppColors.success,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isCappedAtSubtotal
                              ? 'Discount capped at subtotal'
                              : '= ${CurrencyFormatter.format(_calculatedDiscountAmount)} off',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _isCappedAtSubtotal
                                ? AppColors.warning
                                : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'New Total: ${CurrencyFormatter.format(_previewTotal)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Reason Input Field
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: 'Discount Reason (Optional)',
                hintText: 'e.g. Regular customer, bulk deal...',
                filled: true,
                fillColor: AppColors.slate50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.slate300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.slate200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.greenNude,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Reason Suggestions Chips
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _reasonSuggestions.map((reason) {
                return ActionChip(
                  label: Text(
                    reason,
                    style: const TextStyle(fontSize: 11, color: AppColors.slate700),
                  ),
                  backgroundColor: AppColors.slate100,
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  onPressed: () {
                    setState(() {
                      _reasonController.text = reason;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                if (widget.currentDiscount.hasDiscount) ...[
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.danger),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isSubmitting ? null : _handleRemove,
                      child: const Text(
                        'Remove',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  flex: 2,
                  child: AppButton(
                    label: 'Apply Discount',
                    isLoading: _isSubmitting,
                    backgroundColor: AppColors.greenNude,
                    textColor: AppColors.slate900,
                    onPressed: _canApply ? _handleApply : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeSelectionButton extends StatelessWidget {
  const _TypeSelectionButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.greenNude.withValues(alpha: 0.25)
              : AppColors.slate50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.slate900 : AppColors.slate200,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.slate900 : AppColors.slate600,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.slate900 : AppColors.slate700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Clamps numerical text entry to 0-100 for percentages.
class _PercentageRangeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final parsed = double.tryParse(newValue.text);
    if (parsed == null) return oldValue;
    if (parsed > 100) {
      return const TextEditingValue(
        text: '100',
        selection: TextSelection.collapsed(offset: 3),
      );
    }
    return newValue;
  }
}
