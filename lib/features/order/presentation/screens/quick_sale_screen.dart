import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/entities/variant.dart';
import '../../../product/presentation/providers/product_list_provider.dart';
import '../../domain/entities/cart_item.dart';
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
    final productsAsync = ref.watch(productListProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.refresh(productListProvider.future),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Variant', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(product.name, style: const TextStyle(color: AppColors.slate500)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: variants.map((v) {
                final price = v.priceOverride ?? product.basePrice;
                return ActionChip(
                  label: Text('${v.displayName} — ${CurrencyFormatter.format(price)}'),
                  backgroundColor: AppColors.slate100,
                  side: const BorderSide(color: AppColors.slate200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  onPressed: () => onSelected(v),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
