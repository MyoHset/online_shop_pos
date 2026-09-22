import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_status_count.dart';
import '../../domain/entities/outstanding_balance.dart';
import '../../domain/entities/today_sales_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this.remoteDataSource);
  final DashboardRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, TodaySalesSummary>> getTodaySummary() async {
    try {
      final summary = await remoteDataSource.getTodaySummary();
      return Right(summary);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderStatusCount>>> getStatusCounts() async {
    try {
      final counts = await remoteDataSource.getStatusCounts();
      return Right(counts);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OutstandingBalance>>> getOutstandingBalances({int limit = 5}) async {
    try {
      final balances = await remoteDataSource.getOutstandingBalances(limit: limit);
      return Right(balances);
    } catch (e) {
      if (e is ServerException) {
        return Left(ServerFailure(e.message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
