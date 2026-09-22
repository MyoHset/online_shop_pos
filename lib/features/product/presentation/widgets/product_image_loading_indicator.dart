import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ProductImageLoadingIndicator extends StatelessWidget {
  const ProductImageLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate50,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.slate300,
          ),
        ),
      ),
    );
  }
}
