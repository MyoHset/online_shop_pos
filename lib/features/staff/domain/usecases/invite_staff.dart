import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/staff_role.dart';
import '../repositories/staff_repository.dart';

class InviteStaff {
  const InviteStaff(this._repository);

  final StaffRepository _repository;

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
    required String fullName,
    required StaffRole role,
  }) {
    return _repository.inviteStaff(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
    );
  }
}
