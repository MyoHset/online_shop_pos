import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/entities/variant.dart';

class ProductTileSelectable extends StatelessWidget {
  const ProductTileSelectable({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    // Determine total available stock across variants
    final availableStock = product.variants
        .where((v) => v.isActive)
        .fold(0, (sum, v) => sum + v.availableStock);
    final isOutOfStock = availableStock <= 0;
    
    // Find price range or base price
    final prices = product.variants
        .where((v) => v.isActive && v.priceOverride != null)
        .map((v) => v.priceOverride!)
        .toList();
    final priceStr = prices.isEmpty
        ? CurrencyFormatter.format(product.basePrice)
        : (prices.length == 1 
            ? CurrencyFormatter.format(prices.first) 
            : '${CurrencyFormatter.format(product.basePrice)} - ${CurrencyFormatter.format(prices.reduce((a, b) => a > b ? a : b))}');

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.slate200),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isOutOfStock ? null : onTap,
        child: Opacity(
          opacity: isOutOfStock ? 0.5 : 1.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image (placeholder for now, you can load from first variant image if any)
              Expanded(
                flex: 3,
                child: Container(
                  color: AppColors.slate100,
                  child: const Center(
                    child: Icon(Icons.image_outlined, color: AppColors.slate300, size: 40),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            priceStr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700, 
                              color: AppColors.slate900,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isOutOfStock ? AppColors.danger.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isOutOfStock ? 'Out' : '$availableStock left',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isOutOfStock ? AppColors.danger : AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
