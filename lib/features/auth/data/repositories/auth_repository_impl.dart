import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/shop_user.dart';
import '../../domain/entities/staff_role.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ShopUser>> registerShop({
    required String shopName,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.registerShop(
        shopName: shopName,
        phone: phone,
        email: email,
        password: password,
      );
      return right(user);
    } on AuthException catch (e) {
      return left(ServerFailure(_mapAuthErrorMessage(e.message)));
    } catch (e) {
      return left(ServerFailure('Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ShopUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return right(user);
    } on AuthException catch (e) {
      return left(ServerFailure(_mapAuthErrorMessage(e.message)));
    } catch (e) {
      return left(ServerFailure('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      return right(null);
    } catch (e) {
      return left(ServerFailure('Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _remoteDataSource.resetPassword(email: email);
      return right(null);
    } on AuthException catch (e) {
      return left(ServerFailure(_mapAuthErrorMessage(e.message)));
    } catch (e) {
      return left(ServerFailure('Password reset failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ShopUser?>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return right(user);
    } catch (e) {
      return left(ServerFailure('Failed to get current user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, StaffRole>> getCurrentStaffRole() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return right(user?.role ?? StaffRole.staff);
    } catch (e) {
      return left(ServerFailure('Failed to resolve staff role: ${e.toString()}'));
    }
  }

  String _mapAuthErrorMessage(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Email or password is incorrect.';
    }
    if (message.contains('User already registered')) {
      return 'An account with this email already exists.';
    }
    if (message.contains('Password should be at least')) {
      return 'Password must be at least 8 characters long.';
    }
    return message;
  }
}
