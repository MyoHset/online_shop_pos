import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/variant_image_repository.dart';

/// Deletes a variant image record and its storage object.
class DeleteVariantImage {
  const DeleteVariantImage(this._repository);

  final VariantImageRepository _repository;

  Future<Either<Failure, void>> call(String imageId) =>
      _repository.deleteImage(imageId);
}
