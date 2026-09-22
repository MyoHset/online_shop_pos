import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';

class StaffDashboardView extends StatelessWidget {
  const StaffDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.point_of_sale,
            size: 64,
            color: AppColors.slate300,
          ),
          const SizedBox(height: 24),
          const Text(
            'Ready for a new sale?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.slate800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start scanning or searching products.',
            style: TextStyle(
              color: AppColors.slate500,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.goNamed('quickSale');
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('New Quick Sale'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.slate900,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
