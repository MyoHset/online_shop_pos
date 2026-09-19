import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';

class StockMatrixEmptyCell extends StatelessWidget {
  const StockMatrixEmptyCell({
    required this.productId,
    required this.size,
    required this.color,
    super.key,
  });

  final String productId;
  final String size;
  final String color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          'variantNew',
          pathParameters: {'id': productId},
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        color: AppColors.slate50,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '-',
              style: TextStyle(
                color: AppColors.slate400,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.add_outlined, size: 14, color: AppColors.slate400),
          ],
        ),
      ),
    );
  }
}
