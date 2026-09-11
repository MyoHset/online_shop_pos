import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Button variants supported by [AppButton].
enum AppButtonVariant { primary, secondary, danger, ghost }

/// A standardised, accessible button with loading state support.
///
/// Replaces ad-hoc [ElevatedButton] / [OutlinedButton] usage throughout
/// the app so that styling is consistent and loading behaviour is handled
/// in one place.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.minimumWidth,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final double? minimumWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    return switch (variant) {
      AppButtonVariant.primary => _PrimaryButton(
          label: label,
          onPressed: effectiveOnPressed,
          isLoading: isLoading,
          icon: icon,
          minimumWidth: minimumWidth,
        ),
      AppButtonVariant.secondary => _SecondaryButton(
          label: label,
          onPressed: effectiveOnPressed,
          isLoading: isLoading,
          icon: icon,
          minimumWidth: minimumWidth,
        ),
      AppButtonVariant.danger => _DangerButton(
          label: label,
          onPressed: effectiveOnPressed,
          isLoading: isLoading,
          icon: icon,
          minimumWidth: minimumWidth,
        ),
      AppButtonVariant.ghost => _GhostButton(
          label: label,
          onPressed: effectiveOnPressed,
          isLoading: isLoading,
          icon: icon,
        ),
    };
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.isLoading,
    required this.color,
    this.icon,
  });

  final String label;
  final bool isLoading;
  final Color color;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: color,
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }
    return Text(label);
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
    this.minimumWidth,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? minimumWidth;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: minimumWidth != null
            ? Size(minimumWidth!, 48)
            : const Size(0, 48),
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        color: Colors.white,
        icon: icon,
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
    this.minimumWidth,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? minimumWidth;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: minimumWidth != null
            ? Size(minimumWidth!, 48)
            : const Size(0, 48),
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        color: AppColors.slate700,
        icon: icon,
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  const _DangerButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
    this.minimumWidth,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? minimumWidth;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.danger,
        foregroundColor: Colors.white,
        minimumSize: minimumWidth != null
            ? Size(minimumWidth!, 48)
            : const Size(0, 48),
      ),
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        color: Colors.white,
        icon: icon,
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
        color: AppColors.slate600,
        icon: icon,
      ),
    );
  }
}
