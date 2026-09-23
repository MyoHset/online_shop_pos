import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_transaction.freezed.dart';

enum CustomerTransactionType {
  debt,
  repayment,
  openingBalance;

  String get displayLabel => switch (this) {
        CustomerTransactionType.debt => 'Credit Sale',
        CustomerTransactionType.repayment => 'Repayment',
        CustomerTransactionType.openingBalance => 'Opening Debt',
      };

  String get value => switch (this) {
        CustomerTransactionType.debt => 'debt',
        CustomerTransactionType.repayment => 'repayment',
        CustomerTransactionType.openingBalance => 'opening_balance',
      };

  static CustomerTransactionType fromString(String val) {
    return switch (val) {
      'debt' => CustomerTransactionType.debt,
      'repayment' => CustomerTransactionType.repayment,
      'opening_balance' => CustomerTransactionType.openingBalance,
      _ => CustomerTransactionType.debt,
    };
  }
}

/// Customer transaction ledger entity.
@freezed
abstract class CustomerTransaction with _$CustomerTransaction {
  const factory CustomerTransaction({
    required String id,
    required String customerId,
    String? orderId,
    required CustomerTransactionType transactionType,
    required double amount,
    required String paymentMethod,
    required double balanceAfter,
    String? notes,
    required DateTime createdAt,
  }) = _CustomerTransaction;
}
