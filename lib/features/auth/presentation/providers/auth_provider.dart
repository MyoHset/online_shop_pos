import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/shop_user.dart';
import '../../domain/entities/staff_role.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register_shop.dart';
import '../../domain/usecases/reset_password.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final remoteDataSource = AuthRemoteDataSourceImpl(supabase);
  return AuthRepositoryImpl(remoteDataSource);
}

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<ShopUser?> build() async {
    final repository = ref.watch(authRepositoryProvider);
    final result = await repository.getCurrentUser();
    return result.fold(
      (failure) => null,
      (user) => user,
    );
  }

  Future<bool> registerShop({
    required String shopName,
    required String phone,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final useCase = RegisterShop(repository);
    final result = await useCase(
      shopName: shopName,
      phone: phone,
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final useCase = Login(repository);
    final result = await useCase(email: email, password: password);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    final useCase = Logout(repository);
    await useCase();
    state = const AsyncValue.data(null);
  }

  Future<bool> resetPassword(String email) async {
    final repository = ref.read(authRepositoryProvider);
    final useCase = ResetPassword(repository);
    final result = await useCase(email: email);
    return result.isRight();
  }
}

@riverpod
Future<StaffRole> currentStaffRole(Ref ref) async {
  final authState = ref.watch(authControllerProvider);
  return authState.maybeWhen(
    data: (user) => user?.role ?? StaffRole.staff,
    orElse: () => StaffRole.staff,
  );
}
