import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/variant.dart';
import '../repositories/product_repository.dart';

/// Creates a new product variant.
class CreateVariant {
  const CreateVariant(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, Variant>> call({
    required String productId,
    String? size,
    String? color,
    double? priceOverride,
    required int stockQuantity,
    int? weightGrams,
  }) =>
      _repository.createVariant(
        productId: productId,
        size: size,
        color: color,
        priceOverride: priceOverride,
        stockQuantity: stockQuantity,
        weightGrams: weightGrams,
      );
}
