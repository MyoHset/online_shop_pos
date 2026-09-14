import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/product.dart';

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    if (product.isOutOfStock) {
      return const StatusBadge.danger(
        label: 'Out of stock',
        size: StatusBadgeSize.small,
      );
    }
    if (product.hasLowStockVariant) {
      return const StatusBadge.warning(
        label: 'Low stock',
        size: StatusBadgeSize.small,
      );
    }
    return const SizedBox.shrink();
  }
}

/// Classic minimal product card — for grid layouts.
/// Consistent with data presentation.
class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.slate50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? AppColors.slate300 : AppColors.slate200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Product Name
              Text(
                p.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (p.category != null) ...[
                const SizedBox(height: 2),
                Text(
                  p.category!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.slate500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // const Spacer(),

              // Price & Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    CurrencyFormatter.format(p.basePrice),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate900,
                    ),
                  ),
                  _StockBadge(product: p),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${p.activeVariantCount} var · ${p.totalAvailableStock} stock',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.slate400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
