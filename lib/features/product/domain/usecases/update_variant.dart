import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/variant.dart';
import '../repositories/product_repository.dart';

/// Updates an existing variant's fields.
class UpdateVariant {
  const UpdateVariant(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, Variant>> call({
    required String id,
    String? size,
    String? color,
    double? priceOverride,
    int? stockQuantity,
    int? weightGrams,
    bool? isActive,
  }) =>
      _repository.updateVariant(
        id: id,
        size: size,
        color: color,
        priceOverride: priceOverride,
        stockQuantity: stockQuantity,
        weightGrams: weightGrams,
        isActive: isActive,
      );
}
