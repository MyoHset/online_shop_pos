import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/supabase_client_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/variant_image_remote_datasource.dart';
import '../../data/repositories/variant_image_repository_impl.dart';
import '../../domain/entities/variant_image.dart';
import '../../domain/repositories/variant_image_repository.dart';

part 'variant_image_provider.g.dart';

@riverpod
VariantImageRepository variantImageRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return VariantImageRepositoryImpl(VariantImageRemoteDataSource(client));
}

class VariantImageState {
  const VariantImageState({
    this.pendingImages = const [],
    this.uploadedImages = const [],
    this.isUploading = false,
    this.errorMessages = const {}, // mapping path -> error message
  });

  final List<XFile> pendingImages;
  final List<VariantImage> uploadedImages;
  final bool isUploading;
  final Map<String, String> errorMessages;

  VariantImageState copyWith({
    List<XFile>? pendingImages,
    List<VariantImage>? uploadedImages,
    bool? isUploading,
    Map<String, String>? errorMessages,
  }) {
    return VariantImageState(
      pendingImages: pendingImages ?? this.pendingImages,
      uploadedImages: uploadedImages ?? this.uploadedImages,
      isUploading: isUploading ?? this.isUploading,
      errorMessages: errorMessages ?? this.errorMessages,
    );
  }
}

@riverpod
class VariantImageController extends _$VariantImageController {
  @override
  VariantImageState build() {
    return const VariantImageState();
  }

  void initializeWith(List<VariantImage> existingImages) {
    state = state.copyWith(uploadedImages: existingImages);
  }

  Future<void> onImagePicked(XFile file, {String? variantId}) async {
    if (variantId == null) {
      // Local cache mode
      state = state.copyWith(pendingImages: [...state.pendingImages, file]);
    } else {
      // Immediate upload mode
      state = state.copyWith(isUploading: true);
      final repo = ref.read(variantImageRepositoryProvider);
      final shopId = ref.read(authControllerProvider).value?.shopId ?? 'unknown';

      final uploadResult = await repo.uploadFile(file, variantId: variantId, shopId: shopId);
      await uploadResult.match(
        (failure) async {
          final errs = Map<String, String>.from(state.errorMessages);
          errs[file.path] = failure.message;
          state = state.copyWith(errorMessages: errs, isUploading: false);
        },
        (url) async {
          final attachResult = await repo.attachImage(
            variantId: variantId,
            imageUrl: url,
            isPrimary: state.uploadedImages.isEmpty,
          );
          attachResult.match(
            (failure) {
              final errs = Map<String, String>.from(state.errorMessages);
              errs[file.path] = failure.message;
              state = state.copyWith(errorMessages: errs, isUploading: false);
            },
            (image) {
              state = state.copyWith(
                uploadedImages: [...state.uploadedImages, image],
                isUploading: false,
              );
            },
          );
        },
      );
    }
  }

  void removePendingImage(XFile file) {
    state = state.copyWith(
      pendingImages: state.pendingImages.where((f) => f.path != file.path).toList(),
    );
  }

  Future<void> removeUploadedImage(String imageId) async {
    state = state.copyWith(isUploading: true);
    final repo = ref.read(variantImageRepositoryProvider);
    final result = await repo.deleteImage(imageId);
    
    result.match(
      (failure) {
        // Just stop loading and maybe show an error in UI
        state = state.copyWith(isUploading: false);
      },
      (_) {
        state = state.copyWith(
          uploadedImages: state.uploadedImages.where((i) => i.id != imageId).toList(),
          isUploading: false,
        );
      },
    );
  }

  Future<void> flushPendingImagesTo(String newVariantId) async {
    final repo = ref.read(variantImageRepositoryProvider);
    final shopId = ref.read(authControllerProvider).value?.shopId ?? 'unknown';

    for (final file in state.pendingImages) {
      final uploadResult = await repo.uploadFile(file, variantId: newVariantId, shopId: shopId);
      await uploadResult.match(
        (failure) async {
          final errs = Map<String, String>.from(state.errorMessages);
          errs[file.path] = failure.message;
          state = state.copyWith(errorMessages: errs);
        },
        (url) async {
          await repo.attachImage(
            variantId: newVariantId,
            imageUrl: url,
            isPrimary: state.uploadedImages.isEmpty,
          );
          // Note: we don't necessarily need to add to state.uploadedImages 
          // here because the form is closing/refreshing, but it's good practice
        },
      );
    }
    
    // Clear pending
    state = state.copyWith(pendingImages: []);
  }
}
