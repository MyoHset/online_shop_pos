import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';

/// Payment method options for manual entry.
enum PaymentMethod {
  cod,
  kbzPay,
  wavePay,
  bankTransfer;

  String get displayLabel => switch (this) {
        PaymentMethod.cod => 'Cash / COD',
        PaymentMethod.kbzPay => 'KBZPay',
        PaymentMethod.wavePay => 'WavePay',
        PaymentMethod.bankTransfer => 'Bank Transfer',
      };

  String get value => switch (this) {
        PaymentMethod.cod => 'cod',
        PaymentMethod.kbzPay => 'kbz_pay',
        PaymentMethod.wavePay => 'wave_pay',
        PaymentMethod.bankTransfer => 'bank_transfer',
      };

  static PaymentMethod fromString(String value) {
    final normalized = value.toLowerCase().trim();
    return PaymentMethod.values.firstWhere(
      (m) =>
          m.value == normalized ||
          m.name.toLowerCase() == normalized,
      orElse: () => PaymentMethod.cod,
    );
  }
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
