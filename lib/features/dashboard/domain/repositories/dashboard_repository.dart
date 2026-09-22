import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_status_count.dart';
import '../entities/outstanding_balance.dart';
import '../entities/today_sales_summary.dart';

abstract class DashboardRepository {
  Future<Either<Failure, TodaySalesSummary>> getTodaySummary();
  Future<Either<Failure, List<OrderStatusCount>>> getStatusCounts();
  Future<Either<Failure, List<OutstandingBalance>>> getOutstandingBalances({int limit = 5});
}
