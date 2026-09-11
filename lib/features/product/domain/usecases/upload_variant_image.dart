import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/variant_image.dart';
import '../repositories/product_repository.dart';

/// Uploads an image file and attaches it to a variant.
class UploadVariantImage {
  const UploadVariantImage(this._repository);

  final ProductRepository _repository;

  Future<Either<Failure, VariantImage>> call({
    required String variantId,
    required File imageFile,
    required bool isPrimary,
  }) =>
      _repository.uploadVariantImage(
        variantId: variantId,
        imageFile: imageFile,
        isPrimary: isPrimary,
      );
}
