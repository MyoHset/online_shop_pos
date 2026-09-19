// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outstanding_balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OutstandingBalance _$OutstandingBalanceFromJson(Map<String, dynamic> json) =>
    _OutstandingBalance(
      orderId: json['order_id'] as String,
      orderNumber: json['order_number'] as String,
      customerName: json['customer_name'] as String?,
      balanceDue: (json['balance_due'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$OutstandingBalanceToJson(_OutstandingBalance instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'order_number': instance.orderNumber,
      'customer_name': instance.customerName,
      'balance_due': instance.balanceDue,
    };
