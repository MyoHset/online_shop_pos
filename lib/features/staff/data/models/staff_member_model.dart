import '../../../auth/domain/entities/staff_role.dart';
import '../../domain/entities/staff_member.dart';

class StaffMemberModel extends StaffMember {
  const StaffMemberModel({
    required super.id,
    required super.shopId,
    required super.userId,
    required super.role,
    required super.fullName,
    required super.isActive,
    super.email,
  });

  factory StaffMemberModel.fromJson(Map<String, dynamic> json) {
    return StaffMemberModel(
      id: json['id'] as String,
      shopId: json['shop_id'] as String,
      userId: json['user_id'] as String,
      role: StaffRole.fromString(json['role'] as String?),
      fullName: json['full_name'] as String? ?? 'Staff Member',
      isActive: json['is_active'] as bool? ?? true,
      email: json['email'] as String?,
    );
  }
}
