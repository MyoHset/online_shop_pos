// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomerTransactionModel _$CustomerTransactionModelFromJson(
        Map<String, dynamic> json) =>
    _CustomerTransactionModel(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      orderId: json['order_id'] as String?,
      transactionType: json['transaction_type'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String? ?? 'cash',
      balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CustomerTransactionModelToJson(
        _CustomerTransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer_id': instance.customerId,
      'order_id': instance.orderId,
      'transaction_type': instance.transactionType,
      'amount': instance.amount,
      'payment_method': instance.paymentMethod,
      'balance_after': instance.balanceAfter,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
    };
