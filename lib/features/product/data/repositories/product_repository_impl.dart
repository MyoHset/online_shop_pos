import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/variant.dart';
import '../../domain/entities/variant_detail.dart';
import '../../domain/entities/variant_image.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

/// Concrete implementation of [ProductRepository].
///
/// Catches all internal exceptions from [ProductRemoteDataSource] and
/// maps them to the appropriate [Failure] subtype before returning.
/// No exceptions ever cross this boundary into the domain layer.
class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._dataSource);

  final ProductRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await _dataSource.getCategories();
      return right(categories);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getBrands() async {
    try {
      final brands = await _dataSource.getBrands();
      return right(brands);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSizes() async {
    try {
      final sizes = await _dataSource.getSizes();
      return right(sizes);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VariantDetail>>> browseForCustomer({
    String? category,
    String? brand,
    String? size,
    int limit = 30,
  }) async {
    try {
      final models = await _dataSource.browseForCustomer(
        category: category,
        brand: brand,
        size: size,
        limit: limit,
      );
      return right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    String? searchQuery,
    String? category,
    String? brand,
    String? shopId,
    int page = 0,
    int pageSize = 30,
  }) async {
    try {
      final models = await _dataSource.getProducts(
        searchQuery: searchQuery,
        category: category,
        brand: brand,
        shopId: shopId,
        page: page,
        pageSize: pageSize,
      );
      return right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final model = await _dataSource.getProductById(id);
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct({
    required String name,
    String? description,
    required double basePrice,
    String? category,
    String? brand,
    String? productCode,
    String? shopId,
  }) async {
    try {
      final model = await _dataSource.createProduct(
        name: name,
        description: description,
        basePrice: basePrice,
        category: category,
        brand: brand,
        productCode: productCode,
        shopId: shopId,
      );
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct({
    required String id,
    String? name,
    String? description,
    double? basePrice,
    String? category,
    String? brand,
    String? productCode,
    bool? isActive,
  }) async {
    try {
      final model = await _dataSource.updateProduct(
        id: id,
        name: name,
        description: description,
        basePrice: basePrice,
        category: category,
        brand: brand,
        productCode: productCode,
        isActive: isActive,
      );
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Variant>> createVariant({
    required String productId,
    String? size,
    String? color,
    double? priceOverride,
    required int stockQuantity,
    int? weightGrams,
  }) async {
    try {
      final model = await _dataSource.createVariant(
        productId: productId,
        size: size,
        color: color,
        priceOverride: priceOverride,
        stockQuantity: stockQuantity,
        weightGrams: weightGrams,
      );
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Variant>> updateVariant({
    required String id,
    String? size,
    String? color,
    double? priceOverride,
    int? stockQuantity,
    int? weightGrams,
    bool? isActive,
  }) async {
    try {
      final model = await _dataSource.updateVariant(
        id: id,
        size: size,
        color: color,
        priceOverride: priceOverride,
        stockQuantity: stockQuantity,
        weightGrams: weightGrams,
        isActive: isActive,
      );
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VariantImage>>> getVariantImages(String variantId) async {
    try {
      final models = await _dataSource.getVariantImages(variantId);
      return right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

}
