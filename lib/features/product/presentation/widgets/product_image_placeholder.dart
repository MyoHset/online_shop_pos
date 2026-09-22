import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ProductImagePlaceholder extends StatelessWidget {
  const ProductImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate100,
      child: const Center(
        child: Icon(Icons.image_outlined, color: AppColors.slate300, size: 40),
      ),
    );
  }
}
