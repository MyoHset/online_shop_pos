import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Semantic types of [AppSnackBar] notifications.
enum AppSnackBarType {
  success,
  error,
  warning,
  info;

  Color get color => switch (this) {
        AppSnackBarType.success => AppColors.success,
        AppSnackBarType.error => AppColors.danger,
        AppSnackBarType.warning => AppColors.warning,
        AppSnackBarType.info => AppColors.info,
      };

  IconData get icon => switch (this) {
        AppSnackBarType.success => Icons.check_circle_rounded,
        AppSnackBarType.error => Icons.error_outline_rounded,
        AppSnackBarType.warning => Icons.warning_amber_rounded,
        AppSnackBarType.info => Icons.info_outline_rounded,
      };
}

/// A premium, responsive floating snackbar / toast utility designed for
/// consistency across mobile, tablet, and desktop screens.
abstract final class AppSnackBar {
  /// Shows a success snackbar with green accent and checkmark.
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.success,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Shows an error snackbar with red accent and alert icon.
  static void showError(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.error,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Shows a warning snackbar with amber accent.
  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Shows an informational snackbar with blue accent.
  static void showInfo(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.info,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Core display method for [AppSnackBar].
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final screenWidth = MediaQuery.of(context).size.width;
    const maxSnackBarWidth = 440.0;
    final horizontalMargin = screenWidth > (maxSnackBarWidth + 32)
        ? (screenWidth - maxSnackBarWidth) / 2
        : 16.0;

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.fromLTRB(horizontalMargin, 0, horizontalMargin, 16),
      padding: EdgeInsets.zero,
      duration: duration,
      content: _AppSnackBarContent(
        message: message,
        title: title,
        type: type,
        actionLabel: actionLabel,
        onAction: onAction,
        onDismiss: messenger.hideCurrentSnackBar,
      ),
    );

    messenger.showSnackBar(snackBar);
  }
}

class _AppSnackBarContent extends StatelessWidget {
  const _AppSnackBarContent({
    required this.message,
    this.title,
    required this.type,
    this.actionLabel,
    this.onAction,
    required this.onDismiss,
  });

  final String message;
  final String? title;
  final AppSnackBarType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2229),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Semantic Icon with glow/circle container
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: type.color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              type.icon,
              size: 18,
              color: type.color,
            ),
          ),
          const SizedBox(width: 12),

          // Message content
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  message,
                  style: TextStyle(
                    color: title != null ? AppColors.slate300 : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // Optional action
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                onDismiss();
                onAction!();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.greenNude,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],

          // Dismiss button
          const SizedBox(width: 4),
          InkWell(
            onTap: onDismiss,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: AppColors.slate400.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Convenience extensions on [BuildContext] for showing [AppSnackBar].
extension AppSnackBarContextX on BuildContext {
  void showSuccessSnackBar(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    AppSnackBar.showSuccess(
      this,
      message,
      title: title,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  void showErrorSnackBar(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    AppSnackBar.showError(
      this,
      message,
      title: title,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  void showWarningSnackBar(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    AppSnackBar.showWarning(
      this,
      message,
      title: title,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  void showInfoSnackBar(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    AppSnackBar.showInfo(
      this,
      message,
      title: title,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
