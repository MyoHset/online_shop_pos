import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/payment.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
abstract class PaymentModel with _$PaymentModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PaymentModel({
    required String id,
    required String orderId,
    required String method,
    required double amount,
    required String status,
    required DateTime? paidAt,
    required DateTime createdAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);

  const PaymentModel._();

  Payment toEntity() => Payment(
        id: id,
        orderId: orderId,
        method: PaymentMethod.fromString(method),
        amount: amount,
        status: PaymentStatus.fromString(status),
        paidAt: paidAt,
        createdAt: createdAt,
      );
}
