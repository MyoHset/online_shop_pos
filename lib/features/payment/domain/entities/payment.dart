import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';

/// Payment method options for manual entry.
enum PaymentMethod {
  cod,
  kbzPay,
  wavePay,
  bankTransfer;

  String get displayLabel => switch (this) {
        PaymentMethod.cod => 'Cash on Delivery',
        PaymentMethod.kbzPay => 'KBZPay',
        PaymentMethod.wavePay => 'Wave Money',
        PaymentMethod.bankTransfer => 'Bank Transfer',
      };

  static PaymentMethod fromString(String value) =>
      PaymentMethod.values.firstWhere(
        (m) => m.name == value,
        orElse: () => PaymentMethod.cod,
      );
}

/// Payment status.
enum PaymentStatus {
  pending,
  paid,
  partial;

  String get displayLabel => switch (this) {
        PaymentStatus.pending => 'Pending',
        PaymentStatus.paid => 'Paid',
        PaymentStatus.partial => 'Partial',
      };

  static PaymentStatus fromString(String value) =>
      PaymentStatus.values.firstWhere(
        (s) => s.name == value,
        orElse: () => PaymentStatus.pending,
      );
}

/// Payment entity — pure Dart.
@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String orderId,
    required PaymentMethod method,
    required double amount,
    required PaymentStatus status,
    required DateTime? paidAt,
    required DateTime createdAt,
  }) = _Payment;
}
