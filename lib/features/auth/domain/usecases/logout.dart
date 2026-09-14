import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class Logout {
  const Logout(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call() {
    return _repository.logout();
  }
}
