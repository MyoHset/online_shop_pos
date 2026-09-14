import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../auth/domain/entities/staff_role.dart';
import '../models/staff_member_model.dart';

abstract class StaffRemoteDataSource {
  Future<List<StaffMemberModel>> getStaffList();

  Future<void> inviteStaff({
    required String email,
    required String password,
    required String fullName,
    required StaffRole role,
  });
}

class StaffRemoteDataSourceImpl implements StaffRemoteDataSource {
  const StaffRemoteDataSourceImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<List<StaffMemberModel>> getStaffList() async {
    final response = await _client
        .from(SupabaseConstants.shopStaffTable)
        .select('*')
        .order('full_name');

    return (response as List)
        .map((json) => StaffMemberModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> inviteStaff({
    required String email,
    required String password,
    required String fullName,
    required StaffRole role,
  }) async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) {
      throw const AuthException('Not authenticated');
    }

    final currentStaff = await _client
        .from(SupabaseConstants.shopStaffTable)
        .select('shop_id')
        .eq('user_id', currentUser.id)
        .single();

    final shopId = currentStaff['shop_id'] as String;

    final response = await _client.functions.invoke(
      'invite-staff',
      body: {
        'email': email,
        'password': password,
        'fullName': fullName,
        'role': role.value,
        'shopId': shopId,
        'requestedByUserId': currentUser.id,
      },
    );

    if (response.status != 200 && response.status != 201) {
      final errorMsg = response.data?['error'] ?? 'Failed to invite staff member';
      throw Exception(errorMsg);
    }
  }
}
