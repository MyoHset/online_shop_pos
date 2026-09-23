import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/discount.dart';
import 'discount_edit_sheet.dart';

/// Shared widget representing the discount line item in the cart / checkout summary panel.
///
/// Used identically in both Quick Sale and Online Order flows.
/// Displays current discount status and opens [DiscountEditSheet] on tap.
class DiscountInput extends StatelessWidget {
  const DiscountInput({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.onApply,
    this.onRemove,
    this.readOnly = false,
  });

  final double subtotal;
  final Discount discount;
  final Future<void> Function(Discount discount) onApply;
  final Future<void> Function()? onRemove;
  final bool readOnly;

  void _openEditSheet(BuildContext context) {
    if (readOnly) return;
    DiscountEditSheet.show(
      context: context,
      subtotal: subtotal,
      currentDiscount: discount,
      onApply: onApply,
      onRemove: onRemove,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasDiscount = discount.hasDiscount;
    final discountAmount = discount.calculateAmount(subtotal);

    return InkWell(
      onTap: readOnly ? null : () => _openEditSheet(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Label
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_offer_outlined,
                      size: 15,
                      color: AppColors.slate500,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Discount',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.slate600,
                      ),
                    ),
                    if (hasDiscount && discount.isPercentage) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(${discount.value % 1 == 0 ? discount.value.toInt() : discount.value}%)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ],
                ),

                // Amount Badge + Edit Button
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasDiscount) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${CurrencyFormatter.format(discountAmount)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'None',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.slate400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (!readOnly) ...[
                      const SizedBox(width: 8),
                      Text(
                        hasDiscount ? 'Edit' : 'Add',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate900,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // Optional Reason Subtitle
            if (hasDiscount &&
                discount.reason != null &&
                discount.reason!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 21),
                child: Text(
                  discount.reason!,
                  style: const TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: AppColors.slate400,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
