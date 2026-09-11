import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/entities/variant.dart';
import '../../../product/presentation/providers/product_list_provider.dart';
import '../providers/order_create_provider.dart';

/// Multi-step order creation screen.
///
/// Mobile: Step 1 (Customer) → Step 2 (Items) → Step 3 (Review)
/// Desktop: All sections visible on one page.
class OrderCreateScreen extends ConsumerStatefulWidget {
  const OrderCreateScreen({super.key});

  @override
  ConsumerState<OrderCreateScreen> createState() => _OrderCreateScreenState();
}

class _OrderCreateScreenState extends ConsumerState<OrderCreateScreen> {
  int _step = 0;
  final _customerFormKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      appBar: AppBar(title: const Text('New Order')),
      body: isDesktop
          ? _DesktopOrderForm(
              customerFormKey: _customerFormKey,
              nameCtrl: _nameCtrl,
              phoneCtrl: _phoneCtrl,
              addressCtrl: _addressCtrl,
            )
          : _MobileSteppedForm(
              step: _step,
              customerFormKey: _customerFormKey,
              nameCtrl: _nameCtrl,
              phoneCtrl: _phoneCtrl,
              addressCtrl: _addressCtrl,
              onNextStep: () => setState(() => _step++),
              onPrevStep: () => setState(() => _step--),
            ),
    );
  }
}

// ── Desktop: single-page layout ───────────────────────────────────────────────

class _DesktopOrderForm extends ConsumerWidget {
  const _DesktopOrderForm({
    required this.customerFormKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
  });

  final GlobalKey<FormState> customerFormKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(orderCreateProvider);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(title: 'Customer Info'),
                const SizedBox(height: 16),
                _CustomerForm(
                  formKey: customerFormKey,
                  nameCtrl: nameCtrl,
                  phoneCtrl: phoneCtrl,
                  addressCtrl: addressCtrl,
                ),
                const SizedBox(height: 24),
                _SectionHeader(title: 'Add Items'),
                const SizedBox(height: 16),
                _ProductPicker(),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: _OrderSummaryPanel(
            formKey: customerFormKey,
            nameCtrl: nameCtrl,
            phoneCtrl: phoneCtrl,
            addressCtrl: addressCtrl,
          ),
        ),
      ],
    );
  }
}

// ── Mobile: step-by-step ──────────────────────────────────────────────────────

class _MobileSteppedForm extends ConsumerWidget {
  const _MobileSteppedForm({
    required this.step,
    required this.customerFormKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.onNextStep,
    required this.onPrevStep,
  });

  final int step;
  final GlobalKey<FormState> customerFormKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final VoidCallback onNextStep;
  final VoidCallback onPrevStep;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (step) {
      0 => _StepCustomerInfo(
          formKey: customerFormKey,
          nameCtrl: nameCtrl,
          phoneCtrl: phoneCtrl,
          addressCtrl: addressCtrl,
          onNext: onNextStep,
        ),
      1 => _StepAddItems(onNext: onNextStep, onBack: onPrevStep),
      _ => _StepReview(
          formKey: customerFormKey,
          nameCtrl: nameCtrl,
          phoneCtrl: phoneCtrl,
          addressCtrl: addressCtrl,
          onBack: onPrevStep,
        ),
    };
  }
}

class _StepCustomerInfo extends StatelessWidget {
  const _StepCustomerInfo({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.onNext,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepIndicator(current: 1, total: 3),
          const SizedBox(height: 20),
          const _SectionHeader(title: 'Customer Info'),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: _CustomerForm(
                formKey: formKey,
                nameCtrl: nameCtrl,
                phoneCtrl: phoneCtrl,
                addressCtrl: addressCtrl,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Next: Add Items',
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) onNext();
            },
          ),
        ],
      ),
    );
  }
}

