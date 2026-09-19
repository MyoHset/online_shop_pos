import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.status,
    required this.count,
    this.onTap,
    super.key,
  });

  final String status;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    Color textColor;
    
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'pending') {
      chipColor = AppColors.infoBg;
      textColor = AppColors.info;
    } else if (lowerStatus == 'confirmed' || lowerStatus == 'packed' || lowerStatus == 'shipped') {
      chipColor = AppColors.infoBg;
      textColor = AppColors.info;
    } else if (lowerStatus == 'delivered') {
      chipColor = AppColors.successBg;
      textColor = AppColors.success;
    } else if (lowerStatus == 'cancelled') {
      chipColor = AppColors.dangerBg;
      textColor = AppColors.danger;
    } else {
      chipColor = AppColors.slate100;
      textColor = AppColors.slate700;
    }

    // Grey out if count is zero
    if (count == 0) {
      chipColor = AppColors.slate100;
      textColor = AppColors.slate500;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: textColor.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status.toUpperCase(),
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: textColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
