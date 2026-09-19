import 'package:freezed_annotation/freezed_annotation.dart';

part 'today_sales_summary.freezed.dart';
part 'today_sales_summary.g.dart';

@freezed
abstract class TodaySalesSummary with _$TodaySalesSummary {
  const factory TodaySalesSummary({
    @JsonKey(name: 'order_count') @Default(0) int orderCount,
    @JsonKey(name: 'total_revenue') @Default(0.0) double totalRevenue,
    @JsonKey(name: 'online_revenue') @Default(0.0) double onlineRevenue,
    @JsonKey(name: 'in_store_revenue') @Default(0.0) double inStoreRevenue,
  }) = _TodaySalesSummary;

  factory TodaySalesSummary.fromJson(Map<String, dynamic> json) =>
      _$TodaySalesSummaryFromJson(json);
}