class _StepAddItems extends ConsumerWidget {
  const _StepAddItems({required this.onNext, required this.onBack});

  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(orderCreateProvider).items;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const _StepIndicator(current: 2, total: 3),
          const SizedBox(height: 20),
          const _SectionHeader(title: 'Add Items'),
          const SizedBox(height: 16),
          Expanded(child: _ProductPicker()),
          if (items.isNotEmpty) ...[
            const Divider(),
            _CartSummaryBar(
              itemCount: items.length,
              total: items.fold(0, (s, i) => s + i.subtotal),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Back',
                  variant: AppButtonVariant.secondary,
                  onPressed: onBack,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Review',
                  onPressed: items.isEmpty ? null : onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepReview extends ConsumerWidget {
  const _StepReview({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.onBack,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(orderCreateProvider);
    final notifier = ref.read(orderCreateProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const _StepIndicator(current: 3, total: 3),
          const SizedBox(height: 20),
          Expanded(
            child: _OrderSummaryPanel(
              formKey: formKey,
              nameCtrl: nameCtrl,
              phoneCtrl: phoneCtrl,
              addressCtrl: addressCtrl,
              showBackButton: true,
              onBack: onBack,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared form components ─────────────────────────────────────────────────────

class _CustomerForm extends ConsumerWidget {
  const _CustomerForm({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(orderCreateProvider.notifier);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel(label: 'Customer Name *'),
          TextFormField(
            controller: nameCtrl,
            textInputAction: TextInputAction.next,
            decoration:
                const InputDecoration(hintText: 'Full name'),
            onChanged: notifier.updateCustomerName,
            validator: (v) =>
                Validators.required(v, fieldName: 'Customer name'),
          ),
          const SizedBox(height: 16),
          const _FieldLabel(label: 'Phone Number'),
          TextFormField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(hintText: '09xxxxxxxx'),
            onChanged: (v) =>
                notifier.updateCustomerPhone(v.isEmpty ? null : v),
            validator: (v) =>
                v != null && v.isNotEmpty ? Validators.phoneNumber(v) : null,
          ),
          const SizedBox(height: 16),
          const _FieldLabel(label: 'Delivery Address'),
          TextFormField(
            controller: addressCtrl,
            maxLines: 2,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(hintText: 'Optional'),
            onChanged: (v) =>
                notifier.updateCustomerAddress(v.isEmpty ? null : v),
          ),
        ],
      ),
    );
  }
}

class _ProductPicker extends ConsumerStatefulWidget {
  const _ProductPicker();

  @override
  ConsumerState<_ProductPicker> createState() => _ProductPickerState();
}

class _ProductPickerState extends ConsumerState<_ProductPicker> {
  Product? _selectedProduct;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productListProvider);
    final orderItems = ref.watch(orderCreateProvider).items;
    final orderNotifier = ref.read(orderCreateProvider.notifier);

    return productsAsync.when(
      loading: () => const SkeletonListLoader(count: 4),
      error: (e, _) => Center(child: Text('Failed to load products: $e')),
      data: (products) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product list
          SizedBox(
            height: 200,
            child: ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final p = products[i];
                final isSelected = _selectedProduct?.id == p.id;
                return _ProductPickerTile(
                  product: p,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedProduct = p),
                );
              },
            ),
          ),
          if (_selectedProduct != null) ...[
            const Divider(height: 24),
            const _FieldLabel(label: 'Select Variant'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedProduct!.variants
                  .where((v) => v.isActive && !v.isOutOfStock)
                  .map((v) => _VariantChip(
                        variant: v,
                        basePrice: _selectedProduct!.basePrice,
                        productName: _selectedProduct!.name,
                        onAdd: (item) {
                          orderNotifier.addItem(item);
                          setState(() => _selectedProduct = null);
                        },
                      ))
                  .toList(),
            ),
          ],
          if (orderItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            const _FieldLabel(label: 'Cart'),
            ...orderItems.map(
              (item) => _CartItemRow(
                item: item,
                onRemove: () => orderNotifier.removeItem(item.variantId),
                onQuantityChange: (q) =>
                    orderNotifier.updateItemQuantity(item.variantId, q),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductPickerTile extends StatelessWidget {
  const _ProductPickerTile({
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  final Product product;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? AppColors.slate900 : AppColors.slate200,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? AppColors.slate100 : Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                style: TextStyle(
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: AppColors.slate900,
                ),
              ),
            ),
            Text(
              '${product.totalAvailableStock} in stock',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.slate400),
            ),
          ],
        ),
      ),
    );
  }
}

class _VariantChip extends StatelessWidget {
  const _VariantChip({
    required this.variant,
    required this.basePrice,
    required this.productName,
    required this.onAdd,
  });

