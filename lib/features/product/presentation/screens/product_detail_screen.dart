import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';

import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../domain/entities/product.dart';
import '../providers/product_detail_provider.dart';
import '../widgets/variant_row.dart';

/// Product detail screen — full variant list with stock, price, and images.
/// Responsive: on desktop, opened as a side panel by the list screen; on
/// mobile/tablet it's a full routed page.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return productAsync.when(
      loading: () => const Scaffold(body: AppLoadingWidget()),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.refresh(productDetailProvider(productId).future),
        ),
      ),
      data: (product) => _ProductDetailView(product: product),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit product',
            onPressed: () => context.pushNamed(
              'productEdit',
              pathParameters: {'id': product.id},
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(
          'variantNew',
          pathParameters: {'id': product.id},
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Variant'),
        backgroundColor: AppColors.slate900,
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ProductInfoHeader(product: product),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _VariantsSectionHeader(),
            ),
          ),
          if (product.variants.isEmpty)
            const SliverToBoxAdapter(child: _EmptyVariantsView())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList.separated(
                itemCount: product.variants.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final variant = product.variants[index];
                  return VariantRow(
                    variant: variant,
                    basePrice: product.basePrice,
                    onEdit: () => context.pushNamed(
                      'variantEdit',
                      pathParameters: {
                        'id': product.id,
                        'variantId': variant.id,
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductInfoHeader extends StatelessWidget {
  const _ProductInfoHeader({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate900,
                      ),
                    ),
                    if (product.brand != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        product.brand!,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.slate400),
                      ),
                    ],
                  ],
                ),
              ),
              _StockSummaryChip(product: product),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(
                icon: Icons.sell_outlined,
                label: CurrencyFormatter.format(product.basePrice),
              ),
              const SizedBox(width: 8),
              if (product.category != null)
                _InfoChip(
                  icon: Icons.category_outlined,
                  label: product.category!,
                ),
            ],
          ),
          if (product.description != null && product.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                product.description!,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.slate600),
              ),
            ),
        ],
      ),
    );
  }
}

class _StockSummaryChip extends StatelessWidget {
  const _StockSummaryChip({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final color = product.isOutOfStock
        ? AppColors.danger
        : product.hasLowStockVariant
            ? AppColors.warning
            : AppColors.success;
    final bg = product.isOutOfStock
        ? AppColors.dangerBg
        : product.hasLowStockVariant
            ? AppColors.warningBg
            : AppColors.successBg;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        '${product.totalAvailableStock} in stock',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.slate500),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.slate600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _VariantsSectionHeader extends StatelessWidget {
  const _VariantsSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Variants',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.slate800,
          ),
    );
  }
}

class _EmptyVariantsView extends StatelessWidget {
  const _EmptyVariantsView();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.slate200,
          style: BorderStyle.solid,
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.layers_outlined, size: 40, color: AppColors.slate300),
          SizedBox(height: 12),
          Text(
            'No variants yet',
            style: TextStyle(
              color: AppColors.slate500,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Tap "Add Variant" to create the first variant for this product.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.slate400, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
