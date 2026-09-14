import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ResetPassword {
  const ResetPassword(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call({required String email}) {
    return _repository.resetPassword(email: email);
  }
}
