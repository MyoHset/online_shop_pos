import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';

/// Repayment cycle for customer credit.
enum RepaymentCycle {
  weekly,
  monthly,
  net30;

  String get displayLabel => switch (this) {
        RepaymentCycle.weekly => 'Weekly',
        RepaymentCycle.monthly => 'Monthly',
        RepaymentCycle.net30 => 'Net 30 Days',
      };

  String get value => switch (this) {
        RepaymentCycle.weekly => 'weekly',
        RepaymentCycle.monthly => 'monthly',
        RepaymentCycle.net30 => 'net30',
      };

  static RepaymentCycle fromString(String? val) {
    if (val == null) return RepaymentCycle.monthly;
    return RepaymentCycle.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase() || e.value == val,
      orElse: () => RepaymentCycle.monthly,
    );
  }
}

/// Customer pure entity.
@freezed
abstract class Customer with _$Customer {
  const factory Customer({
    required String id,
    String? shopId,
    required String name,
    required String phone,
    String? address,
    required double creditLimit,
    required double currentDebt,
    required RepaymentCycle repaymentCycle,
    String? notes,
    @Default(false) bool isSuspended,
    String? suspendedReason,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Customer;

  const Customer._();

  /// Whether customer has outstanding debt
  bool get hasDebt => currentDebt > 0;

  /// Remaining credit allowed before reaching credit limit
  double get remainingCredit => (creditLimit - currentDebt).clamp(0, creditLimit).toDouble();

  /// Whether current debt exceeds or meets the credit limit
  bool get isLimitReached => creditLimit > 0 && currentDebt >= creditLimit;

  /// Calculates due date from given sale date based on repayment cycle
  DateTime calculateDueDate(DateTime fromDate) {
    return switch (repaymentCycle) {
      RepaymentCycle.weekly => fromDate.add(const Duration(days: 7)),
      RepaymentCycle.monthly => fromDate.add(const Duration(days: 30)),
      RepaymentCycle.net30 => fromDate.add(const Duration(days: 30)),
    };
  }
}
