import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../domain/entities/variant.dart';
import '../../domain/usecases/create_variant.dart';
import '../../domain/usecases/delete_variant_image.dart';
import '../../domain/usecases/update_variant.dart';
import '../../domain/usecases/upload_variant_image.dart';
import '../providers/product_detail_provider.dart';
import '../providers/product_list_provider.dart';
import '../widgets/variant_image_grid.dart';

part 'variant_form_screen.g.dart';

// ── Local providers ────────────────────────────────────────────────────────────

@riverpod
CreateVariant createVariantUseCase(Ref ref) =>
    CreateVariant(ref.watch(productRepositoryProvider));

@riverpod
UpdateVariant updateVariantUseCase(Ref ref) =>
    UpdateVariant(ref.watch(productRepositoryProvider));

@riverpod
UploadVariantImage uploadVariantImageUseCase(Ref ref) =>
    UploadVariantImage(ref.watch(productRepositoryProvider));

@riverpod
DeleteVariantImage deleteVariantImageUseCase(Ref ref) =>
    DeleteVariantImage(ref.watch(productRepositoryProvider));

// ── Screen ─────────────────────────────────────────────────────────────────────

/// Variant create/edit form screen.
class VariantFormScreen extends ConsumerStatefulWidget {
  const VariantFormScreen({
    super.key,
    required this.productId,
    required this.variantId,
  });

  final String productId;
  final String? variantId;

  @override
  ConsumerState<VariantFormScreen> createState() => _VariantFormScreenState();
}

