import '../../../../core/widgets/permission_gate.dart';
import '../../../auth/domain/entities/staff_role.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../widgets/variant_image_gallery.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../domain/entities/product.dart';
import '../providers/product_detail_provider.dart';
import '../widgets/product_image_placeholder.dart';
import '../providers/stock_matrix_provider.dart';
import '../widgets/variant_row.dart';
import '../widgets/stock_matrix/stock_matrix_table.dart';

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


class _ProductDetailView extends ConsumerWidget {
  const _ProductDetailView({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(currentStaffRoleProvider);
    final canManageProducts = roleAsync.value?.canManageProducts == true;

    return DefaultTabController(
      length: canManageProducts ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          actions: [
            PermissionGate(
              permission: (role) => role.canManageProducts,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AppButton(
                  label: 'Edit',
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.pushNamed(
                    'productEdit',
                    pathParameters: {'id': product.id},
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          bottom: canManageProducts
              ? const TabBar(
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Stock Matrix'),
                  ],
                )
              : null,
        ),
        body: TabBarView(
          children: [
            _ProductOverviewTab(product: product),
            if (canManageProducts)
              _StockMatrixTab(productId: product.id),
          ],
        ),
      ),
    );
  }
}

class _VariantGallerySection extends StatefulWidget {
  const _VariantGallerySection({required this.product});
  final Product product;

  @override
  State<_VariantGallerySection> createState() => _VariantGallerySectionState();
}

class _VariantGallerySectionState extends State<_VariantGallerySection> {
  String? _selectedSize;
  String? _selectedColor;

  @override
  void initState() {
    super.initState();
    _initializeDefaultSelection();
  }

  @override
  void didUpdateWidget(_VariantGallerySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      _initializeDefaultSelection();
    }
  }

  void _initializeDefaultSelection() {
    final variants = widget.product.variants.where((v) => v.isActive).toList();
    if (variants.isEmpty) return;
    
    variants.sort((a, b) => b.availableStock.compareTo(a.availableStock));
    final defaultVariant = variants.first;
    _selectedSize = defaultVariant.size;
    _selectedColor = defaultVariant.color;
  }

  @override
  Widget build(BuildContext context) {
    final activeVariants = widget.product.variants.where((v) => v.isActive).toList();
    if (activeVariants.isEmpty) return const SizedBox.shrink();

    // Find all distinct sizes and colors
    final sizes = activeVariants.map((v) => v.size).where((s) => s != null && s.isNotEmpty).toSet().toList().cast<String>();
    final colors = activeVariants.map((v) => v.color).where((c) => c != null && c.isNotEmpty).toSet().toList().cast<String>();
    sizes.sort();
    colors.sort();

    // Resolve matching variant
    final matchedVariant = activeVariants.where((v) => 
      (sizes.isEmpty || v.size == _selectedSize) && 
      (colors.isEmpty || v.color == _selectedColor)
    ).firstOrNull;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (matchedVariant != null)
            VariantImageGallery(variantId: matchedVariant.id)
          else
            const AspectRatio(
              aspectRatio: 1,
              child: ProductImagePlaceholder(),
            ),
            
          const SizedBox(height: 24),
          
          if (sizes.isNotEmpty) ...[
            const Text('Size', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.slate700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sizes.map((s) {
                final isSelected = _selectedSize == s;
                // Check if this size is available with the currently selected color
                final isAvailable = activeVariants.any((v) => v.size == s && (colors.isEmpty || v.color == _selectedColor));
                
                return ChoiceChip(
                  label: Text(s),
                  selected: isSelected,
                  onSelected: isAvailable ? (selected) {
                    if (selected) setState(() => _selectedSize = s);
                  } : null,
                  backgroundColor: isAvailable ? Colors.white : AppColors.slate100,
                  selectedColor: AppColors.greenNude.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.greenNude : (isAvailable ? AppColors.slate700 : AppColors.slate400),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          if (colors.isNotEmpty) ...[
            const Text('Color', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.slate700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colors.map((c) {
                final isSelected = _selectedColor == c;
                // Check if this color is available with the currently selected size
                final isAvailable = activeVariants.any((v) => v.color == c && (sizes.isEmpty || v.size == _selectedSize));
                
                return ChoiceChip(
                  label: Text(c),
                  selected: isSelected,
                  onSelected: isAvailable ? (selected) {
                    if (selected) setState(() => _selectedColor = c);
                  } : null,
                  backgroundColor: isAvailable ? Colors.white : AppColors.slate100,
                  selectedColor: AppColors.slate900.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.slate900 : (isAvailable ? AppColors.slate700 : AppColors.slate400),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductOverviewTab extends StatelessWidget {
  const _ProductOverviewTab({required this.product});
  final Product product;
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _ProductInfoHeader(product: product),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _VariantsSectionHeader(productId: product.id),
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
    );
  }
}

class _StockMatrixTab extends ConsumerWidget {
  const _StockMatrixTab({required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matrix = ref.watch(stockMatrixProvider(productId));

    if (matrix == null) {
      return const Center(child: Text('Loading matrix...'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: StockMatrixTable(
        productId: productId,
        matrix: matrix,
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
  const _VariantsSectionHeader({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Variants',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.slate800,
              ),
        ),
        AppButton(
          label: 'Add Variant',
          icon: const Icon(Icons.add, size: 18),
          variant: AppButtonVariant.secondary,
          onPressed: () => context.pushNamed(
            'variantNew',
            pathParameters: {'id': productId},
          ),
        ),
      ],
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
