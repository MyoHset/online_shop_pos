// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_sales_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodaySalesSummary _$TodaySalesSummaryFromJson(Map<String, dynamic> json) =>
    _TodaySalesSummary(
      orderCount: (json['order_count'] as num?)?.toInt() ?? 0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
      onlineRevenue: (json['online_revenue'] as num?)?.toDouble() ?? 0.0,
      inStoreRevenue: (json['in_store_revenue'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$TodaySalesSummaryToJson(_TodaySalesSummary instance) =>
    <String, dynamic>{
      'order_count': instance.orderCount,
      'total_revenue': instance.totalRevenue,
      'online_revenue': instance.onlineRevenue,
      'in_store_revenue': instance.inStoreRevenue,
    };
