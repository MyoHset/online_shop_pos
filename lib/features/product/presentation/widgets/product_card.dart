import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/product.dart';

/// Classic minimal product row — no card box, just a clean list tile
/// with a bottom divider. Consistent height regardless of content.
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
          duration: const Duration(milliseconds: 120),
          color: _hovered ? AppColors.slate50 : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // Thumbnail — small, square
              _Thumbnail(product: p),
              const SizedBox(width: 14),

              // Name + category
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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
                          fontSize: 11,
                          color: AppColors.slate400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Price
              Expanded(
                flex: 3,
                child: Text(
                  CurrencyFormatter.format(p.basePrice),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate700,
                  ),
                ),
              ),

              // Variants + stock
              Expanded(
                flex: 3,
                child: Text(
                  '${p.activeVariantCount} var · ${p.totalAvailableStock} stock',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.slate400,
                  ),
                ),
              ),

              // Status badge
              _StockBadge(product: p),
              const SizedBox(width: 8),

              // Chevron
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.slate300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final url = product.variants
        .expand((v) => v.images)
        .where((img) => img.isPrimary)
        .firstOrNull
        ?.imageUrl;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.antiAlias,
      child: url != null
          ? Image.network(url, fit: BoxFit.cover)
          : const Icon(Icons.inventory_2_outlined,
              color: AppColors.slate300, size: 18),
    );
  }
}

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
