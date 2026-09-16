import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/variant_image.dart';
import '../../domain/repositories/variant_image_repository.dart';
import '../datasources/variant_image_remote_datasource.dart';

class VariantImageRepositoryImpl implements VariantImageRepository {
  const VariantImageRepositoryImpl(this._remoteDataSource);

  final VariantImageRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, String>> uploadFile(
    XFile file, {
    required String variantId,
    required String shopId,
  }) async {
    try {
      final url = await _remoteDataSource.uploadFile(
        File(file.path),
        variantId: variantId,
        shopId: shopId,
      );
      return right(url);
    } on ImageUploadException catch (e) {
      return left(ServerFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VariantImage>> attachImage({
    required String variantId,
    required String imageUrl,
    required bool isPrimary,
  }) async {
    try {
      final model = await _remoteDataSource.attachImage(
        variantId: variantId,
        imageUrl: imageUrl,
        isPrimary: isPrimary,
      );
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteImage(String imageId) async {
    try {
      await _remoteDataSource.deleteImage(imageId);
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
