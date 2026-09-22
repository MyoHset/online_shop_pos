import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/entities/staff_role.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/owner_dashboard_view.dart';
import '../widgets/staff_dashboard_view.dart';

class DashboardHomeScreen extends ConsumerWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(currentStaffRoleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: roleAsync.when(
        data: (role) {
          if (role.canManageProducts) {
            return const OwnerDashboardView();
          }
          return const StaffDashboardView();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Failed to load dashboard: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(currentStaffRoleProvider.future),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
