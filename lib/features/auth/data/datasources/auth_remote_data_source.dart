import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/staff_role.dart';
import '../models/shop_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<ShopUserModel> registerShop({
    required String shopName,
    required String phone,
    required String email,
    required String password,
  });

  Future<ShopUserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> resetPassword({required String email});

  Future<ShopUserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<ShopUserModel> registerShop({
    required String shopName,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.logEvent('RegisterShop', details: {'shopName': shopName, 'email': email});
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'shop_name': shopName,
          'phone': phone,
          'full_name': shopName,
        },
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException('User registration failed');
      }

      final result = await fetchStaffDetails(user.id, email);
      AppLogger.logDataSuccess('RegisterShop', data: result.email);
      return result;
    } catch (e, st) {
      AppLogger.logDataError('RegisterShop', e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<ShopUserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.logEvent('LoginAttempt', details: {'email': email});
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException('Login failed');
      }

      final result = await fetchStaffDetails(user.id, email);
      AppLogger.logDataSuccess('Login', data: result.email);
      return result;
    } catch (e, st) {
      AppLogger.logDataError('Login', e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      AppLogger.logEvent('Logout');
      await _client.auth.signOut();
      AppLogger.logDataSuccess('Logout');
    } catch (e, st) {
      AppLogger.logDataError('Logout', e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      AppLogger.logEvent('ResetPassword', details: {'email': email});
      await _client.auth.resetPasswordForEmail(email);
      AppLogger.logDataSuccess('ResetPassword');
    } catch (e, st) {
      AppLogger.logDataError('ResetPassword', e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<ShopUserModel?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null || user.email == null) {
        AppLogger.logDataSuccess('GetCurrentUser', data: 'No authenticated user');
        return null;
      }
      final shopUser = await fetchStaffDetails(user.id, user.email!);
      AppLogger.logDataSuccess(
        'GetCurrentUser (App Start)',
        data: {
          'userId': shopUser.userId,
          'email': shopUser.email,
          'fullName': shopUser.fullName,
          'shopId': shopUser.shopId,
          'shopName': shopUser.shopName,
          'role': shopUser.role.value,
        },
      );
      return shopUser;
    } catch (e, st) {
      AppLogger.logDataError('GetCurrentUser', e, stackTrace: st);
      return null;
    }
  }

  Future<ShopUserModel> fetchStaffDetails(String userId, String email) async {
    final staffRow = await _client
        .from(SupabaseConstants.shopStaffTable)
        .select('*, shops(*)')
        .eq('user_id', userId)
        .maybeSingle();

    if (staffRow == null) {
      return ShopUserModel(
        userId: userId,
        email: email,
        shopId: '',
        shopName: 'Shop',
        fullName: email.split('@').first,
        role: StaffRole.owner,
      );
    }

    return ShopUserModel.fromJson(staffRow, email);
  }
}
