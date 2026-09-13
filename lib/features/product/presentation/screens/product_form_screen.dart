import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../providers/product_detail_provider.dart';
import '../providers/product_form_provider.dart';

/// Product create/edit form screen — classic minimal style.
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

  // Underline-only input decoration — shared across all fields
  static const _underlineDecoration = InputDecorationTheme(
    filled: false,
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.slate200),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.slate200),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.slate900, width: 1.5),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.danger),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.danger, width: 1.5),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 10),
    hintStyle: TextStyle(color: AppColors.slate400, fontSize: 14),
    errorStyle: TextStyle(fontSize: 11, height: 1.2),
  );

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
    final productAsync = ref.watch(productDetailProvider(widget.productId!));
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
      tablet: 560,
      desktop: 600,
    );

    return Theme(
      // Override only input decoration for this screen
      data: Theme.of(context).copyWith(
        inputDecorationTheme: _underlineDecoration,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Product' : 'New Product'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: AppColors.slate200),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.horizontalPadding,
                  vertical: 8,
                ),
                children: [
                  // ── Basic Info ───────────────────────────────────────
                  _SectionHeader(label: 'Basic Info'),
                  _ClassicField(
                    label: 'Product Name',
                    required: true,
                    child: TextFormField(
                      controller: _nameCtrl,
                      textInputAction: TextInputAction.next,
                      style: _fieldTextStyle,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Classic Tee',
                      ),
                      validator: (v) =>
                          Validators.required(v, fieldName: 'Name'),
                    ),
                  ),
                  _ClassicField(
                    label: 'Description',
                    child: TextFormField(
                      controller: _descCtrl,
                      maxLines: 2,
                      textInputAction: TextInputAction.next,
                      style: _fieldTextStyle,
                      decoration: const InputDecoration(
                        hintText: 'Optional description',
                      ),
                    ),
                  ),

                  // ── Pricing ──────────────────────────────────────────
                  _SectionHeader(label: 'Pricing'),
                  _ClassicField(
                    label: 'Base Price (MMK)',
                    required: true,
                    child: TextFormField(
                      controller: _priceCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      textInputAction: TextInputAction.next,
                      style: _fieldTextStyle,
                      decoration: const InputDecoration(
                        hintText: '0',
                        prefixText: 'K  ',
                        prefixStyle: TextStyle(
                          color: AppColors.slate500,
                          fontSize: 14,
                        ),
                      ),
                      validator: (v) =>
                          Validators.positiveNumber(v, fieldName: 'Price'),
                    ),
                  ),

                  // ── Categorisation ───────────────────────────────────
                  _SectionHeader(label: 'Categorisation'),
                  _ClassicField(
                    label: 'Category',
                    child: TextFormField(
                      controller: _categoryCtrl,
                      textInputAction: TextInputAction.next,
                      style: _fieldTextStyle,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Clothing',
                      ),
                    ),
                  ),
                  _ClassicField(
                    label: 'Brand',
                    child: TextFormField(
                      controller: _brandCtrl,
                      textInputAction: TextInputAction.next,
                      style: _fieldTextStyle,
                      decoration: const InputDecoration(
                        hintText: 'e.g. My Brand',
                      ),
                    ),
                  ),
                  _ClassicField(
                    label: 'Product Code',
                    isLast: true,
                    child: TextFormField(
                      controller: _codeCtrl,
                      textInputAction: TextInputAction.done,
                      style: _fieldTextStyle,
                      decoration: const InputDecoration(
                        hintText: 'SKU / unique identifier',
                      ),
                      validator: Validators.sku,
                    ),
                  ),

                  // ── Error ────────────────────────────────────────────
                  if (formState.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    _ErrorRow(message: formState.errorMessage!),
                  ],

                  // ── Actions ──────────────────────────────────────────
                  const SizedBox(height: 28),
                  _SubmitButton(
                    label: isEditing ? 'Save Changes' : 'Create Product',
                    isLoading: formState.isLoading,
                    onPressed: _submit,
                  ),
                  if (isEditing) ...[
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Cancel'),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Field text style ─────────────────────────────────────────────────────────

const _fieldTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: AppColors.slate900,
);

// ── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 2),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
          color: AppColors.slate500,
        ),
      ),
    );
  }
}

// ── Classic field row (label left, input right on wide; stacked on narrow) ───

class _ClassicField extends StatelessWidget {
  const _ClassicField({
    required this.label,
    required this.child,
    this.required = false,
    this.isLast = false,
  });

  final String label;
  final Widget child;
  final bool required;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label column — fixed width
            SizedBox(
              width: 130,
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: RichText(
                  text: TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.slate600,
                    ),
                    children: required
                        ? const [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: AppColors.danger),
                            ),
                          ]
                        : [],
                  ),
                ),
              ),
            ),
            // Input column — expands
            Expanded(child: child),
          ],
        ),
        if (!isLast)
          const Divider(height: 1, color: AppColors.slate100),
      ],
    );
  }
}

// ── Error row ────────────────────────────────────────────────────────────────

class _ErrorRow extends StatelessWidget {
  const _ErrorRow({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.error_outline, color: AppColors.danger, size: 15),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: AppColors.danger,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Submit button ─────────────────────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label),
      ),
    );
  }
}
