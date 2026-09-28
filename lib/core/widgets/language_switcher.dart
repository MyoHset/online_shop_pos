import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/app_locale.dart';
import '../localization/l10n_extensions.dart';
import '../theme/app_theme.dart';

/// Clean custom-painted Myanmar national flag badge.
class MyanmarFlag extends StatelessWidget {
  const MyanmarFlag({
    super.key,
    this.width = 24.0,
    this.height = 16.0,
    this.borderRadius = 3.0,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.12),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 0.5),
        child: CustomPaint(
          size: Size(width, height),
          painter: const _MyanmarFlagPainter(),
        ),
      ),
    );
  }
}

class _MyanmarFlagPainter extends CustomPainter {
  const _MyanmarFlagPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stripeH = size.height / 3;

    // 1. Top Stripe (Yellow)
    final yellowPaint = Paint()..color = const Color(0xFFFECB00);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, stripeH), yellowPaint);

    // 2. Middle Stripe (Green)
    final greenPaint = Paint()..color = const Color(0xFF34B233);
    canvas.drawRect(Rect.fromLTWH(0, stripeH, size.width, stripeH), greenPaint);

    // 3. Bottom Stripe (Red)
    final redPaint = Paint()..color = const Color(0xFFEA2839);
    canvas.drawRect(Rect.fromLTWH(0, stripeH * 2, size.width, stripeH), redPaint);

    // 4. White 5-pointed star
    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerRadius = size.height * 0.36;
    final innerRadius = outerRadius * 0.382;

    final path = Path();
    for (int i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + i * (math.pi / 5);
      final r = i.isEven ? outerRadius : innerRadius;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Clean custom-painted United Kingdom (Union Jack) national flag badge.
class UkFlag extends StatelessWidget {
  const UkFlag({
    super.key,
    this.width = 24.0,
    this.height = 16.0,
    this.borderRadius = 3.0,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.12),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 0.5),
        child: CustomPaint(
          size: Size(width, height),
          painter: const _UkFlagPainter(),
        ),
      ),
    );
  }
}

class _UkFlagPainter extends CustomPainter {
  const _UkFlagPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Blue background
    final bgPaint = Paint()..color = const Color(0xFF012169);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. White saltire (diagonals)
    final whiteSaltirePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.height * 0.24
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), whiteSaltirePaint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), whiteSaltirePaint);

    // 3. Red saltire (diagonals)
    final redSaltirePaint = Paint()
      ..color = const Color(0xFFC8102E)
      ..strokeWidth = size.height * 0.08
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(size.width, size.height), redSaltirePaint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), redSaltirePaint);

    // 4. White central cross
    final whiteCrossPaint = Paint()..color = Colors.white;
    final whiteCrossThickness = size.height * 0.34;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: whiteCrossThickness,
        height: size.height,
      ),
      whiteCrossPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: whiteCrossThickness,
      ),
      whiteCrossPaint,
    );

    // 5. Red central cross (St. George)
    final redCrossPaint = Paint()..color = const Color(0xFFC8102E);
    final redCrossThickness = size.height * 0.20;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: redCrossThickness,
        height: size.height,
      ),
      redCrossPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: redCrossThickness,
      ),
      redCrossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Opens a modal dialog allowing the user to select and confirm a language change.
Future<void> showChangeLanguageDialog(BuildContext context, WidgetRef ref) async {
  final currentLocale = ref.read(appLocaleProvider);
  Locale selectedLocale = currentLocale;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final isBurmese = selectedLocale.languageCode == 'my';

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            elevation: 8,
            titlePadding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
            contentPadding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
            actionsPadding: const EdgeInsets.fromLTRB(22, 16, 22, 18),
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.slate100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.language_rounded,
                    size: 20,
                    color: AppColors.slate800,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.commonLanguage,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 340,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.settingsLanguageSubtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.slate500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Myanmar Option
                  _LanguageOptionCard(
                    flag: const MyanmarFlag(width: 30, height: 20),
                    title: context.l10n.commonLanguageMy,
                    subtitle: 'Burmese (Unicode)',
                    isSelected: isBurmese,
                    onTap: () {
                      setDialogState(() {
                        selectedLocale = const Locale('my');
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  // English Option
                  _LanguageOptionCard(
                    flag: const UkFlag(width: 30, height: 20),
                    title: context.l10n.commonLanguageEn,
                    subtitle: 'English',
                    isSelected: !isBurmese,
                    onTap: () {
                      setDialogState(() {
                        selectedLocale = const Locale('en');
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  context.l10n.commonCancel,
                  style: const TextStyle(
                    color: AppColors.slate600,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.slate900,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  if (selectedLocale != currentLocale) {
                    await ref.read(appLocaleProvider.notifier).setLocale(selectedLocale);
                  }
                },
                child: Text(
                  context.l10n.commonConfirm,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class _LanguageOptionCard extends StatelessWidget {
  const _LanguageOptionCard({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final Widget flag;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.slate50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.slate900 : AppColors.slate200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            flag,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: AppColors.slate900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppColors.slate900 : AppColors.slate300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// A sidebar button that displays the active country flag and opens the language selection dialog.
class SidebarLanguageButton extends ConsumerStatefulWidget {
  const SidebarLanguageButton({
    super.key,
    this.darkBackground = false,
  });

  final bool darkBackground;

  @override
  ConsumerState<SidebarLanguageButton> createState() => _SidebarLanguageButtonState();
}

class _SidebarLanguageButtonState extends ConsumerState<SidebarLanguageButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(appLocaleProvider);
    final isBurmese = currentLocale.languageCode == 'my';

    return Tooltip(
      message: context.l10n.commonLanguage,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 300),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => showChangeLanguageDialog(context, ref),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _hovered
                  ? (widget.darkBackground
                      ? Colors.white.withValues(alpha: 0.1)
                      : AppColors.slate100)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: isBurmese
                  ? const MyanmarFlag(width: 25, height: 16.5)
                  : const UkFlag(width: 25, height: 16.5),
            ),
          ),
        ),
      ),
    );
  }
}
