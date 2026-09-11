import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/product.dart';

/// Card widget displaying a product in the product list.
///
/// Shows name, category, variant count, total stock, and a stock status badge.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _ProductThumbnail(product: product),
              const SizedBox(width: 16),
              Expanded(
                child: _ProductCardContent(product: product, theme: theme),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.slate400,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductThumbnail extends StatelessWidget {
  const _ProductThumbnail({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryImageUrl = product.variants
        .expand((v) => v.images)
        .where((img) => img.isPrimary)
        .firstOrNull
        ?.imageUrl;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.slate200),
      ),
      clipBehavior: Clip.antiAlias,
      child: primaryImageUrl != null
          ? Image.network(primaryImageUrl, fit: BoxFit.cover)
          : const Icon(Icons.inventory_2_outlined,
              color: AppColors.slate400, size: 24),
    );
  }
}

class _ProductCardContent extends StatelessWidget {
  const _ProductCardContent({
    required this.product,
    required this.theme,
  });

  final Product product;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.slate900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _StockStatusBadge(product: product),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          product.category ?? 'Uncategorised',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.slate500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              CurrencyFormatter.format(product.basePrice),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.slate700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${product.activeVariantCount} variant${product.activeVariantCount == 1 ? '' : 's'}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.slate400),
            ),
            const SizedBox(width: 12),
            Text(
              '${product.totalAvailableStock} in stock',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.slate400),
            ),
          ],
        ),
      ],
    );
  }
}

class _StockStatusBadge extends StatelessWidget {
  const _StockStatusBadge({required this.product});

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
