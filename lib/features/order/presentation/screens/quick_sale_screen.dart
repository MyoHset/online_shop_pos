import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/category_search_bar.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/entities/variant.dart';
import '../../../product/presentation/providers/product_categories_provider.dart';
import '../../domain/entities/cart_item.dart';
import '../providers/quick_sale_filter_provider.dart';
import '../providers/quick_sale_provider.dart';
import '../widgets/cart_line_item.dart';
import '../widgets/cart_summary_panel.dart';
import '../widgets/product_tile_selectable.dart';
import '../widgets/sale_success_receipt.dart';

class QuickSaleScreen extends ConsumerWidget {
  const QuickSaleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickSaleProvider);

    if (state.completedOrder != null) {
      return const SaleSuccessReceipt();
    }

    final device = DeviceType.from(context);
    final isDesktop = device == DeviceType.desktop || device == DeviceType.large;
    final isTablet = device == DeviceType.tablet;
    final isLargeScreen = isDesktop || isTablet;

    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        title: const Text('Quick Sale'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!isLargeScreen)
            IconButton(
              icon: Badge(
                isLabelVisible: state.cart.isNotEmpty,
                label: Text('${state.cart.items.length}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              onPressed: () => _showMobileCart(context),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Builder(builder: (ctx) {
              final categoriesAsync = ref.watch(productCategoriesProvider);
              final filter = ref.watch(quickSaleFilterProvider);
              return CategorySearchBar(
                categories: categoriesAsync.value ?? [],
                selectedCategory: filter.category,
                searchQuery: filter.search,
                onCategoryChanged: (c) => ref.read(quickSaleFilterProvider.notifier).setCategory(c),
                onSearchChanged: (s) => ref.read(quickSaleFilterProvider.notifier).setSearch(s),
              );
            }),
          ),
        ),
      ),
      body: Row(
        children: [
          // Left Side: Product Grid
          Expanded(
            child: _ProductGrid(isDesktop: isDesktop),
          ),
          // Right Side: Cart (Desktop/Tablet Only)
          if (isLargeScreen) ...[
            Container(width: 1, color: AppColors.slate200),
            SizedBox(
              width: isDesktop ? 400 : 320,
              child: const _CartSidebar(),
            ),
          ],
        ],
      ),
    );
  }

  void _showMobileCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: AppColors.slate50,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child:  Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.slate300, borderRadius: BorderRadius.circular(2))),
              ),
            ),
            Expanded(child: _CartSidebar()),
          ],
        ),
      ),
    );
  }
}

class _ProductGrid extends ConsumerWidget {
  const _ProductGrid({required this.isDesktop});
  final bool isDesktop;

  void _onProductTapped(BuildContext context, WidgetRef ref, Product p) {
    final activeVariants = p.variants.where((v) => v.isActive && !v.isOutOfStock).toList();
    if (activeVariants.isEmpty) return;
    
    if (activeVariants.length == 1) {
      _addVariantToCart(ref, p, activeVariants.first);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => _VariantSelectionDialog(
          product: p,
          variants: activeVariants,
          onSelected: (v) {
            Navigator.pop(ctx);
            _addVariantToCart(ref, p, v);
          },
        ),
      );
    }
  }

  void _addVariantToCart(WidgetRef ref, Product p, Variant v) {
    final price = v.priceOverride ?? p.basePrice;
    ref.read(quickSaleProvider.notifier).addToCart(
      CartItem(
        variantId: v.id,
        productName: p.name,
        variantDisplayName: v.displayName,
        unitPrice: price,
        quantity: 1,
        availableStock: v.availableStock,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(quickSaleProductListProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.refresh(quickSaleProductListProvider.future),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text('No products available.', style: TextStyle(color: AppColors.slate500)));
        }
        
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: isDesktop ? 220 : 180,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 220,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final product = products[i];
                    return ProductTileSelectable(
                      product: product,
                      onTap: () => _onProductTapped(context, ref, product),
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CartSidebar extends ConsumerWidget {
  const _CartSidebar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickSaleProvider);
    final notifier = ref.read(quickSaleProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: state.cart.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.slate300),
                      SizedBox(height: 16),
                      Text('Cart is empty', style: TextStyle(color: AppColors.slate500, fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: state.cart.items.length,
                  itemBuilder: (context, i) {
                    final item = state.cart.items[i];
                    return CartLineItem(
                      item: item,
                      onIncrement: () => notifier.updateQuantity(item.variantId, item.quantity + 1),
                      onDecrement: () => notifier.updateQuantity(item.variantId, item.quantity - 1),
                    );
                  },
                ),
        ),
        const CartSummaryPanel(),
      ],
    );
  }
}

class _VariantSelectionDialog extends StatelessWidget {
  const _VariantSelectionDialog({
    required this.product,
    required this.variants,
    required this.onSelected,
  });

  final Product product;
  final List<Variant> variants;
  final void Function(Variant) onSelected;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Variant',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              product.name,
              style: const TextStyle(color: AppColors.slate500, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: variants.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final v = variants[index];
                  final price = v.priceOverride ?? product.basePrice;
                  return InkWell(
                    onTap: () => onSelected(v),
                    borderRadius: BorderRadius.circular(12),
                    splashColor: AppColors.slate100,
                    highlightColor: AppColors.slate50,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.slate200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              v.displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: AppColors.slate800,
                              ),
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(price),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppColors.slate900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.slate700,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
