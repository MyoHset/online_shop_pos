/// Pure validation functions — no Flutter dependencies.
///
/// Each function returns an error string if invalid, or `null` if valid,
/// matching Flutter's [FormField] validator signature.
abstract final class Validators {
  /// Validates that [value] is not null or empty.
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  /// Validates that [value] is a valid positive integer.
  static String? positiveInt(String? value, {String fieldName = 'Value'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed < 0) {
      return '$fieldName must be a non-negative whole number.';
    }
    return null;
  }

  /// Validates that [value] is a valid positive number.
  static String? positiveNumber(String? value, {String fieldName = 'Value'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < 0) {
      return '$fieldName must be a non-negative number.';
    }
    return null;
  }

  /// Validates a Myanmar phone number (basic format check).
  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!RegExp(r'^(\+?95|0)?9\d{7,9}$').hasMatch(cleaned)) {
      return 'Enter a valid Myanmar phone number.';
    }
    return null;
  }

  /// Validates that [value] does not exceed [maxLength] characters.
  static String? maxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'Must be $maxLength characters or fewer.';
    }
    return null;
  }

  /// Validates that [value] is a valid SKU (alphanumeric + hyphens).
  static String? sku(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    if (!RegExp(r'^[A-Za-z0-9\-]+$').hasMatch(value)) {
      return 'SKU may only contain letters, numbers, and hyphens.';
    }
    return null;
  }

  /// Chains multiple validators, returning the first error found.
  static String? Function(String?) chain(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final v in validators) {
        final error = v(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