class _VariantFormScreenState extends ConsumerState<VariantFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _sizeCtrl;
  late final TextEditingController _colorCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _weightCtrl;

  bool _isLoading = false;
  String? _errorMessage;
  Variant? _existingVariant;
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    _sizeCtrl = TextEditingController();
    _colorCtrl = TextEditingController();
    _priceCtrl = TextEditingController();
    _stockCtrl = TextEditingController();
    _weightCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _sizeCtrl.dispose();
    _colorCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  void _prefillIfNeeded() {
    if (_prefilled || widget.variantId == null) return;
    final productAsync =
        ref.watch(productDetailProvider(widget.productId));
    productAsync.whenData((product) {
      if (!_prefilled) {
        final variant = product.variants
            .where((v) => v.id == widget.variantId)
            .firstOrNull;
        if (variant != null) {
          _prefilled = true;
          _existingVariant = variant;
          _sizeCtrl.text = variant.size ?? '';
          _colorCtrl.text = variant.color ?? '';
          _priceCtrl.text = variant.priceOverride?.toString() ?? '';
          _stockCtrl.text = variant.stockQuantity.toString();
          _weightCtrl.text = variant.weightGrams?.toString() ?? '';
        }
      }
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final size =
        _sizeCtrl.text.trim().isEmpty ? null : _sizeCtrl.text.trim();
    final color =
        _colorCtrl.text.trim().isEmpty ? null : _colorCtrl.text.trim();
    final priceOverride = _priceCtrl.text.trim().isEmpty
        ? null
        : double.tryParse(_priceCtrl.text.trim());
    final stock = int.tryParse(_stockCtrl.text.trim()) ?? 0;
    final weight = _weightCtrl.text.trim().isEmpty
        ? null
        : int.tryParse(_weightCtrl.text.trim());

    if (widget.variantId != null) {
      final useCase = ref.read(updateVariantUseCaseProvider);
      final result = await useCase(
        id: widget.variantId!,
        size: size,
        color: color,
        priceOverride: priceOverride,
        stockQuantity: stock,
        weightGrams: weight,
      );
      result.fold(
        (f) => setState(() {
          _isLoading = false;
          _errorMessage = f.message;
        }),
        (_) {
          ref.invalidate(productDetailProvider(widget.productId));
          ref.invalidate(productListProvider);
          if (mounted) context.pop();
        },
      );
    } else {
      final useCase = ref.read(createVariantUseCaseProvider);
      final result = await useCase(
        productId: widget.productId,
        size: size,
        color: color,
        priceOverride: priceOverride,
        stockQuantity: stock,
        weightGrams: weight,
      );
      result.fold(
        (f) => setState(() {
          _isLoading = false;
          _errorMessage = f.message;
        }),
        (_) {
          ref.invalidate(productDetailProvider(widget.productId));
          ref.invalidate(productListProvider);
          if (mounted) context.pop();
        },
      );
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (_existingVariant == null) return;
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null || !mounted) return;

    setState(() => _isLoading = true);
    final useCase = ref.read(uploadVariantImageUseCaseProvider);
    final result = await useCase(
      variantId: _existingVariant!.id,
      imageFile: File(picked.path),
      isPrimary: _existingVariant!.images.isEmpty,
    );
    result.fold(
      (f) => setState(() {
        _isLoading = false;
        _errorMessage = f.message;
      }),
      (_) {
        ref.invalidate(productDetailProvider(widget.productId));
        setState(() => _isLoading = false);
      },
    );
  }

  Future<void> _deleteImage(String imageId) async {
    setState(() => _isLoading = true);
    final useCase = ref.read(deleteVariantImageUseCaseProvider);
    final result = await useCase(imageId);
    result.fold(
      (f) => setState(() {
        _isLoading = false;
        _errorMessage = f.message;
      }),
      (_) {
        ref.invalidate(productDetailProvider(widget.productId));
        setState(() => _isLoading = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _prefillIfNeeded();

    // Re-read variant from provider state after image uploads
    if (widget.variantId != null) {
      ref.watch(productDetailProvider(widget.productId)).whenData((p) {
        _existingVariant =
            p.variants.where((v) => v.id == widget.variantId).firstOrNull;
      });
    }

    final isEditing = widget.variantId != null;
    final maxWidth = context.responsiveValue<double>(
      mobile: double.infinity,
      tablet: 600,
      desktop: 640,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Variant' : 'New Variant'),
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
                if (isEditing && _existingVariant != null) ...[
                  _SectionTitle(title: 'SKU (auto-generated)'),
                  const SizedBox(height: 8),
                  _ReadOnlyField(value: _existingVariant!.sku),
                  const SizedBox(height: 24),
                ],
                _SectionTitle(title: 'Attributes'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel(label: 'Size'),
                          TextFormField(
                            controller: _sizeCtrl,
                            textInputAction: TextInputAction.next,
                            decoration:
                                const InputDecoration(hintText: 'e.g. M, L, XL'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel(label: 'Color'),
                          TextFormField(
                            controller: _colorCtrl,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                hintText: 'e.g. Black, White'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SectionTitle(title: 'Pricing & Stock'),
                const SizedBox(height: 12),
                const _FieldLabel(label: 'Price Override (MMK)'),
                TextFormField(
                  controller: _priceCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Leave empty to use base price',
                    prefixText: 'K ',
                  ),
                  validator: (v) =>
                      v != null && v.isNotEmpty ? Validators.positiveNumber(v) : null,
                ),
                const SizedBox(height: 16),
                const _FieldLabel(label: 'Stock Quantity *'),
                TextFormField(
                  controller: _stockCtrl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(hintText: '0'),
                  validator: (v) =>
                      Validators.positiveInt(v, fieldName: 'Stock quantity'),
                ),
                const SizedBox(height: 16),
                const _FieldLabel(label: 'Weight (grams)'),
                TextFormField(
                  controller: _weightCtrl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(hintText: 'Optional'),
                  validator: (v) =>
                      v != null && v.isNotEmpty ? Validators.positiveInt(v) : null,
                ),
                if (isEditing && _existingVariant != null) ...[
                  const SizedBox(height: 24),
                  _SectionTitle(title: 'Images'),
                  const SizedBox(height: 12),
                  VariantImageGrid(
                    images: _existingVariant!.images,
                    onAddImage: _pickAndUploadImage,
                    onDeleteImage: _deleteImage,
                  ),
                ],
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _ErrorBanner(message: _errorMessage!),
                ],
                const SizedBox(height: 32),
                AppButton(
                  label: isEditing ? 'Save Changes' : 'Add Variant',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.ghost,
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.slate700,
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

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.slate600,
          fontFamily: 'monospace',
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
