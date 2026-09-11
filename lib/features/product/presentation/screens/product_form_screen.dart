import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../providers/product_detail_provider.dart';
import '../providers/product_form_provider.dart';

/// Product create/edit form screen.
///
/// [productId] is `null` when creating a new product.
class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key, required this.productId});

  final String? productId;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _codeCtrl;
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    _priceCtrl = TextEditingController();
    _categoryCtrl = TextEditingController();
    _brandCtrl = TextEditingController();
    _codeCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _categoryCtrl.dispose();
    _brandCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  void _prefillIfNeeded() {
    if (_prefilled || widget.productId == null) return;
    final productAsync =
        ref.watch(productDetailProvider(widget.productId!));
    productAsync.whenData((product) {
      if (!_prefilled) {
        _prefilled = true;
        ref.read(productFormProvider.notifier).prefill(product);
        _nameCtrl.text = product.name;
        _descCtrl.text = product.description ?? '';
        _priceCtrl.text = product.basePrice.toString();
        _categoryCtrl.text = product.category ?? '';
        _brandCtrl.text = product.brand ?? '';
        _codeCtrl.text = product.productCode ?? '';
      }
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0;
    ref.read(productFormProvider.notifier)
      ..updateName(_nameCtrl.text.trim())
      ..updateDescription(_descCtrl.text.trim())
      ..updateBasePrice(price)
      ..updateCategory(_categoryCtrl.text.trim().isEmpty
          ? null
          : _categoryCtrl.text.trim())
      ..updateBrand(
          _brandCtrl.text.trim().isEmpty ? null : _brandCtrl.text.trim())
      ..updateProductCode(
          _codeCtrl.text.trim().isEmpty ? null : _codeCtrl.text.trim());

    final saved = await ref
        .read(productFormProvider.notifier)
        .save(existingProductId: widget.productId);

    if (saved != null && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    _prefillIfNeeded();

    final formState = ref.watch(productFormProvider);
    final isEditing = widget.productId != null;
    final maxWidth = context.responsiveValue<double>(
      mobile: double.infinity,
      tablet: 600,
      desktop: 640,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'New Product'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: context.horizontalPadding,
                vertical: 24,
              ),
              children: [
                _FormSection(
                  title: 'Basic Info',
                  children: [
                    _FieldLabel(label: 'Product Name *'),
                    TextFormField(
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.next,
                      decoration:
                          const InputDecoration(hintText: 'e.g. Classic Tee'),
                      validator: (v) => Validators.required(v, fieldName: 'Name'),
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(label: 'Description'),
                    TextFormField(
                      controller: _descCtrl,
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          hintText: 'Optional product description'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _FormSection(
                  title: 'Pricing',
                  children: [
                    _FieldLabel(label: 'Base Price (MMK) *'),
                    TextFormField(
                      controller: _priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: false),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: '0',
                        prefixText: 'K ',
                      ),
                      validator: (v) =>
                          Validators.positiveNumber(v, fieldName: 'Price'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _FormSection(
                  title: 'Categorisation',
                  children: [
                    _FieldLabel(label: 'Category'),
                    TextFormField(
                      controller: _categoryCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          hintText: 'e.g. Clothing, Accessories'),
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(label: 'Brand'),
                    TextFormField(
                      controller: _brandCtrl,
                      textInputAction: TextInputAction.next,
                      decoration:
                          const InputDecoration(hintText: 'e.g. My Brand'),
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel(label: 'Product Code'),
                    TextFormField(
                      controller: _codeCtrl,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                          hintText: 'Unique product identifier'),
                      validator: Validators.sku,
                    ),
                  ],
                ),
                if (formState.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _ErrorBanner(message: formState.errorMessage!),
                ],
                const SizedBox(height: 32),
                AppButton(
                  label: isEditing ? 'Save Changes' : 'Create Product',
                  onPressed: _submit,
                  isLoading: formState.isLoading,
                ),
                if (isEditing) ...[
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.ghost,
                    onPressed: () => context.pop(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.slate700,
              ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
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
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.slate600,
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.danger, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
