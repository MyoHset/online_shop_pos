import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/shop_user.dart';
import '../repositories/auth_repository.dart';

class Login {
  const Login(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, ShopUser>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
