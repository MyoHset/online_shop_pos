import 'package:intl/intl.dart';

/// Centralized utility for date and time formatting.
///
/// Preserves Latin numeric digits for consistency across all locales while
/// allowing localized month and day names.
abstract final class DateFormatter {
  /// Formats date as `MMM d, yyyy` (e.g. `Oct 15, 2026`).
  static String formatMedium(DateTime date, [String? locale]) {
    return DateFormat.yMMMd(locale).format(date);
  }

  /// Formats date and time as `MMM d, yyyy h:mm a` (e.g. `Oct 15, 2026 2:30 PM`).
  static String formatDateTime(DateTime date, [String? locale]) {
    return DateFormat.yMMMd(locale).add_jm().format(date);
  }

  /// Formats date as `yyyy-MM-dd`.
  static String formatIsoDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Formats time as `h:mm a`.
  static String formatTime(DateTime date, [String? locale]) {
    return DateFormat.jm(locale).format(date);
  }
}
