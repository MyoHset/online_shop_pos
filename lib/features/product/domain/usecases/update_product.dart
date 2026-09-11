import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Updates fields on an existing product.
class UpdateProduct {
  const UpdateProduct(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, Product>> call({
    required String id,
    String? name,
    String? description,
    double? basePrice,
    String? category,
    String? brand,
    String? productCode,
    bool? isActive,
  }) =>
      _repository.updateProduct(
        id: id,
        name: name,
        description: description,
        basePrice: basePrice,
        category: category,
        brand: brand,
        productCode: productCode,
        isActive: isActive,
      );
}
