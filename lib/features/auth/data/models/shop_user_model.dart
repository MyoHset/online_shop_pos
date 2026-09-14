import '../../domain/entities/shop_user.dart';
import '../../domain/entities/staff_role.dart';

class ShopUserModel extends ShopUser {
  const ShopUserModel({
    required super.userId,
    required super.email,
    required super.shopId,
    required super.shopName,
    required super.fullName,
    required super.role,
    super.phone,
  });

  factory ShopUserModel.fromJson(Map<String, dynamic> json, String email) {
    final shopData = json['shops'] as Map<String, dynamic>?;
    return ShopUserModel(
      userId: json['user_id'] as String,
      email: email,
      shopId: json['shop_id'] as String,
      shopName: shopData?['shop_name'] as String? ?? 'Shop',
      fullName: json['full_name'] as String? ?? 'Staff Member',
      role: StaffRole.fromString(json['role'] as String?),
      phone: shopData?['phone'] as String?,
    );
  }
}
