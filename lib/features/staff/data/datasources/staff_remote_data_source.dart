import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/utils/app_logger.dart';
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
    try {
      final response =
          await _client.from(SupabaseConstants.shopStaffTable).select('*');
      // .order('full_name');

      final list = (response as List)
          .map(
            (json) => StaffMemberModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      AppLogger.logDataSuccess('getStaffList', data: 'Count: ${list.length}');
      return list;
    } catch (e, st) {
      AppLogger.logDataError('getStaffList', e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> inviteStaff({
    required String email,
    required String password,
    required String fullName,
    required StaffRole role,
  }) async {
    final params = {'email': email, 'role': role.value};
    try {
      AppLogger.logEvent('InviteStaffAttempt', details: params);
      final response = await _client.functions.invoke(
        'invite-staff',
        body: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'role': role.value,
        },
      );

      if (response.status != 200 && response.status != 201) {
        final data = response.data;
        final errorMsg = (data is Map ? data['error'] : null) ??
            'Failed to invite staff member';
        AppLogger.logRpcError(
          'invite-staff (EdgeFunction)',
          errorMsg,
          params: params,
        );
        throw Exception(errorMsg);
      }
      AppLogger.logRpcSuccess('invite-staff (EdgeFunction)', params: params);
    } catch (e, st) {
      AppLogger.logRpcError(
        'invite-staff (EdgeFunction)',
        e,
        params: params,
        stackTrace: st,
      );
      rethrow;
    }
  }
}
