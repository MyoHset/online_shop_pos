// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderStatusCount _$OrderStatusCountFromJson(Map<String, dynamic> json) =>
    _OrderStatusCount(
      status: json['status'] as String,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OrderStatusCountToJson(_OrderStatusCount instance) =>
    <String, dynamic>{
      'status': instance.status,
      'count': instance.count,
    };
