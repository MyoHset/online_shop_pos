import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/responsive/adaptive_scaffold.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/category_search_bar.dart';
import '../../../../core/widgets/mobile_filter_header.dart';
import '../../../../core/widgets/search_text_field.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/entities/variant.dart';
import '../../../product/presentation/providers/product_brands_provider.dart';
import '../../../product/presentation/providers/product_categories_provider.dart';
import '../../domain/entities/cart_item.dart';
import '../providers/quick_sale_filter_provider.dart';
import '../providers/quick_sale_provider.dart';
import '../widgets/cart_line_item.dart';
import '../widgets/cart_summary_panel.dart';
import '../widgets/product_tile_selectable.dart';
import '../widgets/quick_sale_mobile_cart.dart';
import '../widgets/sale_success_receipt.dart';

class QuickSaleScreen extends ConsumerStatefulWidget {
  const QuickSaleScreen({super.key});

  @override
  ConsumerState<QuickSaleScreen> createState() => _QuickSaleScreenState();
}

class _QuickSaleScreenState extends ConsumerState<QuickSaleScreen> {
  final GlobalKey _cartIconKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickSaleProvider);

    if (state.completedOrder != null) {
      return const SaleSuccessReceipt();
    }

    final device = DeviceType.from(context);
    final isDesktop =
        device == DeviceType.desktop || device == DeviceType.large;
    final isTablet = device == DeviceType.tablet;
    final isLargeScreen = isDesktop || isTablet;

    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        leading: !isLargeScreen
            ? IconButton(
                icon: const Icon(Icons.menu_rounded, color: AppColors.slate900),
                tooltip: 'Open menu',
                onPressed: () => AdaptiveScaffold.openDrawer(context),
              )
            : null,
        title: const Text('Quick Sale'),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (isDesktop) const _DesktopSearchAction(),
          if (!isLargeScreen)
            IconButton(
              key: _cartIconKey,
              icon: Badge(
                isLabelVisible: state.cart.isNotEmpty,
                label: Text('${state.cart.items.length}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              onPressed: () => showQuickSaleMobileCart(context),
            ),
          const SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.slate200, height: 1),
        ),
      ),
      body: Column(
        children: [
          // Top Search and Filter Bar
          if (!isLargeScreen)
            Builder(
              builder: (ctx) {
                final categoriesAsync = ref.watch(productCategoriesProvider);
                final brandsAsync = ref.watch(productBrandsProvider);
                final filter = ref.watch(quickSaleFilterProvider);
                return MobileSearchFilterHeader(
                  searchQuery: filter.search,
                  onSearchChanged: (s) =>
                      ref.read(quickSaleFilterProvider.notifier).setSearch(s),
                  selectedCategory: filter.category,
                  selectedBrand: filter.brand,
                  onCategoryChanged: (c) =>
                      ref.read(quickSaleFilterProvider.notifier).setCategory(c),
                  onBrandChanged: (b) =>
                      ref.read(quickSaleFilterProvider.notifier).setBrand(b),
                  onClearFilters: () {
                    ref
                        .read(quickSaleFilterProvider.notifier)
                        .setCategory(null);
                    ref.read(quickSaleFilterProvider.notifier).setBrand(null);
                  },
                  onOpenFilter: () => showFilterTopSheet(
                    context,
                    categories: categoriesAsync.value ?? [],
                    brands: brandsAsync.value ?? [],
                    selectedCategory: filter.category,
                    selectedBrand: filter.brand,
                    onCategoryChanged: (c) => ref
                        .read(quickSaleFilterProvider.notifier)
                        .setCategory(c),
                    onBrandChanged: (b) =>
                        ref.read(quickSaleFilterProvider.notifier).setBrand(b),
                    onReset: () {
                      ref
                          .read(quickSaleFilterProvider.notifier)
                          .setCategory(null);
                      ref.read(quickSaleFilterProvider.notifier).setBrand(null);
                    },
                  ),
                );
              },
            )
          else ...[
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Builder(
                builder: (ctx) {
                  final categoriesAsync = ref.watch(productCategoriesProvider);
                  final brandsAsync = ref.watch(productBrandsProvider);
                  final filter = ref.watch(quickSaleFilterProvider);
                  return CategorySearchBar(
                    showSearchField: !isDesktop,
                    categories: categoriesAsync.value ?? [],
                    brands: brandsAsync.value ?? [],
                    selectedCategory: filter.category,
                    selectedBrand: filter.brand,
                    searchQuery: filter.search,
                    onCategoryChanged: (c) => ref
                        .read(quickSaleFilterProvider.notifier)
                        .setCategory(c),
                    onBrandChanged: (b) =>
                        ref.read(quickSaleFilterProvider.notifier).setBrand(b),
                    onSearchChanged: (s) =>
                        ref.read(quickSaleFilterProvider.notifier).setSearch(s),
                  );
                },
              ),
            ),
            Container(height: 1, color: AppColors.slate200),
          ],
          // Main Content
          Expanded(
            child: Row(
              children: [
                // Left Side: Product Grid
                Expanded(
                  child: _ProductGrid(
                    isDesktop: isDesktop,
                    isLargeScreen: isLargeScreen,
                    cartIconKey: _cartIconKey,
                  ),
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
          ),
        ],
      ),
    );
  }
}

