import 'package:flutter/material.dart';
import 'product_image_placeholder.dart';
import 'product_image_loading_indicator.dart';

class ProductThumbnail extends StatelessWidget {
  const ProductThumbnail({required this.imageUrl, super.key});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const ProductImagePlaceholder();
    }
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const ProductImageLoadingIndicator();
        },
        errorBuilder: (_, __, ___) => const ProductImagePlaceholder(),
      ),
    );
  }
}
