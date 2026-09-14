import 'staff_role.dart';

/// Entity representing the authenticated staff member and shop details.
class ShopUser {
  const ShopUser({
    required this.userId,
    required this.email,
    required this.shopId,
    required this.shopName,
    required this.fullName,
    required this.role,
    this.phone,
  });

  final String userId;
  final String email;
  final String shopId;
  final String shopName;
  final String fullName;
  final StaffRole role;
  final String? phone;
}
