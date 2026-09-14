import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/device_type.dart';
import '../../../../core/responsive/responsive_extensions.dart';

import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../providers/staff_provider.dart';
import '../views/staff_list_views.dart';

class StaffListScreen extends ConsumerWidget {
  const StaffListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffListControllerProvider);
    final deviceType = context.deviceType;

    return staffAsync.when(
      data: (staffList) {
        if (deviceType == DeviceType.mobile) {
          return StaffListMobileView(
            staffList: staffList,
            onInviteStaff: () => context.push('/staff/invite'),
          );
        }
        return StaffListTabletDesktopView(
          staffList: staffList,
          onInviteStaff: () => context.push('/staff/invite'),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: AppLoadingWidget()),
      ),
      error: (error, stack) => Scaffold(
        body: AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(staffListControllerProvider),
        ),
      ),
    );
  }
}
