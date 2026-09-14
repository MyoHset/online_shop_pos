import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/shop_user.dart';
import '../repositories/auth_repository.dart';

class RegisterShop {
  const RegisterShop(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, ShopUser>> call({
    required String shopName,
    required String phone,
    required String email,
    required String password,
  }) {
    return _repository.registerShop(
      shopName: shopName,
      phone: phone,
      email: email,
      password: password,
    );
  }
}
