import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/variant_image.dart';
import 'image_status_badges.dart';

class VariantImageTile extends StatelessWidget {
  const VariantImageTile({
    super.key,
    this.uploadedImage,
    this.pendingImage,
    this.isUploading = false,
    this.errorMessage,
    required this.onDelete,
  });

  final VariantImage? uploadedImage;
  final XFile? pendingImage;
  final bool isUploading;
  final String? errorMessage;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (uploadedImage != null) {
      imageWidget = Image.network(
        uploadedImage!.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (pendingImage != null) {
      imageWidget = Image.file(
        File(pendingImage!.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      imageWidget = const Icon(Icons.image, color: AppColors.slate400);
    }

    Widget badge;
    if (errorMessage != null) {
      badge = FailedImageBadge(error: errorMessage!);
    } else if (isUploading) {
      badge = const UploadingImageBadge();
    } else if (pendingImage != null) {
      badge = const PendingImageBadge();
    } else {
      badge = const UploadedImageBadge();
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.slate200),
          ),
          clipBehavior: Clip.antiAlias,
          child: imageWidget,
        ),
        Positioned(
          top: 4,
          left: 4,
          child: badge,
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: AppColors.slate700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
