import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/order_status_count.dart';
import '../../domain/entities/outstanding_balance.dart';
import '../../domain/entities/today_sales_summary.dart';

abstract class DashboardRemoteDataSource {
  Future<TodaySalesSummary> getTodaySummary();
  Future<List<OrderStatusCount>> getStatusCounts();
  Future<List<OutstandingBalance>> getOutstandingBalances({int limit = 5});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  const DashboardRemoteDataSourceImpl(this.supabase);
  final SupabaseClient supabase;

  @override
  Future<TodaySalesSummary> getTodaySummary() async {
    final response = await supabase
        .from('today_sales_summary')
        .select()
        .limit(1)
        .maybeSingle();
        
    if (response == null) {
      return const TodaySalesSummary();
    }
    return TodaySalesSummary.fromJson(response);
  }

  @override
  Future<List<OrderStatusCount>> getStatusCounts() async {
    final response = await supabase
        .from('order_status_counts')
        .select();
        
    return (response as List<dynamic>)
        .map((e) => OrderStatusCount.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<OutstandingBalance>> getOutstandingBalances({int limit = 5}) async {
    final response = await supabase
        .from('order_payment_summary')
        .select()
        .gt('balance_due', 0)
        .order('balance_due', ascending: false)
        .limit(limit);
        
    return (response as List<dynamic>)
        .map((e) => OutstandingBalance.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
