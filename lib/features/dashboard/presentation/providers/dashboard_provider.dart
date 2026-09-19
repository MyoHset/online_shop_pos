import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/order_status_count.dart';
import '../../domain/entities/outstanding_balance.dart';
import '../../domain/entities/today_sales_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'dashboard_provider.g.dart';

@riverpod
DashboardRemoteDataSource dashboardRemoteDataSource(Ref ref) {
  return DashboardRemoteDataSourceImpl(ref.watch(supabaseClientProvider));
}

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  return DashboardRepositoryImpl(ref.watch(dashboardRemoteDataSourceProvider));
}

@riverpod
Future<TodaySalesSummary> todaySalesSummary(Ref ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  final result = await repo.getTodaySummary();
  return result.getOrElse((failure) => throw failure);
}

@riverpod
Future<List<OrderStatusCount>> orderStatusCounts(Ref ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  final result = await repo.getStatusCounts();
  return result.getOrElse((failure) => throw failure);
}

@riverpod
Future<List<OutstandingBalance>> outstandingBalances(Ref ref) async {
  final repo = ref.watch(dashboardRepositoryProvider);
  final result = await repo.getOutstandingBalances(limit: 5);
  return result.getOrElse((failure) => throw failure);
}
