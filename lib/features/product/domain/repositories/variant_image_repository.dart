import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/failures.dart';
import '../entities/variant_image.dart';

abstract interface class VariantImageRepository {
  /// Uploads a raw file to Supabase Storage and returns the public URL.
  Future<Either<Failure, String>> uploadFile(
    XFile file, {
    required String variantId,
    required String shopId,
  });

  /// Inserts a new row in the variant_images table.
  Future<Either<Failure, VariantImage>> attachImage({
    required String variantId,
    required String imageUrl,
    required bool isPrimary,
  });

  /// Deletes an image record and its corresponding file in Storage.
  Future<Either<Failure, void>> deleteImage(String imageId);
}
