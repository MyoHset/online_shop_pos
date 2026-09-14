import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Staff Management'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onInviteStaff,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Invite Staff'),
      ),
      body: ListView.builder(
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
      appBar: AppBar(
        title: const Text('Staff Management'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: onInviteStaff,
              icon: const Icon(Icons.person_add_outlined),
              label: const Text('Invite Staff'),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
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
