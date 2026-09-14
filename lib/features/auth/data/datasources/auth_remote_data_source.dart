import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
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

    return fetchStaffDetails(user.id, email);
  }

  @override
  Future<ShopUserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Login failed');
    }

    return fetchStaffDetails(user.id, email);
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  @override
  Future<ShopUserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null || user.email == null) {
      return null;
    }
    return fetchStaffDetails(user.id, user.email!);
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
