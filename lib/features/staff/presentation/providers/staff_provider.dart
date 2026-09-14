import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../auth/domain/entities/staff_role.dart';
import '../../data/datasources/staff_remote_data_source.dart';
import '../../data/repositories/staff_repository_impl.dart';
import '../../domain/entities/staff_member.dart';
import '../../domain/repositories/staff_repository.dart';
import '../../domain/usecases/get_staff_list.dart';
import '../../domain/usecases/invite_staff.dart';

part 'staff_provider.g.dart';

@riverpod
StaffRepository staffRepository(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final remoteDataSource = StaffRemoteDataSourceImpl(supabase);
  return StaffRepositoryImpl(remoteDataSource);
}

@riverpod
class StaffListController extends _$StaffListController {
  @override
  FutureOr<List<StaffMember>> build() async {
    final repository = ref.watch(staffRepositoryProvider);
    final usecase = GetStaffList(repository);
    final result = await usecase();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (staffList) => staffList,
    );
  }

  Future<bool> inviteStaff({
    required String email,
    required String password,
    required String fullName,
    required StaffRole role,
  }) async {
    final repository = ref.read(staffRepositoryProvider);
    final usecase = InviteStaff(repository);
    final result = await usecase(
      email: email,
      password: password,
      fullName: fullName,
      role: role,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        ref.invalidateSelf();
        return true;
      },
    );
  }
}
