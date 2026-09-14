import '../../../auth/domain/entities/staff_role.dart';

class StaffMember {
  const StaffMember({
    required this.id,
    required this.shopId,
    required this.userId,
    required this.role,
    required this.fullName,
    required this.isActive,
    this.email,
  });

  final String id;
  final String shopId;
  final String userId;
  final StaffRole role;
  final String fullName;
  final bool isActive;
  final String? email;
}
