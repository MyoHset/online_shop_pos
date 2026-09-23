import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/customer.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
abstract class CustomerModel with _$CustomerModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CustomerModel({
    required String id,
    String? shopId,
    required String name,
    required String phone,
    String? address,
    @Default(0.0) double creditLimit,
    @Default(0.0) double currentDebt,
    @Default('monthly') String repaymentCycle,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  const CustomerModel._();

  Customer toEntity() => Customer(
        id: id,
        shopId: shopId,
        name: name,
        phone: phone,
        address: address,
        creditLimit: creditLimit,
        currentDebt: currentDebt,
        repaymentCycle: RepaymentCycle.fromString(repaymentCycle),
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
