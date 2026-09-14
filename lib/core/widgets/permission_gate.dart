import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/domain/entities/staff_role.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// PermissionGate widget that conditionally displays [child]
/// based on the current staff role's permissions.
class PermissionGate extends ConsumerWidget {
  const PermissionGate({
    super.key,
    required this.permission,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  /// Function that takes [StaffRole] and returns true if permitted.
  final bool Function(StaffRole role) permission;
  final Widget child;
  final Widget fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(currentStaffRoleProvider);

    return roleAsync.when(
      data: (role) {
        if (role != null && permission(role)) {
          return child;
        }
        return fallback;
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => fallback,
    );
  }
}
