import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/category_search_bar.dart';
import '../../../../core/widgets/search_text_field.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/entities/variant.dart';
import '../../../product/presentation/providers/product_brands_provider.dart';
import '../../../product/presentation/providers/product_categories_provider.dart';
import '../../../product/presentation/widgets/product_card.dart';
import '../providers/online_order_provider.dart';
import '../providers/order_item_picker_filter_provider.dart';
import '../widgets/discount_input.dart';

/// POS style single-page online order creation screen.
class OnlineOrderScreen extends ConsumerStatefulWidget {
  const OnlineOrderScreen({super.key});

  @override
  ConsumerState<OnlineOrderScreen> createState() => _OnlineOrderScreenState();
}

class _OnlineOrderScreenState extends ConsumerState<OnlineOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _onProductTapped(Product p, WidgetRef ref) {
    final activeVariants = p.variants.where((v) => v.isActive && !v.isOutOfStock).toList();
    if (activeVariants.isEmpty) return;
    
    if (activeVariants.length == 1) {
      _addVariant(p, activeVariants.first, ref);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => _VariantSelectionDialog(
          product: p,
          variants: activeVariants,
          onSelected: (v) {
            Navigator.pop(ctx);
            _addVariant(p, v, ref);
          },
        ),
      );
    }
  }

  void _addVariant(Product p, Variant v, WidgetRef ref) {
    final price = v.priceOverride ?? p.basePrice;
    ref.read(onlineOrderProvider.notifier).addItem(
      PendingOrderItem(
        variantId: v.id,
        productName: p.name,
        variantDisplayName: v.displayName,
        quantity: 1,
        unitPrice: price,
      ),
    );
  }

  Future<void> _submitOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    final notifier = ref.read(onlineOrderProvider.notifier);
    final state = ref.read(onlineOrderProvider);
    
    if (state.items.isEmpty) return;

    notifier
      ..updateCustomerName(_nameCtrl.text.trim())
      ..updateCustomerPhone(_phoneCtrl.text.trim())
      ..updateCustomerAddress(_addressCtrl.text.trim());
      
    final order = await notifier.submit();
    if (order != null && mounted) {
      context.pushReplacementNamed(
        'orderDetail',
        pathParameters: {'id': order.id},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = DeviceType.from(context) == DeviceType.desktop || DeviceType.from(context) == DeviceType.large;
    final isTablet = DeviceType.from(context) == DeviceType.tablet;
    final isLargeScreen = isDesktop || isTablet;

    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        title: const Text('Online Order'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (isDesktop) const _DesktopSearchAction(),
          if (!isLargeScreen) // On mobile, show cart button
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: _CartSidebar(
                      formKey: _formKey,
                      nameCtrl: _nameCtrl,
                      phoneCtrl: _phoneCtrl,
                      addressCtrl: _addressCtrl,
                      onSubmit: _submitOrder,
                    ),
                  ),
                );
              },
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
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Builder(builder: (ctx) {
              final categoriesAsync = ref.watch(productCategoriesProvider);
              final brandsAsync = ref.watch(productBrandsProvider);
              final filter = ref.watch(orderItemPickerFilterProvider);
              return CategorySearchBar(
                showSearchField: !isDesktop,
                categories: categoriesAsync.value ?? [],
                brands: brandsAsync.value ?? [],
                selectedCategory: filter.category,
                selectedBrand: filter.brand,
                searchQuery: filter.search,
                onCategoryChanged: (c) => ref.read(orderItemPickerFilterProvider.notifier).setCategory(c),
                onBrandChanged: (b) => ref.read(orderItemPickerFilterProvider.notifier).setBrand(b),
                onSearchChanged: (s) => ref.read(orderItemPickerFilterProvider.notifier).setSearch(s),
              );
            }),
          ),
          Container(height: 1, color: AppColors.slate200),
          // Main Content
          Expanded(
            child: Row(
        children: [
          // Left Side: Product Grid
          Expanded(
            child: _ProductGridSection(
              onProductTapped: (p) => _onProductTapped(p, ref),
            ),
          ),
          // Right Side: Cart (Desktop/Tablet Only)
          if (isLargeScreen) ...[
            Container(width: 1, color: AppColors.slate200),
            SizedBox(
              width: 360,
              child: _CartSidebar(
                formKey: _formKey,
                nameCtrl: _nameCtrl,
                phoneCtrl: _phoneCtrl,
                addressCtrl: _addressCtrl,
                onSubmit: _submitOrder,
              ),
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
  ConsumerState<_DesktopSearchAction> createState() => _DesktopSearchActionState();
}

class _DesktopSearchActionState extends ConsumerState<_DesktopSearchAction> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(orderItemPickerFilterProvider);

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
            onChanged: (s) => ref.read(orderItemPickerFilterProvider.notifier).setSearch(s),
            width: 300,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close Search',
            onPressed: () {
              ref.read(orderItemPickerFilterProvider.notifier).setSearch('');
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

// ── Product Grid Section ──
class _ProductGridSection extends ConsumerWidget {
  const _ProductGridSection({required this.onProductTapped});
  final void Function(Product) onProductTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(onlineOrderProductListProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.refresh(onlineOrderProductListProvider.future),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text('No products available.', style: TextStyle(color: AppColors.slate500)));
        }
        
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220, // Nice grid size
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 220, // Height for ProductCard
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final product = products[i];
                    return _InCartBadgeWrapper(
                      product: product,
                      child: ProductCard(
                        product: product,
                        onTap: () => onProductTapped(product),
                      ),
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

// ── In Cart Badge Wrapper ──
class _InCartBadgeWrapper extends ConsumerWidget {
  const _InCartBadgeWrapper({
    required this.product,
    required this.child,
  });

  final Product product;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(onlineOrderProvider);
    // Check if any item in cart matches any variant of this product
    final inCart = formState.items.any((item) => product.variants.any((v) => v.id == item.variantId));

    if (!inCart) return child;

    return Stack(
      children: [
        child,
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Variant Selection Dialog ──
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

// ── Cart Sidebar ──
class _CartSidebar extends ConsumerWidget {
  const _CartSidebar({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(onlineOrderProvider);
    final notifier = ref.read(onlineOrderProvider.notifier);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Customer Form Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.slate200)),
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Customer Info', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Full Name *',
                      prefixIcon: const Icon(Icons.person_outline, size: 18),
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.slate50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                    validator: (v) => Validators.required(v, fieldName: 'Customer Name'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Phone Number *',
                      prefixIcon: const Icon(Icons.phone_outlined, size: 18),
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.slate50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                    validator: Validators.phoneNumber,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: addressCtrl,
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.done,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Delivery Address *',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Icon(Icons.location_on_outlined, size: 18),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.slate50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
                    validator: (v) => Validators.required(v, fieldName: 'Delivery Address'),
                  ),
                ],
              ),
            ),
          ),
          
          // Cart Items Section
          Expanded(
            child: formState.items.isEmpty
                ? const Center(
                    child: Text('Cart is empty', style: TextStyle(color: AppColors.slate400)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: formState.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, i) {
                      final item = formState.items[i];
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                Text(item.variantDisplayName, style: const TextStyle(color: AppColors.slate500, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(CurrencyFormatter.format(item.subtotal), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.slate900)),
                              ],
                            ),
                          ),
                          // Quantity Controls
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.slate200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 16),
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => notifier.updateItemQuantity(item.variantId, item.quantity - 1),
                                ),
                                Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 16),
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => notifier.updateItemQuantity(item.variantId, item.quantity + 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),

          // Total & Checkout Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, -4), blurRadius: 10),
              ],
            ),
            child: Column(
              children: [
                if (formState.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(formState.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
                  ),

                // Pricing Breakdown
                if (formState.discount.hasDiscount) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate600,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(formState.subtotal),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],

                DiscountInput(
                  subtotal: formState.subtotal,
                  discount: formState.discount,
                  onApply: (d) async => notifier.updateDiscount(d),
                  onRemove: () async => notifier.removeDiscount(),
                ),
                const SizedBox(height: 12),
                const Divider(color: AppColors.slate200, height: 1),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.slate500)),
                    Text(
                      CurrencyFormatter.format(formState.totalAmount),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.slate900),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Confirm Online Order',
                  isLoading: formState.isLoading,
                  minimumWidth: double.infinity,
                  onPressed: formState.items.isEmpty ? null : onSubmit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
