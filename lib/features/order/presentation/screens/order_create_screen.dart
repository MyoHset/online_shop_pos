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
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/entities/variant.dart';
import '../../../product/presentation/providers/product_categories_provider.dart';
import '../../../product/presentation/widgets/product_card.dart';
import '../providers/order_create_provider.dart';
import '../providers/order_item_picker_filter_provider.dart';

/// POS style single-page order creation screen.
class OrderCreateScreen extends ConsumerStatefulWidget {
  const OrderCreateScreen({super.key});

  @override
  ConsumerState<OrderCreateScreen> createState() => _OrderCreateScreenState();
}

class _OrderCreateScreenState extends ConsumerState<OrderCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
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
    ref.read(orderCreateProvider.notifier).addItem(
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
    if (!(_formKey.currentState?.validate() ?? true)) return;
    
    final notifier = ref.read(orderCreateProvider.notifier);
    final state = ref.read(orderCreateProvider);
    
    if (state.items.isEmpty) return;

    notifier
      ..updateCustomerName(_nameCtrl.text.trim())
      ..updateCustomerPhone(_phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim());
      
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
        title: const Text('New Order'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
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
                      onSubmit: _submitOrder,
                    ),
                  ),
                );
              },
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Builder(builder: (ctx) {
              final categoriesAsync = ref.watch(productCategoriesProvider);
              final filter = ref.watch(orderItemPickerFilterProvider);
              return CategorySearchBar(
                categories: categoriesAsync.value ?? [],
                selectedCategory: filter.category,
                searchQuery: filter.search,
                onCategoryChanged: (c) => ref.read(orderItemPickerFilterProvider.notifier).setCategory(c),
                onSearchChanged: (s) => ref.read(orderItemPickerFilterProvider.notifier).setSearch(s),
              );
            }),
          ),
        ),
      ),
      body: Row(
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
                onSubmit: _submitOrder,
              ),
            ),
          ],
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
    final productsAsync = ref.watch(orderCreateProductListProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () => ref.refresh(orderCreateProductListProvider.future),
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
                  maxCrossAxisExtent: 240, // Nice grid size
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 140, // Height for ProductCard
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final product = products[i];
                    return ProductCard(
                      product: product,
                      onTap: () => onProductTapped(product),
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

// ── Cart Sidebar ──
class _CartSidebar extends ConsumerWidget {
  const _CartSidebar({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(orderCreateProvider);
    final notifier = ref.read(orderCreateProvider.notifier);

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
                  const Text('Customer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: 'Full Name *',
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
                    decoration: InputDecoration(
                      hintText: 'Phone (Optional)',
                      isDense: true,
                      filled: true,
                      fillColor: AppColors.slate50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    ),
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
                  label: 'Confirm Order',
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
