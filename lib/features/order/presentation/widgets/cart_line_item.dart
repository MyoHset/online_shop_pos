import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/cart_item.dart';

class CartLineItem extends StatelessWidget {
  const CartLineItem({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.hasSufficientStock ? Colors.white : AppColors.danger.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(color: AppColors.slate100),
          left: !item.hasSufficientStock 
              ? const BorderSide(color: AppColors.danger, width: 3)
              : BorderSide.none,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  item.variantDisplayName,
                  style: const TextStyle(color: AppColors.slate500, fontSize: 12),
                ),
                if (!item.hasSufficientStock)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Only ${item.availableStock} in stock',
                      style: const TextStyle(color: AppColors.danger, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(item.subtotal),
                  style:  const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.slate900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.slate200),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  visualDensity: VisualDensity.compact,
                  onPressed: onDecrement,
                  splashRadius: 16,
                ),
                SizedBox(
                  width: 24,
                  child: Text(
                    '${item.quantity}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  visualDensity: VisualDensity.compact,
                  onPressed: item.quantity < item.availableStock ? onIncrement : null,
                  splashRadius: 16,
                  color: item.quantity < item.availableStock ? null : AppColors.slate300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
