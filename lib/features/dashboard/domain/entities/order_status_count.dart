import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_status_count.freezed.dart';
part 'order_status_count.g.dart';

@freezed
abstract class OrderStatusCount with _$OrderStatusCount {
  const factory OrderStatusCount({
    required String status,
    @Default(0) int count,
  }) = _OrderStatusCount;

  factory OrderStatusCount.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusCountFromJson(json);
}
