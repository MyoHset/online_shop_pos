import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Generic loading state placeholder.
///
/// Displays a centred [CircularProgressIndicator] styled consistently with
/// the app's design system. Used in every async screen's loading state branch.
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key, this.message});

  /// Optional message shown below the spinner.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.slate700,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.slate500,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Shimmer-style skeleton placeholder for lists.
///
/// Renders [count] animated skeleton rows of [height] each.
class SkeletonListLoader extends StatefulWidget {
  const SkeletonListLoader({
    super.key,
    this.count = 6,
    this.height = 80,
  });

  final int count;
  final double height;

  @override
  State<SkeletonListLoader> createState() => _SkeletonListLoaderState();
}

class _SkeletonListLoaderState extends State<SkeletonListLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.count,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => AnimatedBuilder(
        animation: _animation,
        builder: (_, __) => _SkeletonRow(
          height: widget.height,
          opacity: 0.4 + (_animation.value * 0.4),
        ),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.height, required this.opacity});

  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.slate200,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
