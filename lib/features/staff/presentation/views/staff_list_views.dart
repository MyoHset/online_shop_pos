import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/entities/staff_member.dart';
import '../widgets/staff_card.dart';

class StaffListMobileView extends StatelessWidget {
  const StaffListMobileView({
    super.key,
    required this.staffList,
    required this.onInviteStaff,
  });

  final List<StaffMember> staffList;
  final VoidCallback onInviteStaff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: const CustomAppBar(
        titleText: 'Staff Management',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onInviteStaff,
        backgroundColor: AppColors.slate900,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Invite Staff'),
      ),
      body: staffList.isEmpty
          ? const Center(
              child: Text(
                'No staff members found',
                style: TextStyle(color: AppColors.slate500, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: staffList.length,
              itemBuilder: (context, index) {
                return StaffCard(staff: staffList[index]);
              },
            ),
    );
  }
}

class StaffListTabletDesktopView extends StatelessWidget {
  const StaffListTabletDesktopView({
    super.key,
    required this.staffList,
    required this.onInviteStaff,
  });

  final List<StaffMember> staffList;
  final VoidCallback onInviteStaff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: CustomAppBar(
        titleText: 'Staff Management',
        actions: [
          FilledButton.icon(
            onPressed: onInviteStaff,
            icon: const Icon(Icons.person_add_outlined, size: 18),
            label: const Text('Invite Staff'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.slate900,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: staffList.isEmpty
              ? const Center(
                  child: Text(
                    'No staff members found',
                    style: TextStyle(color: AppColors.slate500, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: staffList.length,
                  itemBuilder: (context, index) {
                    return StaffCard(staff: staffList[index]);
                  },
                ),
        ),
      ),
    );
  }
}
