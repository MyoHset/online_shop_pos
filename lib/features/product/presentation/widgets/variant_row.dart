import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/variant.dart';

/// A single row in the variant list on the product detail screen.
///
/// Displays SKU, size/color, price, available stock, and a stock status
/// indicator. Provides [onEdit] and [onAddImage] callbacks.
class VariantRow extends StatelessWidget {
  const VariantRow({
    super.key,
    required this.variant,
    required this.basePrice,
    required this.onEdit,
    this.onAddImage,
  });

  final Variant variant;
  final double basePrice;
  final VoidCallback onEdit;
  final VoidCallback? onAddImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePrice = variant.priceOverride ?? basePrice;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _VariantStockIndicator(variant: variant),
          const SizedBox(width: 12),
          Expanded(
            child: _VariantDetails(
              variant: variant,
              price: effectivePrice,
              theme: theme,
            ),
          ),
          _VariantActions(onEdit: onEdit, onAddImage: onAddImage),
        ],
      ),
    );
  }

  Color get _borderColor {
    if (variant.isOutOfStock) return AppColors.dangerBg;
    if (variant.isLowStock) return AppColors.warningBg;
    return AppColors.slate200;
  }
}

class _VariantStockIndicator extends StatelessWidget {
  const _VariantStockIndicator({required this.variant});

  final Variant variant;

  @override
  Widget build(BuildContext context) {
    final color = variant.isOutOfStock
        ? AppColors.danger
        : variant.isLowStock
            ? AppColors.warning
            : AppColors.success;

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _VariantDetails extends StatelessWidget {
  const _VariantDetails({
    required this.variant,
    required this.price,
    required this.theme,
  });

  final Variant variant;
  final double price;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          variant.displayName,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.slate800,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              'SKU: ${variant.sku}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.slate400),
            ),
            const SizedBox(width: 12),
            Text(
              CurrencyFormatter.format(price),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.slate600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        _StockLabel(variant: variant, theme: theme),
      ],
    );
  }
}

class _StockLabel extends StatelessWidget {
  const _StockLabel({required this.variant, required this.theme});

  final Variant variant;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final available = variant.availableStock;
    final color = variant.isOutOfStock
        ? AppColors.danger
        : variant.isLowStock
            ? AppColors.warning
            : AppColors.slate500;
    final label = variant.isOutOfStock
        ? 'Out of stock'
        : variant.isLowStock
            ? 'Low: $available left'
            : '$available in stock';

    return Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _VariantActions extends StatelessWidget {
  const _VariantActions({required this.onEdit, this.onAddImage});

  final VoidCallback onEdit;
  final VoidCallback? onAddImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onAddImage != null)
          IconButton(
            icon: const Icon(Icons.photo_camera_outlined,
                size: 20, color: AppColors.slate400),
            tooltip: 'Add image',
            onPressed: onAddImage,
            visualDensity: VisualDensity.compact,
          ),
        IconButton(
          icon: const Icon(Icons.edit_outlined,
              size: 20, color: AppColors.slate400),
          tooltip: 'Edit variant',
          onPressed: onEdit,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
