import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Creates a new product record.
class CreateProduct {
  const CreateProduct(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, Product>> call({
    required String name,
    String? description,
    required double basePrice,
    String? category,
    String? brand,
    String? productCode,
  }) =>
      _repository.createProduct(
        name: name,
        description: description,
        basePrice: basePrice,
        category: category,
        brand: brand,
        productCode: productCode,
      );
}
