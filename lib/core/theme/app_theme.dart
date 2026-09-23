import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic status colors — used ONLY for stock and order status indicators.
abstract final class AppColors {
  // ── Status semantic colors ──────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF3B82F6);

  // ── Status backgrounds (10% opacity) ────────────────────────────────
  static const Color successBg = Color(0x1A16A34A);
  static const Color warningBg = Color(0x1AF59E0B);
  static const Color dangerBg = Color(0x1ADC2626);
  static const Color infoBg = Color(0x1A3B82F6);

  // ── Neutral palette (Minimalist Monochrome) ─────────────────────────
  static const Color slate50 = Color(0xFFF8F9FA); // Off-white for scaffolds
  static const Color slate100 = Color(0xFFF1F3F5); // Light grey for inputs
  static const Color slate200 = Color(0xFFE9ECEF); // Borders
  static const Color slate300 = Color(0xFFDEE2E6); // Disabled
  static const Color slate400 = Color(0xFFCED4DA); // Icons inactive
  static const Color slate500 = Color(0xFFADB5BD); // Placeholder text
  static const Color slate600 = Color(0xFF868E96); // Secondary text
  static const Color slate700 = Color(0xFF495057); // Primary text soft
  static const Color slate800 = Color(0xFF343A40); // Darker accents
  static const Color slate900 = Color(0xFF000000); // True black/darkest for titles & buttons
  
  // ── Brand Colors ────────────────────────────────────────────────────────
  static const Color greenNude = Color(0xFFC1EE44); // Light green brand color
}

/// Application-wide theme configuration.
abstract final class AppTheme {
  static ThemeData get light {
    const seedColor = Color(0xFF000000);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      surface: AppColors.slate50,
      onSurface: AppColors.slate900,
      surfaceContainerHighest: AppColors.slate100,
      outline: AppColors.slate200,
    );

    final base = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.slate700,
        displayColor: AppColors.slate900,
      ),
      scaffoldBackgroundColor: AppColors.slate50,
      dividerTheme: const DividerThemeData(
        color: AppColors.slate200,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          // Extremely subtle border instead of hard line, or no border at all
          side: const BorderSide(color: AppColors.slate100),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.slate50, // Matches scaffold for seamless look
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.slate900,
        ),
        iconTheme: const IconThemeData(color: AppColors.slate900),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.slate100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.slate900, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(color: AppColors.slate500),
        hintStyle: const TextStyle(color: AppColors.slate500),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.slate900,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.slate900,
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: AppColors.slate200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.slate900,
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: AppColors.slate900,
        side: const BorderSide(color: AppColors.slate200),
        shape: const StadiumBorder(), // Pill-shaped chips
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: const Color(0xFF1E2229),
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        elevation: 6,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.slate900,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        iconColor: AppColors.slate900,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.slate900,
        unselectedLabelColor: AppColors.slate400,
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
        indicatorColor: AppColors.slate900,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent, // No long underline
      ),
    );
  }
}

/// Extension on [BuildContext] for quick access to semantic status colors.
extension StatusColors on BuildContext {
  Color get successColor => AppColors.success;
  Color get warningColor => AppColors.warning;
  Color get dangerColor => AppColors.danger;
  Color get infoColor => AppColors.info;
}
