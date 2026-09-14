import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/staff_role.dart';
import '../entities/staff_member.dart';

abstract class StaffRepository {
  Future<Either<Failure, List<StaffMember>>> getStaffList();

  Future<Either<Failure, void>> inviteStaff({
    required String email,
    required String password,
    required String fullName,
    required StaffRole role,
  });
}