class _DesktopSearchAction extends ConsumerStatefulWidget {
  const _DesktopSearchAction();

  @override
  ConsumerState<_DesktopSearchAction> createState() =>
      _DesktopSearchActionState();
}

class _DesktopSearchActionState extends ConsumerState<_DesktopSearchAction> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(quickSaleFilterProvider);

    if (!_expanded) {
      return IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Search',
        onPressed: () {
          setState(() {
            _expanded = true;
          });
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchTextField(
            value: filter.search,
            onChanged: (s) =>
                ref.read(quickSaleFilterProvider.notifier).setSearch(s),
            width: 300,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close Search',
            onPressed: () {
              ref.read(quickSaleFilterProvider.notifier).setSearch('');
              setState(() {
                _expanded = false;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ProductGrid extends ConsumerStatefulWidget {
  const _ProductGrid({
    required this.isDesktop,
    required this.isLargeScreen,
    this.cartIconKey,
  });

  final bool isDesktop;
  final bool isLargeScreen;
  final GlobalKey? cartIconKey;

  @override
  ConsumerState<_ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends ConsumerState<_ProductGrid> {
  Offset? _lastTapPosition;

  void _triggerFlightAnimation(BuildContext context, Offset? startOffset) {
    if (startOffset == null) return;
    final media = MediaQuery.of(context);
    final Offset target;
    if (!widget.isLargeScreen) {
      final renderBox =
          widget.cartIconKey?.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final pos = renderBox.localToGlobal(Offset.zero);
        target = Offset(
          pos.dx + renderBox.size.width / 2,
          pos.dy + renderBox.size.height / 2,
        );
      } else {
        target = Offset(media.size.width - 38, media.padding.top + 28);
      }
    } else {
      target = Offset(media.size.width - (widget.isDesktop ? 200 : 160), 120);
    }

    runAddToCartFlightAnimation(
      context: context,
      startOffset: startOffset,
      targetOffset: target,
    );
  }

  void _onProductTapped(BuildContext context, Product p, Offset? tapPos) {
    final activeVariants =
        p.variants.where((v) => v.isActive && !v.isOutOfStock).toList();
    if (activeVariants.isEmpty) return;

    if (activeVariants.length == 1) {
      _triggerFlightAnimation(context, tapPos);
      _addVariantToCart(p, activeVariants.first);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => _VariantSelectionDialog(
          product: p,
          variants: activeVariants,
          onSelected: (v, variantTapPos) {
            Navigator.pop(ctx);
            _triggerFlightAnimation(context, variantTapPos ?? tapPos);
            _addVariantToCart(p, v);
          },
        ),
      );
    }
  }

  void _addVariantToCart(Product p, Variant v) {
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
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(quickSaleProductListProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.refresh(quickSaleProductListProvider.future),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const Center(
              child: Text('No products available.',
                  style: TextStyle(color: AppColors.slate500)));
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                widget.isLargeScreen ? 20 : 16,
                widget.isLargeScreen ? 20 : 16,
                widget.isLargeScreen ? 20 : 16,
                widget.isLargeScreen ? 20 : 20,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: widget.isDesktop ? 220 : 180,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 220,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final product = products[i];
                    return ProductTileSelectable(
                      product: product,
                      onTapWithPosition: (pos) => _lastTapPosition = pos,
                      onTap: () =>
                          _onProductTapped(context, product, _lastTapPosition),
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
                      Icon(Icons.shopping_cart_outlined,
                          size: 64, color: AppColors.slate300),
                      SizedBox(height: 16),
                      Text('Cart is empty',
                          style: TextStyle(
                              color: AppColors.slate500, fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: state.cart.items.length,
                  itemBuilder: (context, i) {
                    final item = state.cart.items[i];
                    return CartLineItem(
                      item: item,
                      onIncrement: () => notifier.updateQuantity(
                          item.variantId, item.quantity + 1),
                      onDecrement: () => notifier.updateQuantity(
                          item.variantId, item.quantity - 1),
                    );
                  },
                ),
        ),
        const CartSummaryPanel(),
      ],
    );
  }
}

class _VariantSelectionDialog extends StatefulWidget {
  const _VariantSelectionDialog({
    required this.product,
    required this.variants,
    required this.onSelected,
  });

  final Product product;
  final List<Variant> variants;
  final void Function(Variant, Offset? tapPos) onSelected;

  @override
  State<_VariantSelectionDialog> createState() =>
      _VariantSelectionDialogState();
}

class _VariantSelectionDialogState extends State<_VariantSelectionDialog> {
  Offset? _itemTapPos;

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
              widget.product.name,
              style: const TextStyle(color: AppColors.slate500, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.variants.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final v = widget.variants[index];
                  final price = v.priceOverride ?? widget.product.basePrice;
                  return InkWell(
                    onTapDown: (details) =>
                        _itemTapPos = details.globalPosition,
                    onTap: () => widget.onSelected(v, _itemTapPos),
                    borderRadius: BorderRadius.circular(12),
                    splashColor: AppColors.slate100,
                    highlightColor: AppColors.slate50,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancel',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
