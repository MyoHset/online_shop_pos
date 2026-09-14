import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/update_product.dart';
import 'product_list_provider.dart';

part 'product_form_provider.g.dart';

@riverpod
CreateProduct createProductUseCase(Ref ref) {
  return CreateProduct(ref.watch(productRepositoryProvider));
}

@riverpod
UpdateProduct updateProductUseCase(Ref ref) {
  return UpdateProduct(ref.watch(productRepositoryProvider));
}

/// Form state for creating or editing a product.
class ProductFormData {
  const ProductFormData({
    this.name = '',
    this.description,
    this.basePrice = 0,
    this.category,
    this.brand,
    this.productCode,
    this.isActive = true,
    this.isLoading = false,
    this.errorMessage,
  });

  final String name;
  final String? description;
  final double basePrice;
  final String? category;
  final String? brand;
  final String? productCode;
  final bool isActive;
  final bool isLoading;
  final String? errorMessage;

  ProductFormData copyWith({
    String? name,
    String? description,
    double? basePrice,
    String? category,
    String? brand,
    String? productCode,
    bool? isActive,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) =>
      ProductFormData(
        name: name ?? this.name,
        description: description ?? this.description,
        basePrice: basePrice ?? this.basePrice,
        category: category ?? this.category,
        brand: brand ?? this.brand,
        productCode: productCode ?? this.productCode,
        isActive: isActive ?? this.isActive,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );
}

/// Manages form state for product create/edit.
@riverpod
class ProductForm extends _$ProductForm {
  @override
  ProductFormData build() => const ProductFormData();

  void prefill(Product product) {
    state = ProductFormData(
      name: product.name,
      description: product.description,
      basePrice: product.basePrice,
      category: product.category,
      brand: product.brand,
      productCode: product.productCode,
      isActive: product.isActive,
    );
  }

  void updateName(String v) => state = state.copyWith(name: v);
  void updateDescription(String v) =>
      state = state.copyWith(description: v.isEmpty ? null : v);
  void updateBasePrice(double v) => state = state.copyWith(basePrice: v);
  void updateCategory(String? v) => state = state.copyWith(category: v);
  void updateBrand(String? v) => state = state.copyWith(brand: v);
  void updateProductCode(String? v) => state = state.copyWith(productCode: v);
  void toggleActive() => state = state.copyWith(isActive: !state.isActive);

  /// Saves the product (create or update) and returns the saved [Product].
  Future<Product?> save({String? existingProductId}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      if (existingProductId != null) {
        final useCase = ref.read(updateProductUseCaseProvider);
        final result = await useCase(
          id: existingProductId,
          name: state.name,
          description: state.description,
          basePrice: state.basePrice,
          category: state.category,
          brand: state.brand,
          productCode: state.productCode,
          isActive: state.isActive,
        );
        final savedProduct = result.fold(
          (f) {
            state = state.copyWith(isLoading: false, errorMessage: f.message);
            return null;
          },
          (product) {
            state = state.copyWith(isLoading: false);
            ref.invalidate(productListProvider);
            return product;
          },
        );
        return savedProduct;
      } else {
        final useCase = ref.read(createProductUseCaseProvider);
        final result = await useCase(
          name: state.name,
          description: state.description,
          basePrice: state.basePrice,
          category: state.category,
          brand: state.brand,
          productCode: state.productCode,
        );
        final savedProduct = result.fold(
          (f) {
            state = state.copyWith(isLoading: false, errorMessage: f.message);
            return null;
          },
          (product) {
            state = state.copyWith(isLoading: false);
            ref.invalidate(productListProvider);
            return product;
          },
        );
        return savedProduct;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return null;
    }
  }
}
