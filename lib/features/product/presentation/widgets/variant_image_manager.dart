import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/variant_image_provider.dart';
import 'variant_image_tile.dart';

class VariantImageManager extends ConsumerWidget {
  const VariantImageManager({
    required this.variantId,
    required this.onPendingImagesChanged,
    super.key,
  });

  final String? variantId;
  final ValueChanged<List<XFile>> onPendingImagesChanged;

  Future<void> _pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    await ref.read(variantImageControllerProvider.notifier).onImagePicked(picked, variantId: variantId);
    
    // Notify parent if we are in local cache mode
    if (variantId == null) {
      final pending = ref.read(variantImageControllerProvider).pendingImages;
      onPendingImagesChanged(pending);
    }
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, String imageId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Image'),
        content: const Text('Are you sure you want to delete this image? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(variantImageControllerProvider.notifier).removeUploadedImage(imageId);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(variantImageControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: state.uploadedImages.length + state.pendingImages.length + 1,
          itemBuilder: (context, index) {
            // "Add Image" button is the last item
            if (index == state.uploadedImages.length + state.pendingImages.length) {
              return GestureDetector(
                onTap: () => _pickImage(ref),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.slate100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.slate300, style: BorderStyle.solid),
                  ),
                  child: const Center(
                    child: Icon(Icons.add_photo_alternate, size: 32, color: AppColors.slate500),
                  ),
                ),
              );
            }

            if (index < state.uploadedImages.length) {
              final image = state.uploadedImages[index];
              return VariantImageTile(
                uploadedImage: image,
                onDelete: () => _showDeleteConfirmation(context, ref, image.id),
              );
            }

            final pendingIndex = index - state.uploadedImages.length;
            final pendingFile = state.pendingImages[pendingIndex];
            final errorMsg = state.errorMessages[pendingFile.path];
            // In immediate upload mode, if there are pending images, it means they are currently uploading
            final isUploading = variantId != null && state.isUploading;

            return VariantImageTile(
              pendingImage: pendingFile,
              isUploading: isUploading,
              errorMessage: errorMsg,
              onDelete: () {
                ref.read(variantImageControllerProvider.notifier).removePendingImage(pendingFile);
                if (variantId == null) {
                  final pending = ref.read(variantImageControllerProvider).pendingImages;
                  onPendingImagesChanged(pending);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
