enum StaffRole {
  owner('owner'),
  manager('manager'),
  staff('staff');

  final String value;
  const StaffRole(this.value);

  static StaffRole fromString(String? roleStr) {
    switch (roleStr?.toLowerCase()) {
      case 'owner':
        return StaffRole.owner;
      case 'manager':
        return StaffRole.manager;
      case 'staff':
      default:
        return StaffRole.staff;
    }
  }
}

extension StaffRolePermissions on StaffRole {
  bool get canManageProducts =>
      this == StaffRole.owner || this == StaffRole.manager;
  bool get canManageStaff => this == StaffRole.owner;
  bool get canDeleteOrders =>
      this == StaffRole.owner || this == StaffRole.manager;
  bool get canEditShopSettings => this == StaffRole.owner;
  bool get canCreateOrder => true;
  bool get canRecordPayment => true;
}
