import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/shop_user.dart';
import '../entities/staff_role.dart';

/// Abstract repository contract for Authentication and Shop Staff management.
abstract class AuthRepository {
  /// Registers a new shop owner and creates their shop instance via Supabase Auth metadata.
  Future<Either<Failure, ShopUser>> registerShop({
    required String shopName,
    required String phone,
    required String email,
    required String password,
  });

  /// Logs in an existing shop staff member using email and password.
  Future<Either<Failure, ShopUser>> login({
    required String email,
    required String password,
  });

  /// Logs out the current user session.
  Future<Either<Failure, void>> logout();

  /// Sends a password reset email.
  Future<Either<Failure, void>> resetPassword({required String email});

  /// Resolves the current authenticated user's details and active role.
  Future<Either<Failure, ShopUser?>> getCurrentUser();

  /// Resolves the current staff role.
  Future<Either<Failure, StaffRole>> getCurrentStaffRole();
}
