import 'package:intl/intl.dart';

/// Formats monetary amounts in Myanmar Kyat (MMK).
///
/// Output format: `K 1,000` — no decimal places (kyat has no subunit
/// in common usage).
abstract final class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,###', 'en_US');

  /// Formats [amount] as a kyat string, e.g. `K 1,000`.
  static String format(num amount) {
    return 'K ${_formatter.format(amount.round())}';
  }

  /// Formats [amount] as a compact kyat string, e.g. `K 1.5M` or `K 50K`.
  static String formatCompact(num amount) {
    if (amount >= 1000000) {
      return 'K ${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return 'K ${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}K';
    }
    return format(amount);
  }

  /// Parses a kyat-formatted string back to a [double].
  /// Returns `null` if parsing fails.
  static double? parse(String value) {
    final cleaned = value.replaceAll('K', '').replaceAll(',', '').trim();
    return double.tryParse(cleaned);
  }
}
