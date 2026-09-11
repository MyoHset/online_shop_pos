import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/product_repository.dart';

/// Deletes a variant image record and its storage object.
class DeleteVariantImage {
  const DeleteVariantImage(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, Unit>> call(String imageId) =>
      _repository.deleteVariantImage(imageId);
}
