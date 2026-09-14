// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(createProductUseCase)
const createProductUseCaseProvider = CreateProductUseCaseProvider._();

final class CreateProductUseCaseProvider
    extends $FunctionalProvider<CreateProduct, CreateProduct, CreateProduct>
    with $Provider<CreateProduct> {
  const CreateProductUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'createProductUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$createProductUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateProduct> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateProduct create(Ref ref) {
    return createProductUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateProduct value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateProduct>(value),
    );
  }
}

String _$createProductUseCaseHash() =>
    r'72ea218836e09cf2d622093d9707805104eeb72f';

@ProviderFor(updateProductUseCase)
const updateProductUseCaseProvider = UpdateProductUseCaseProvider._();

final class UpdateProductUseCaseProvider
    extends $FunctionalProvider<UpdateProduct, UpdateProduct, UpdateProduct>
    with $Provider<UpdateProduct> {
  const UpdateProductUseCaseProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'updateProductUseCaseProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$updateProductUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateProduct> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateProduct create(Ref ref) {
    return updateProductUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateProduct value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateProduct>(value),
    );
  }
}

String _$updateProductUseCaseHash() =>
    r'4d41ec399c94afc86ad06d4fd00c7ac43e9de77f';

/// Manages form state for product create/edit.

@ProviderFor(ProductForm)
const productFormProvider = ProductFormProvider._();

/// Manages form state for product create/edit.
final class ProductFormProvider
    extends $NotifierProvider<ProductForm, ProductFormData> {
  /// Manages form state for product create/edit.
  const ProductFormProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productFormProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productFormHash();

  @$internal
  @override
  ProductForm create() => ProductForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductFormData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductFormData>(value),
    );
  }
}

String _$productFormHash() => r'b41eb4e0f10ab11fd3efb688385329991dfde157';

/// Manages form state for product create/edit.

abstract class _$ProductForm extends $Notifier<ProductFormData> {
  ProductFormData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ProductFormData, ProductFormData>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ProductFormData, ProductFormData>,
        ProductFormData,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
