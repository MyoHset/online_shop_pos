import 'dart:math' as math;
import 'package:flutter/material.dart';

enum BackgroundPatternStyle { dots, squares, grid }

class AnimatedMeshBackground extends StatefulWidget {
  const AnimatedMeshBackground({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.patternStyle = BackgroundPatternStyle.dots,
    this.backgroundColor = const Color(0xFF09090B),
    this.enableAnimation = true,
  });

  final Widget child;
  final double borderRadius;
  final BackgroundPatternStyle patternStyle;
  final Color backgroundColor;
  final bool enableAnimation;

  @override
  State<AnimatedMeshBackground> createState() => _AnimatedMeshBackgroundState();
}

class _AnimatedMeshBackgroundState extends State<AnimatedMeshBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    if (widget.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableAnimation) {
      return CustomPaint(
        painter: _TechPatternPainter(
          progress: 0.5,
          patternStyle: widget.patternStyle,
          backgroundColor: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          enableAnimation: false,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: widget.child,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _TechPatternPainter(
            progress: _controller.value,
            patternStyle: widget.patternStyle,
            backgroundColor: widget.backgroundColor,
            borderRadius: widget.borderRadius,
            enableAnimation: true,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: widget.child,
          ),
        );
      },
    );
  }
}


class _TechPatternPainter extends CustomPainter {
  _TechPatternPainter({
    required this.progress,
    required this.patternStyle,
    required this.backgroundColor,
    required this.borderRadius,
    required this.enableAnimation,
  });

  final double progress;
  final BackgroundPatternStyle patternStyle;
  final Color backgroundColor;
  final double borderRadius;
  final bool enableAnimation;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // 1. Draw solid dark background base
    canvas.drawRRect(rrect, Paint()..color = backgroundColor);

    final t = progress * 2 * math.pi;

    // 2. Draw Grid/Dots/Squares Pattern
    const step = 32.0;
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final cols = (size.width / step).ceil();
    final rows = (size.height / step).ceil();

    for (int i = 0; i <= cols; i++) {
      for (int j = 0; j <= rows; j++) {
        final x = i * step;
        final y = j * step;

        // Calculate distance pulse from dynamic wave center
        final dx = x - (size.width * 0.5 + math.sin(t) * 100);
        final dy = y - (size.height * 0.5 + math.cos(t * 0.7) * 100);
        final dist = math.sqrt(dx * dx + dy * dy);

        final waveOpacity = enableAnimation ? (math.sin(t * 2 + dist * 0.015) + 1) / 2 : 0.5;
        final alpha = (0.1 + waveOpacity * 0.45).clamp(0.0, 1.0);

        if (patternStyle == BackgroundPatternStyle.dots) {
          final radius = 1.5 + waveOpacity * 1.5;
          dotPaint.color = Color.lerp(
            const Color(0xFF818CF8), // Light Indigo
            const Color(0xFF38BDF8), // Light Cyan
            waveOpacity,
          )!.withValues(alpha: alpha);

          canvas.drawCircle(Offset(x, y), radius, dotPaint);
        } else if (patternStyle == BackgroundPatternStyle.squares) {
          final squareSize = 3.0 + waveOpacity * 3.0;
          dotPaint.color = Color.lerp(
            const Color(0xFFA78BFA),
            const Color(0xFF38BDF8),
            waveOpacity,
          )!.withValues(alpha: alpha * 0.85);

          canvas.drawRect(
            Rect.fromCenter(center: Offset(x, y), width: squareSize, height: squareSize),
            dotPaint,
          );
        } else {
          // Grid lines
          linePaint.color = const Color(0xFF818CF8).withValues(alpha: alpha * 0.2);
          canvas.drawRect(Rect.fromLTWH(x, y, step, step), linePaint);
        }
      }
    }

    // 4. Draw Lighter Border (Static or Animated Glow)
    if (borderRadius > 0) {
      if (enableAnimation) {
        final borderAngle = t;
        final borderGradient = SweepGradient(
          transform: GradientRotation(borderAngle),
          colors: const [
            Color(0xFF818CF8), // Light Indigo
            Color(0xFFC084FC), // Light Purple
            Color(0xFF38BDF8), // Light Cyan
            Color(0xFFF472B6), // Light Pink
            Color(0xFF818CF8),
          ],
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        );

        final borderPaint = Paint()
          ..shader = borderGradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        canvas.drawRRect(rrect, borderPaint);
      } else {
        final borderPaint = Paint()
          ..color = const Color(0xFF27272A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

        canvas.drawRRect(rrect, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TechPatternPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.patternStyle != patternStyle ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.enableAnimation != enableAnimation;
  }
}


