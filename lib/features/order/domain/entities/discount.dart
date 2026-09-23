/// Represents the type of discount applied to an order.
enum DiscountType {
  none,
  percentage,
  fixed;

  String get displayLabel => switch (this) {
        DiscountType.none => 'No Discount',
        DiscountType.percentage => 'Percentage (%)',
        DiscountType.fixed => 'Fixed (ks)',
      };

  String get value => switch (this) {
        DiscountType.none => 'none',
        DiscountType.percentage => 'percentage',
        DiscountType.fixed => 'fixed',
      };

  static DiscountType fromString(String? value) {
    if (value == null) return DiscountType.none;
    return DiscountType.values.firstWhere(
      (t) => t.value == value || t.name == value,
      orElse: () => DiscountType.none,
    );
  }
}

/// Domain value object representing an order-level discount.
///
/// Contains pure domain logic mirroring the server trigger in [calculateAmount].
class Discount {
  const Discount({
    this.type = DiscountType.none,
    this.value = 0.0,
    this.reason,
  });

  const Discount.none()
      : type = DiscountType.none,
        value = 0.0,
        reason = null;

  final DiscountType type;
  final double value;
  final String? reason;

  bool get hasDiscount => type != DiscountType.none && value > 0;
  bool get isPercentage => type == DiscountType.percentage;
  bool get isFixed => type == DiscountType.fixed;

  /// Pure function mirroring server trigger calculation:
  /// - none: 0.0
  /// - percentage: round(subtotal * value / 100, 2), clamped to [0, subtotal]
  /// - fixed: value, clamped to [0, subtotal]
  double calculateAmount(double subtotal) {
    if (type == DiscountType.none || subtotal <= 0 || value <= 0) {
      return 0.0;
    }
    if (type == DiscountType.percentage) {
      final raw = (subtotal * value) / 100.0;
      final rounded = double.parse(raw.toStringAsFixed(2));
      return rounded > subtotal ? subtotal : rounded;
    }
    // Fixed amount
    return value > subtotal ? subtotal : value;
  }

  Discount copyWith({
    DiscountType? type,
    double? value,
    String? reason,
    bool clearReason = false,
  }) =>
      Discount(
        type: type ?? this.type,
        value: value ?? this.value,
        reason: clearReason ? null : (reason ?? this.reason),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Discount &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          value == other.value &&
          reason == other.reason;

  @override
  int get hashCode => Object.hash(type, value, reason);
}
