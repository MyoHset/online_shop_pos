import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/adaptive_scaffold.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/category_search_bar.dart';
import '../../../../core/widgets/mobile_filter_header.dart';
import '../../../../core/widgets/search_text_field.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/entities/variant.dart';
import '../../../product/presentation/providers/product_brands_provider.dart';
import '../../../product/presentation/providers/product_categories_provider.dart';
import '../../../product/presentation/widgets/product_card.dart';
import '../providers/online_order_provider.dart';
import '../providers/order_item_picker_filter_provider.dart';
import '../widgets/discount_input.dart';
import '../widgets/quick_sale_mobile_cart.dart';

/// POS style single-page online order creation screen.
class OnlineOrderScreen extends ConsumerStatefulWidget {
  const OnlineOrderScreen({super.key});

  @override
  ConsumerState<OnlineOrderScreen> createState() => _OnlineOrderScreenState();
}

class _OnlineOrderScreenState extends ConsumerState<OnlineOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cartIconKey = GlobalKey();
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

  void _triggerFlightAnimation(Offset? startOffset) {
    if (startOffset == null) return;
    final media = MediaQuery.of(context);
    final isDesktop = DeviceType.from(context) == DeviceType.desktop ||
        DeviceType.from(context) == DeviceType.large;
    final isTablet = DeviceType.from(context) == DeviceType.tablet;
    final isLargeScreen = isDesktop || isTablet;

    final Offset target;
    if (!isLargeScreen) {
      final renderBox =
          _cartIconKey.currentContext?.findRenderObject() as RenderBox?;
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
      target = Offset(media.size.width - (isDesktop ? 200 : 160), 120);
    }

    runAddToCartFlightAnimation(
      context: context,
      startOffset: startOffset,
      targetOffset: target,
    );
  }

  void _onProductTapped(Product p, Offset? tapPos) {
    final activeVariants =
        p.variants.where((v) => v.isActive && !v.isOutOfStock).toList();
    if (activeVariants.isEmpty) return;

    if (activeVariants.length == 1) {
      _triggerFlightAnimation(tapPos);
      _addVariant(p, activeVariants.first);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => _VariantSelectionDialog(
          product: p,
          variants: activeVariants,
          onSelected: (v, variantTapPos) {
            Navigator.pop(ctx);
            _triggerFlightAnimation(variantTapPos ?? tapPos);
            _addVariant(p, v);
          },
        ),
      );
    }
  }

  void _addVariant(Product p, Variant v) {
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
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      context.pushReplacementNamed(
        'orderDetail',
        pathParameters: {'id': order.id},
      );
    }
  }

  void _showMobileCartSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _OnlineOrderMobileCartSheet(
        formKey: _formKey,
        nameCtrl: _nameCtrl,
        phoneCtrl: _phoneCtrl,
        addressCtrl: _addressCtrl,
        onSubmit: _submitOrder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = DeviceType.from(context) == DeviceType.desktop ||
        DeviceType.from(context) == DeviceType.large;
    final isTablet = DeviceType.from(context) == DeviceType.tablet;
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
        title: const Text('Online Order'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (isDesktop) const _DesktopSearchAction(),
          if (!isLargeScreen)
            Builder(
              builder: (ctx) {
                final formState = ref.watch(onlineOrderProvider);
                final totalCount =
                    formState.items.fold(0, (s, i) => s + i.quantity);
                return IconButton(
                  key: _cartIconKey,
                  icon: Badge(
                    isLabelVisible: formState.items.isNotEmpty,
                    label: Text('$totalCount'),
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                  onPressed: () => _showMobileCartSheet(context),
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
          if (!isLargeScreen)
            Builder(
              builder: (ctx) {
                final categoriesAsync = ref.watch(productCategoriesProvider);
                final brandsAsync = ref.watch(productBrandsProvider);
                final filter = ref.watch(orderItemPickerFilterProvider);
                return MobileSearchFilterHeader(
                  searchQuery: filter.search,
                  onSearchChanged: (s) => ref
                      .read(orderItemPickerFilterProvider.notifier)
                      .setSearch(s),
                  selectedCategory: filter.category,
                  selectedBrand: filter.brand,
                  onCategoryChanged: (c) => ref
                      .read(orderItemPickerFilterProvider.notifier)
                      .setCategory(c),
                  onBrandChanged: (b) => ref
                      .read(orderItemPickerFilterProvider.notifier)
                      .setBrand(b),
                  onClearFilters: () {
                    ref
                        .read(orderItemPickerFilterProvider.notifier)
                        .setCategory(null);
                    ref
                        .read(orderItemPickerFilterProvider.notifier)
                        .setBrand(null);
                  },
                  onOpenFilter: () => showFilterTopSheet(
                    context,
                    categories: categoriesAsync.value ?? [],
                    brands: brandsAsync.value ?? [],
                    selectedCategory: filter.category,
                    selectedBrand: filter.brand,
                    onCategoryChanged: (c) => ref
                        .read(orderItemPickerFilterProvider.notifier)
                        .setCategory(c),
                    onBrandChanged: (b) => ref
                        .read(orderItemPickerFilterProvider.notifier)
                        .setBrand(b),
                    onReset: () {
                      ref
                          .read(orderItemPickerFilterProvider.notifier)
                          .setCategory(null);
                      ref
                          .read(orderItemPickerFilterProvider.notifier)
                          .setBrand(null);
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
                  final filter = ref.watch(orderItemPickerFilterProvider);
                  return CategorySearchBar(
                    showSearchField: !isDesktop,
                    categories: categoriesAsync.value ?? [],
                    brands: brandsAsync.value ?? [],
                    selectedCategory: filter.category,
                    selectedBrand: filter.brand,
                    searchQuery: filter.search,
                    onCategoryChanged: (c) => ref
                        .read(orderItemPickerFilterProvider.notifier)
                        .setCategory(c),
                    onBrandChanged: (b) => ref
                        .read(orderItemPickerFilterProvider.notifier)
                        .setBrand(b),
                    onSearchChanged: (s) => ref
                        .read(orderItemPickerFilterProvider.notifier)
                        .setSearch(s),
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
                  child: _ProductGridSection(
                    onProductTapped: _onProductTapped,
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
  ConsumerState<_DesktopSearchAction> createState() =>
      _DesktopSearchActionState();
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
            onChanged: (s) =>
                ref.read(orderItemPickerFilterProvider.notifier).setSearch(s),
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
  final void Function(Product, Offset? tapPos) onProductTapped;

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
          return const Center(
              child: Text('No products available.',
                  style: TextStyle(color: AppColors.slate500)));
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
                    Offset? tapPos;
                    return _InCartBadgeWrapper(
                      product: product,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTapDown: (details) => tapPos = details.globalPosition,
                        child: ProductCard(
                          product: product,
                          onTap: () => onProductTapped(product, tapPos),
                        ),
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
    final inCart = formState.items
        .any((item) => product.variants.any((v) => v.id == item.variantId));

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
                  const Text('Customer Info',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
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
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    ),
                    validator: (v) =>
                        Validators.required(v, fieldName: 'Customer Name'),
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
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
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
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                    ),
                    validator: (v) =>
                        Validators.required(v, fieldName: 'Delivery Address'),
                  ),
                ],
              ),
            ),
          ),

          // Cart Items Section
          Expanded(
            child: formState.items.isEmpty
                ? const Center(
                    child: Text('Cart is empty',
                        style: TextStyle(color: AppColors.slate400)),
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
                                Text(item.productName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                                Text(item.variantDisplayName,
                                    style: const TextStyle(
                                        color: AppColors.slate500,
                                        fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(CurrencyFormatter.format(item.subtotal),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: AppColors.slate900)),
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
                                  onPressed: () => notifier.updateItemQuantity(
                                      item.variantId, item.quantity - 1),
                                ),
                                Text('${item.quantity}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 16),
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => notifier.updateItemQuantity(
                                      item.variantId, item.quantity + 1),
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
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10),
              ],
            ),
            child: Column(
              children: [
                if (formState.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(formState.errorMessage!,
                        style: const TextStyle(
                            color: AppColors.danger, fontSize: 13)),
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
                    const Text('Total',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate500)),
                    Text(
                      CurrencyFormatter.format(formState.totalAmount),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.slate900),
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

// ── Mobile Cart Bottom Sheet for Online Order ──
class _OnlineOrderMobileCartSheet extends ConsumerStatefulWidget {
  const _OnlineOrderMobileCartSheet({
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
  final Future<void> Function() onSubmit;

  @override
  ConsumerState<_OnlineOrderMobileCartSheet> createState() =>
      _OnlineOrderMobileCartSheetState();
}

class _OnlineOrderMobileCartSheetState
    extends ConsumerState<_OnlineOrderMobileCartSheet> {
  bool _isCustomerInfoExpanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    final isFormValid = widget.formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      setState(() {
        _isCustomerInfoExpanded = true;
      });
      // Scroll to top to show customer info errors
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
      return;
    }
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(onlineOrderProvider);
    final notifier = ref.read(onlineOrderProvider.notifier);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final totalCount = formState.items.fold(0, (s, i) => s + i.quantity);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.70,
      ),
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.slate300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 12, 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.greenNude.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      color: AppColors.greenNude,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Online Order Cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.slate100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$totalCount',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (formState.items.isNotEmpty)
                    TextButton(
                      onPressed: notifier.clearCart,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.slate500,
                      size: 20,
                    ),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.slate200),

            // Content Area (Customer info at TOP + Scrollable items)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Collapsible Customer Info Accordion (Dropdown style at VERY TOP)
                    _CustomerInfoAccordion(
                      formKey: widget.formKey,
                      nameCtrl: widget.nameCtrl,
                      phoneCtrl: widget.phoneCtrl,
                      addressCtrl: widget.addressCtrl,
                      isExpanded: _isCustomerInfoExpanded,
                      onToggle: () {
                        setState(() {
                          _isCustomerInfoExpanded = !_isCustomerInfoExpanded;
                        });
                      },
                    ),
                    const SizedBox(height: 14),

                    // 2. Cart Items Section
                    if (formState.items.isEmpty) ...[
                      const SizedBox(height: 24),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: const BoxDecoration(
                                color: AppColors.slate100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.remove_shopping_cart_outlined,
                                size: 26,
                                color: AppColors.slate400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Your cart is empty',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Tap any product to add to cart',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.slate400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 14,
                            color: AppColors.slate500,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Order Items',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$totalCount ${totalCount == 1 ? 'item' : 'items'}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: formState.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = formState.items[index];
                          return _OnlineCartItemMobileTile(
                            item: item,
                            onIncrement: () => notifier.updateItemQuantity(
                              item.variantId,
                              item.quantity + 1,
                            ),
                            onDecrement: () => notifier.updateItemQuantity(
                              item.variantId,
                              item.quantity - 1,
                            ),
                            onRemove: () => notifier.removeItem(item.variantId),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Checkout Summary (Discount Input directly attached to Total Bar)
            if (formState.items.isNotEmpty)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: AppColors.slate200, width: 1),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (formState.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          formState.errorMessage!,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    // Discount Input (Directly attached to bottom total bar)
                    DiscountInput(
                      subtotal: formState.subtotal,
                      discount: formState.discount,
                      onApply: (d) async => notifier.updateDiscount(d),
                      onRemove: () async => notifier.removeDiscount(),
                    ),
                    const SizedBox(height: 10),

                    // Price Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (formState.discount.hasDiscount) ...[
                              Text(
                                'Subtotal: ${CurrencyFormatter.format(formState.subtotal)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.slate500,
                                ),
                              ),
                            ],
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          CurrencyFormatter.format(formState.totalAmount),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.slate900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Submit button
                    AppButton(
                      label: 'Confirm Online Order',
                      isLoading: formState.isLoading,
                      minimumWidth: double.infinity,
                      onPressed: _handleConfirm,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Collapsible Customer Info Accordion Widget ──
class _CustomerInfoAccordion extends StatefulWidget {
  const _CustomerInfoAccordion({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.isExpanded,
    required this.onToggle,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  State<_CustomerInfoAccordion> createState() => _CustomerInfoAccordionState();
}

class _CustomerInfoAccordionState extends State<_CustomerInfoAccordion> {
  @override
  void initState() {
    super.initState();
    widget.nameCtrl.addListener(_onFieldChanged);
    widget.phoneCtrl.addListener(_onFieldChanged);
    widget.addressCtrl.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    widget.nameCtrl.removeListener(_onFieldChanged);
    widget.phoneCtrl.removeListener(_onFieldChanged);
    widget.addressCtrl.removeListener(_onFieldChanged);
    super.dispose();
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  bool get _isComplete =>
      widget.nameCtrl.text.trim().isNotEmpty &&
      widget.phoneCtrl.text.trim().isNotEmpty &&
      widget.addressCtrl.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isComplete = _isComplete;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isComplete
              ? AppColors.success.withValues(alpha: 0.35)
              : (widget.isExpanded
                  ? AppColors.greenNude.withValues(alpha: 0.5)
                  : AppColors.slate200),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collapsible Header / Toggle Row
          InkWell(
            onTap: widget.onToggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isComplete
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.greenNude.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      isComplete
                          ? Icons.person_pin_circle_rounded
                          : Icons.person_outline_rounded,
                      color:
                          isComplete ? AppColors.success : AppColors.greenNude,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Customer Information',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate900,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Status Pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isComplete
                                    ? AppColors.success.withValues(alpha: 0.12)
                                    : AppColors.danger.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isComplete
                                        ? Icons.check_circle_rounded
                                        : Icons.error_outline_rounded,
                                    size: 10,
                                    color: isComplete
                                        ? AppColors.success
                                        : AppColors.danger,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    isComplete ? 'Filled' : 'Required *',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: isComplete
                                          ? AppColors.success
                                          : AppColors.danger,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isComplete
                              ? '${widget.nameCtrl.text.trim()} • ${widget.phoneCtrl.text.trim()}'
                              : 'Tap to enter customer name, phone & address',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: isComplete
                                ? AppColors.slate700
                                : AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: widget.isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.slate600,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable Body
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Form(
                key: widget.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 1, color: AppColors.slate200),
                    const SizedBox(height: 12),
                    // Name Field
                    TextFormField(
                      controller: widget.nameCtrl,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Customer Name *',
                        labelStyle: const TextStyle(
                          fontSize: 13,
                          color: AppColors.slate600,
                        ),
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          size: 18,
                          color: AppColors.slate500,
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.slate200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.slate200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.greenNude,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (v) =>
                          Validators.required(v, fieldName: 'Customer Name'),
                    ),
                    const SizedBox(height: 10),
                    // Phone Field
                    TextFormField(
                      controller: widget.phoneCtrl,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Phone Number *',
                        labelStyle: const TextStyle(
                          fontSize: 13,
                          color: AppColors.slate600,
                        ),
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          size: 18,
                          color: AppColors.slate500,
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.slate200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.slate200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.greenNude,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: Validators.phoneNumber,
                    ),
                    const SizedBox(height: 10),
                    // Address Field
                    TextFormField(
                      controller: widget.addressCtrl,
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.done,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Delivery Address *',
                        labelStyle: const TextStyle(
                          fontSize: 13,
                          color: AppColors.slate600,
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: AppColors.slate500,
                          ),
                        ),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.slate200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.slate200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.greenNude,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (v) =>
                          Validators.required(v, fieldName: 'Delivery Address'),
                    ),
                  ],
                ),
              ),
            ),
            crossFadeState: widget.isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

// ── Mobile Cart Item Tile ──
class _OnlineCartItemMobileTile extends StatelessWidget {
  const _OnlineCartItemMobileTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final PendingOrderItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Row(
        children: [
          // Item Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  item.variantDisplayName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatter.format(item.subtotal),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Stepper Controls
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.slate200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    item.quantity == 1
                        ? Icons.delete_outline_rounded
                        : Icons.remove_rounded,
                    size: 15,
                    color: item.quantity == 1
                        ? AppColors.danger
                        : AppColors.slate700,
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  tooltip: item.quantity == 1 ? 'Remove' : 'Decrease',
                  onPressed: item.quantity == 1 ? onRemove : onDecrement,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 15,
                    color: AppColors.slate700,
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  tooltip: 'Increase',
                  onPressed: onIncrement,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
