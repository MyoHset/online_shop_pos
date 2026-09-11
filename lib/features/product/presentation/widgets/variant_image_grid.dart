import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/variant_image.dart';

/// A responsive grid of variant photos with add/delete controls.
class VariantImageGrid extends StatelessWidget {
  const VariantImageGrid({
    super.key,
    required this.images,
    required this.onAddImage,
    this.onDeleteImage,
  });

  final List<VariantImage> images;
  final VoidCallback onAddImage;
  final void Function(String imageId)? onDeleteImage;

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      childrenDelegate: SliverChildListDelegate([
        ...images.map((img) => _ImageTile(
              image: img,
              onDelete: onDeleteImage != null
                  ? () => onDeleteImage!(img.id)
                  : null,
            )),
        _AddImageTile(onTap: onAddImage),
      ]),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({required this.image, this.onDelete});

  final VariantImage image;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: image.isPrimary
                  ? AppColors.info
                  : AppColors.slate200,
              width: image.isPrimary ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            image.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        if (image.isPrimary)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.info,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Primary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (onDelete != null)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
      ],
    );
  }
}

class _AddImageTile extends StatelessWidget {
  const _AddImageTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.slate100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.slate300,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                color: AppColors.slate400, size: 24),
            SizedBox(height: 4),
            Text(
              'Add',
              style: TextStyle(
                color: AppColors.slate400,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
