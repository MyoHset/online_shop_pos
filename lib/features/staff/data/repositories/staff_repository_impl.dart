import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/staff_role.dart';
import '../../domain/entities/staff_member.dart';
import '../../domain/repositories/staff_repository.dart';
import '../datasources/staff_remote_data_source.dart';

class StaffRepositoryImpl implements StaffRepository {
  const StaffRepositoryImpl(this._remoteDataSource);

  final StaffRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<StaffMember>>> getStaffList() async {
    try {
      final staffList = await _remoteDataSource.getStaffList();
      return right(staffList);
    } catch (e) {
      return left(ServerFailure('Failed to fetch staff list: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> inviteStaff({
    required String email,
    required String password,
    required String fullName,
    required StaffRole role,
  }) async {
    try {
      await _remoteDataSource.inviteStaff(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );
      return right(null);
    } catch (e) {
      return left(ServerFailure('Failed to invite staff member: ${e.toString()}'));
    }
  }
}
