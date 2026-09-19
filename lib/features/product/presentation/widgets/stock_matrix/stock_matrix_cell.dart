import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';

class StockMatrixCell extends StatelessWidget {
  const StockMatrixCell({
    required this.productId,
    required this.variantId,
    required this.stock,
    super.key,
  });

  final String productId;
  final String variantId;
  final int stock;

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = stock <= 0;
    final bool isLowStock = stock > 0 && stock <= 10;
    
    final Color textColor = isOutOfStock
        ? AppColors.danger
        : isLowStock
            ? AppColors.warning
            : AppColors.success;
            
    final Color bgColor = isOutOfStock
        ? AppColors.dangerBg.withOpacity(0.3)
        : isLowStock
            ? AppColors.warningBg.withOpacity(0.3)
            : AppColors.successBg.withOpacity(0.3);

    return InkWell(
      onTap: () {
        context.pushNamed(
          'variantEdit',
          pathParameters: {
            'id': productId,
            'variantId': variantId,
          },
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        color: bgColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$stock',
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.edit_outlined, size: 14, color: textColor.withOpacity(0.6)),
          ],
        ),
      ),
    );
  }
}
