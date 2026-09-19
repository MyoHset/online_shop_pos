import 'package:freezed_annotation/freezed_annotation.dart';

part 'outstanding_balance.freezed.dart';
part 'outstanding_balance.g.dart';

@freezed
abstract class OutstandingBalance with _$OutstandingBalance {
  const factory OutstandingBalance({
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'order_number') required String orderNumber,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'balance_due') @Default(0.0) double balanceDue,
  }) = _OutstandingBalance;

  factory OutstandingBalance.fromJson(Map<String, dynamic> json) =>
      _$OutstandingBalanceFromJson(json);
}
