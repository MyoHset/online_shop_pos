import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/staff_member.dart';
import '../repositories/staff_repository.dart';

class GetStaffList {
  const GetStaffList(this._repository);

  final StaffRepository _repository;

  Future<Either<Failure, List<StaffMember>>> call() {
    return _repository.getStaffList();
  }
}
