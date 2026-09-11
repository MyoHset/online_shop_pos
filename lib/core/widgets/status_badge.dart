import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A colour-coded pill badge that pairs a colour with a text label and icon
/// to satisfy accessibility requirements (never colour alone).
///
/// Used for order status, stock status, and payment status throughout the app.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.icon,
    this.size = StatusBadgeSize.medium,
  });

  /// Creates a [StatusBadge] with [AppColors.success] styling.
  const StatusBadge.success({
    super.key,
    required this.label,
    this.icon = const Icon(Icons.check_circle_outline_rounded, size: 14),
    this.size = StatusBadgeSize.medium,
  })  : color = AppColors.success,
        backgroundColor = AppColors.successBg;

  /// Creates a [StatusBadge] with [AppColors.warning] styling.
  const StatusBadge.warning({
    super.key,
    required this.label,
    this.icon = const Icon(Icons.warning_amber_rounded, size: 14),
    this.size = StatusBadgeSize.medium,
  })  : color = AppColors.warning,
        backgroundColor = AppColors.warningBg;

  /// Creates a [StatusBadge] with [AppColors.danger] styling.
  const StatusBadge.danger({
    super.key,
    required this.label,
    this.icon = const Icon(Icons.cancel_outlined, size: 14),
    this.size = StatusBadgeSize.medium,
  })  : color = AppColors.danger,
        backgroundColor = AppColors.dangerBg;

  /// Creates a [StatusBadge] with [AppColors.info] styling.
  const StatusBadge.info({
    super.key,
    required this.label,
    this.icon = const Icon(Icons.info_outline_rounded, size: 14),
    this.size = StatusBadgeSize.medium,
  })  : color = AppColors.info,
        backgroundColor = AppColors.infoBg;

  final String label;
  final Color color;
  final Color backgroundColor;
  final Widget? icon;
  final StatusBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final fontSize = size == StatusBadgeSize.small ? 11.0 : 12.0;
    final padding = size == StatusBadgeSize.small
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 3)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
    final iconSize = size == StatusBadgeSize.small ? 12.0 : 14.0;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(color: color, size: iconSize),
              child: icon!,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Controls the visual size of [StatusBadge].
enum StatusBadgeSize { small, medium }