  final Variant variant;
  final double basePrice;
  final String productName;
  final void Function(PendingOrderItem) onAdd;

  @override
  Widget build(BuildContext context) {
    final price = variant.priceOverride ?? basePrice;

    return ActionChip(
      label: Text(
        '${variant.displayName} — ${CurrencyFormatter.format(price)}',
        style: const TextStyle(fontSize: 12),
      ),
      onPressed: () => onAdd(
        PendingOrderItem(
          variantId: variant.id,
          productName: productName,
          variantDisplayName: variant.displayName,
          quantity: 1,
          unitPrice: price,
        ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({
    required this.item,
    required this.onRemove,
    required this.onQuantityChange,
  });

  final PendingOrderItem item;
  final VoidCallback onRemove;
  final void Function(int) onQuantityChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(item.variantDisplayName,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.slate400)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 20),
                onPressed: () => onQuantityChange(item.quantity - 1),
                visualDensity: VisualDensity.compact,
              ),
              Text('${item.quantity}',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20),
                onPressed: () => onQuantityChange(item.quantity + 1),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          Text(
            CurrencyFormatter.format(item.subtotal),
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                size: 18, color: AppColors.danger),
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryPanel extends ConsumerWidget {
  const _OrderSummaryPanel({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    this.showBackButton = false,
    this.onBack,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(orderCreateProvider);
    final notifier = ref.read(orderCreateProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(title: 'Order Summary'),
          const SizedBox(height: 12),
          if (formState.items.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('No items added yet.',
                    style: TextStyle(color: AppColors.slate400)),
              ),
            )
          else ...[
            ...formState.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                          '${item.productName} (${item.variantDisplayName}) ×${item.quantity}',
                          style: const TextStyle(fontSize: 13)),
                    ),
                    Text(CurrencyFormatter.format(item.subtotal),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
                Text(
                  CurrencyFormatter.format(formState.totalAmount),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ],
          if (formState.errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.dangerBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                formState.errorMessage!,
                style:
                    const TextStyle(color: AppColors.danger, fontSize: 13),
              ),
            ),
          ],
          const SizedBox(height: 24),
          AppButton(
            label: 'Confirm Order',
            isLoading: formState.isLoading,
            onPressed: formState.items.isEmpty
                ? null
                : () async {
                    if (!(formKey.currentState?.validate() ?? true)) return;
                    notifier
                      ..updateCustomerName(nameCtrl.text.trim())
                      ..updateCustomerPhone(phoneCtrl.text.trim().isEmpty
                          ? null
                          : phoneCtrl.text.trim())
                      ..updateCustomerAddress(
                          addressCtrl.text.trim().isEmpty
                              ? null
                              : addressCtrl.text.trim());
                    final order = await notifier.submit();
                    if (order != null && context.mounted) {
                      context.pushReplacementNamed(
                        'orderDetail',
                        pathParameters: {'id': order.id},
                      );
                    }
                  },
          ),
          if (showBackButton) ...[
            const SizedBox(height: 12),
            AppButton(
              label: 'Back',
              variant: AppButtonVariant.secondary,
              onPressed: onBack,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Utility sub-widgets ────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.slate800,
          ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final active = i + 1 == current;
        final done = i + 1 < current;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: done || active
                  ? AppColors.slate900
                  : AppColors.slate200,
            ),
          ),
        );
      }),
    );
  }
}

class _CartSummaryBar extends StatelessWidget {
  const _CartSummaryBar({required this.itemCount, required this.total});
  final int itemCount;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$itemCount item${itemCount == 1 ? '' : 's'} in cart',
              style: const TextStyle(color: AppColors.slate600, fontSize: 13)),
          Text(CurrencyFormatter.format(total),
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.slate600)),
    );
  }
}
