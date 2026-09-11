import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Retrieves a single product with all its variants and images.
class GetProductDetail {
  const GetProductDetail(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, Product>> call(String productId) =>
      _repository.getProductById(productId);
}
