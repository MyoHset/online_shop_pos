import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PendingImageBadge extends StatelessWidget {
  const PendingImageBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Pending save',
        style: TextStyle(
          color: AppColors.warning,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class UploadingImageBadge extends StatelessWidget {
  const UploadingImageBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.info),
          ),
          SizedBox(width: 4),
          Text(
            'Uploading...',
            style: TextStyle(
              color: AppColors.info,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class UploadedImageBadge extends StatelessWidget {
  const UploadedImageBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.successBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Uploaded',
        style: TextStyle(
          color: AppColors.success,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class FailedImageBadge extends StatelessWidget {
  const FailedImageBadge({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Failed',
        style: TextStyle(
          color: AppColors.danger,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
