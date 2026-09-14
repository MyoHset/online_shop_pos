import 'package:flutter/material.dart';
import '../../domain/entities/staff_member.dart';
import 'role_badge.dart';

class StaffCard extends StatelessWidget {
  const StaffCard({
    super.key,
    required this.staff,
  });

  final StaffMember staff;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(
            staff.fullName.isNotEmpty ? staff.fullName[0].toUpperCase() : 'S',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          staff.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: staff.email != null ? Text(staff.email!) : null,
        trailing: RoleBadge(role: staff.role),
      ),
    );
  }
}
