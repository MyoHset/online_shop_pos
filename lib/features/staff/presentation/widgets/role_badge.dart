import 'package:flutter/material.dart';
import '../../../auth/domain/entities/staff_role.dart';

class RoleBadge extends StatelessWidget {
  const RoleBadge({
    super.key,
    required this.role,
  });

  final StaffRole role;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[100]!;
    Color textColor = Colors.grey[800]!;
    IconData icon = Icons.person_outlined;

    switch (role) {
      case StaffRole.owner:
        backgroundColor = Colors.purple[50]!;
        textColor = Colors.purple[800]!;
        icon = Icons.star_outlined;
        break;
      case StaffRole.manager:
        backgroundColor = Colors.blue[50]!;
        textColor = Colors.blue[800]!;
        icon = Icons.security_outlined;
        break;
      case StaffRole.staff:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[800]!;
        icon = Icons.person_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            role.value.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
