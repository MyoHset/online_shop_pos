import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// Retrieves a paginated, optionally filtered list of products.
class GetProducts {
  const GetProducts(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, List<Product>>> call({
    String? searchQuery,
    String? category,
    int page = 0,
    int pageSize = 30,
  }) =>
      _repository.getProducts(
        searchQuery: searchQuery,
        category: category,
        page: page,
        pageSize: pageSize,
      );
}
