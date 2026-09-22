import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../entities/variant.dart';
import '../entities/variant_image.dart';
import '../entities/variant_detail.dart';

/// Abstract repository interface for product and variant operations.
///
/// All methods return [Either<Failure, T>] — domain code never throws.
/// The concrete implementation lives in the data layer.
abstract interface class ProductRepository {
  /// Returns a paginated list of active products with their variants.
  Future<Either<Failure, List<Product>>> getProducts({
    String? searchQuery,
    String? category,
    String? brand,
    String? shopId,
    int page = 0,
    int pageSize = 30,
  });

  /// Returns a list of distinct categories for the current shop.
  Future<Either<Failure, List<String>>> getCategories();

  /// Returns a list of distinct brands for the current shop.
  Future<Either<Failure, List<String>>> getBrands();

  /// Returns a list of distinct sizes for the current shop.
  Future<Either<Failure, List<String>>> getSizes();

  /// Returns a curated list of in-stock variants for customer browsing.
  Future<Either<Failure, List<VariantDetail>>> browseForCustomer({
    String? category,
    String? brand,
    String? size,
    int limit = 30,
  });

  /// Returns a single product with all its variants and variant images.
  Future<Either<Failure, Product>> getProductById(String id);

  /// Creates a new product. Returns the created [Product] with its server-assigned id.
  Future<Either<Failure, Product>> createProduct({
    required String name,
    String? description,
    required double basePrice,
    String? category,
    String? brand,
    String? productCode,
    String? shopId,
  });

  /// Updates an existing product's fields.
  Future<Either<Failure, Product>> updateProduct({
    required String id,
    String? name,
    String? description,
    double? basePrice,
    String? category,
    String? brand,
    String? productCode,
    bool? isActive,
  });

  /// Creates a new variant for [productId].
  Future<Either<Failure, Variant>> createVariant({
    required String productId,
    String? size,
    String? color,
    double? priceOverride,
    required int stockQuantity,
    int? weightGrams,
  });

  /// Updates an existing variant.
  Future<Either<Failure, Variant>> updateVariant({
    required String id,
    String? size,
    String? color,
    double? priceOverride,
    int? stockQuantity,
    int? weightGrams,
    bool? isActive,
  });

  /// Fetches all images for a specific variant.
  Future<Either<Failure, List<VariantImage>>> getVariantImages(String variantId);
}
