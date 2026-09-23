import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/customer_transaction.dart';

part 'customer_transaction_model.freezed.dart';
part 'customer_transaction_model.g.dart';

@freezed
abstract class CustomerTransactionModel with _$CustomerTransactionModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CustomerTransactionModel({
    required String id,
    required String customerId,
    String? orderId,
    required String transactionType,
    required double amount,
    @Default('cash') String paymentMethod,
    @Default(0.0) double balanceAfter,
    String? notes,
    required DateTime createdAt,
  }) = _CustomerTransactionModel;

  factory CustomerTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerTransactionModelFromJson(json);

  const CustomerTransactionModel._();

  CustomerTransaction toEntity() => CustomerTransaction(
        id: id,
        customerId: customerId,
        orderId: orderId,
        transactionType: CustomerTransactionType.fromString(transactionType),
        amount: amount,
        paymentMethod: paymentMethod,
        balanceAfter: balanceAfter,
        notes: notes,
        createdAt: createdAt,
      );
}
