import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A reusable custom AppBar component for common use across the app.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor = Colors.white,
    this.elevation = 0,
    this.bottom,
  });

  /// A custom widget for the title. Overrides [titleText] if provided.
  final Widget? title;

  /// A simple string title. Used if [title] is null.
  final String? titleText;

  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color backgroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title ??
          (titleText != null
              ? Text(
                  titleText!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                )
              : null),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      backgroundColor: backgroundColor,
      elevation: elevation,
      iconTheme: const IconThemeData(color: AppColors.slate900),
      bottom: bottom,
      surfaceTintColor: Colors.transparent, // Prevents Material 3 tinting
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
