import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../entities/variant_image.dart';
import '../repositories/variant_image_repository.dart';

/// Uploads an image file and attaches it to a variant.
class UploadVariantImage {
  const UploadVariantImage(this._repository);

  final VariantImageRepository _repository;

  Future<Either<Failure, VariantImage>> call({
    required String variantId,
    required String shopId,
    required XFile imageFile,
    required bool isPrimary,
  }) async {
    final uploadResult = await _repository.uploadFile(
      imageFile,
      variantId: variantId,
      shopId: shopId,
    );
    
    return uploadResult.fold(
      (failure) async => left(failure),
      (url) async => await _repository.attachImage(
        variantId: variantId,
        imageUrl: url,
        isPrimary: isPrimary,
      ),
    );
  }
}
