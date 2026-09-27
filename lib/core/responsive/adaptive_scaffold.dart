import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import '../../features/auth/domain/entities/staff_role.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../responsive/device_type.dart';
import '../responsive/responsive_extensions.dart';
import '../theme/app_theme.dart';

/// Navigation destination definition for the adaptive scaffold.
class AppNavDestination {
  const AppNavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });

  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final String route;
}

/// Adaptive navigation shell that swaps between:
/// - [BottomNavigationBar] & Navigation Drawer on mobile (< 600 px)
/// - [NavigationRail] on tablet (600–1023 px)
/// - Permanent sidebar on desktop (≥ 1024 px)
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
  });

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  /// Global key used to control the mobile drawer from any descendant screen.
  static final GlobalKey<ScaffoldState> mobileScaffoldKey =
      GlobalKey<ScaffoldState>();

  /// Helper to open the mobile drawer from any AppBar or widget.
  static void openDrawer([BuildContext? context]) {
    mobileScaffoldKey.currentState?.openDrawer();
  }

  /// Helper to close the mobile drawer.
  static void closeDrawer([BuildContext? context]) {
    mobileScaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = context.deviceType;

    return switch (deviceType) {
      DeviceType.mobile => _MobileScaffold(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          body: body,
        ),
      DeviceType.tablet => _TabletScaffold(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          body: body,
        ),
      DeviceType.desktop || DeviceType.large => _DesktopScaffold(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          body: body,
        ),
    };
  }
}

// ── Shared animation constants ─────────────────────────────────────────────────

const _kSlideDuration = Duration(milliseconds: 220);
const _kSlideCurve = Curves.easeInOutCubic;

// ── Mobile ────────────────────────────────────────────────────────────────────

class _MobileScaffold extends StatelessWidget {
  const _MobileScaffold({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
  });

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    // Exactly 4 primary destinations on the bottom bar:
    // Dashboard (0), Quick Sale (1), Orders (2), Products (3)
    final bottomDestinations = destinations.take(4).toList();

    return Scaffold(
      key: AdaptiveScaffold.mobileScaffoldKey,
      drawerEnableOpenDragGesture: true,
      drawer: _MobileDrawer(
        destinations: destinations,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
      body: body,
      bottomNavigationBar: _MobileBottomBar(
        destinations: bottomDestinations,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

/// Custom Bottom Navigation Bar with an animated sliding pill indicator and zero black background.
class _MobileBottomBar extends StatelessWidget {
  const _MobileBottomBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    const double barHeight = 56.0;
    const double horizontalPadding = 12.0;
    const double pillMarginH = 4.0;
    const double pillMarginV = 5.0;
    const double pillHeight = barHeight - (pillMarginV * 2);

    final bool isTabSelected =
        selectedIndex >= 0 && selectedIndex < destinations.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: AppColors.slate200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: barHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double usableWidth =
                  constraints.maxWidth - (horizontalPadding * 2);
              final double itemWidth = usableWidth / destinations.length;
              final double targetIndex =
                  isTabSelected ? selectedIndex.toDouble() : 0.0;
              final double pillLeft =
                  horizontalPadding + (targetIndex * itemWidth) + pillMarginH;
              final double pillWidth = itemWidth - (pillMarginH * 2);

              return Stack(
                children: [
                  // ── Animated Sliding Active Pill (Brand GreenNude, No Black!) ──
                  AnimatedPositioned(
                    duration: _kSlideDuration,
                    curve: _kSlideCurve,
                    left: pillLeft,
                    top: pillMarginV,
                    width: pillWidth,
                    height: pillHeight,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: isTabSelected ? 1.0 : 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.greenNude.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.greenNude.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Foreground Interactive Tabs ──────────────────────────────
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Row(
                        children: List.generate(destinations.length, (index) {
                          final d = destinations[index];
                          final isSelected = selectedIndex == index;

                          return SizedBox(
                            width: itemWidth,
                            height: barHeight,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => onDestinationSelected(index),
                                borderRadius: BorderRadius.circular(12),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedScale(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeOutBack,
                                      scale: isSelected ? 1.08 : 1.0,
                                      child: IconTheme(
                                        data: IconThemeData(
                                          color: isSelected
                                              ? AppColors.slate900
                                              : AppColors.slate500,
                                          size: 20,
                                        ),
                                        child: isSelected
                                            ? d.selectedIcon
                                            : d.icon,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    AnimatedDefaultTextStyle(
                                      duration:
                                          const Duration(milliseconds: 180),
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? AppColors.slate900
                                            : AppColors.slate600,
                                        letterSpacing: 0.1,
                                      ),
                                      child: Text(
                                        d.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Navigation Drawer for mobile housing all secondary management options (Customers, Staff, etc.).
class _MobileDrawer extends ConsumerWidget {
  const _MobileDrawer({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authControllerProvider);
    final user = userAsync.value;
    final roleAsync = ref.watch(currentStaffRoleProvider);
    final role = roleAsync.value ?? StaffRole.staff;

    // Primary 4 tabs: 0: Dashboard, 1: Quick Sale, 2: Orders, 3: Products
    final mainDestinations = destinations.take(4).toList();

    // Additional management options: 4: Customers, 5: Staff
    final otherDestinations = destinations.skip(4).toList();

    return Drawer(
      width: 275,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ── Compact Light Header (No Black) ────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: AppColors.slate50,
                border: Border(
                  bottom: BorderSide(color: AppColors.slate200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.greenNude,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.greenNude,
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      size: 20,
                      color: AppColors.slate800,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user?.shopName.isNotEmpty == true
                              ? user!.shopName
                              : 'Shop POS',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.fullName.isNotEmpty == true
                              ? user!.fullName
                              : (user?.email ?? 'Staff Member'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greenNude,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.greenNude.withValues(alpha: 0.6),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      role.value.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.slate800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Drawer Menu Items (Compact & Tidy) ─────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                children: [
                  // Other / Management Section ("other use drawer in mobile")
                  const _DrawerSectionLabel(title: 'Management'),
                  for (int i = 0; i < otherDestinations.length; i++) ...[
                    _DrawerTile(
                      destination: otherDestinations[i],
                      isSelected: selectedIndex == (4 + i),
                      onTap: () {
                        Navigator.of(context).pop();
                        onDestinationSelected(4 + i);
                      },
                    ),
                  ],
                  _DrawerTile(
                    destination: const AppNavDestination(
                      label: 'Browse for Customer',
                      icon: Icon(Icons.style_outlined),
                      selectedIcon: Icon(Icons.style),
                      route: '/browse-for-customer',
                    ),
                    isSelected: false,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/browse-for-customer');
                    },
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: Divider(color: AppColors.slate200, height: 1),
                  ),

                  // Main Navigation Section
                  const _DrawerSectionLabel(title: 'Main Navigation'),
                  for (int i = 0; i < mainDestinations.length; i++) ...[
                    _DrawerTile(
                      destination: mainDestinations[i],
                      isSelected: selectedIndex == i,
                      onTap: () {
                        Navigator.of(context).pop();
                        onDestinationSelected(i);
                      },
                    ),
                  ],
                ],
              ),
            ),

            // ── Compact Light Footer with Sign Out ─────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.slate200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _confirmSignOut(context, ref),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.logout_rounded,
                                size: 17,
                                color: AppColors.danger,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Sign Out',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.danger,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.slate400,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.of(context).pop(); // close drawer
      await ref.read(authControllerProvider.notifier).logout();
    }
  }
}

class _DrawerSectionLabel extends StatelessWidget {
  const _DrawerSectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.slate400,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final AppNavDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.5),
      child: Material(
        color: isSelected
            ? AppColors.greenNude.withValues(alpha: 0.22)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          splashColor: AppColors.greenNude.withValues(alpha: 0.25),
          highlightColor: AppColors.slate100,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(
                      color: AppColors.greenNude.withValues(alpha: 0.6),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                IconTheme(
                  data: IconThemeData(
                    color: isSelected ? AppColors.slate800 : AppColors.slate500,
                    size: 19,
                  ),
                  child:
                      isSelected ? destination.selectedIcon : destination.icon,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    destination.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color:
                          isSelected ? AppColors.slate900 : AppColors.slate700,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.slate800,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Tablet — sliding icon rail ─────────────────────────────────────────────────

class _TabletScaffold extends StatelessWidget {
  const _TabletScaffold({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
  });

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  // Fixed geometry
  static const double _iconSize = 40.0; // per-item height in Stack
  static const double _topOffset = 68.0; // logo(20+32+16) = 68

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 64,
            child: ColoredBox(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.slate900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.storefront,
                        size: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.slate100),
                  const SizedBox(height: 8),
                  // Sliding icon area
                  SizedBox(
                    height: destinations.length * _iconSize,
                    child: Stack(
                      children: [
                        // Sliding background pill
                        AnimatedPositioned(
                          duration: _kSlideDuration,
                          curve: _kSlideCurve,
                          top: selectedIndex * _iconSize + 2,
                          left: 12,
                          right: 12,
                          height: _iconSize - 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.slate100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        // Icons (foreground)
                        Column(
                          children: List.generate(destinations.length, (i) {
                            final isSelected = i == selectedIndex;
                            return Tooltip(
                              message: destinations[i].label,
                              preferBelow: false,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => onDestinationSelected(i),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: _iconSize,
                                    child: Center(
                                      child: AnimatedSwitcher(
                                        duration: _kSlideDuration,
                                        child: IconTheme(
                                          key: ValueKey(isSelected),
                                          data: IconThemeData(
                                            color: isSelected
                                                ? AppColors.slate900
                                                : AppColors.slate400,
                                            size: 20,
                                          ),
                                          child: isSelected
                                              ? destinations[i].selectedIcon
                                              : destinations[i].icon,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(width: 1, color: AppColors.slate100),
          Expanded(child: body),
        ],
      ),
    );
  }
}

// ── Desktop — sliding sidebar ──────────────────────────────────────────────────

class _DesktopScaffold extends StatelessWidget {
  const _DesktopScaffold({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
  });

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  static const double _sidebarWidth = 84;

  // Fixed item height — must match _SidebarItem's SizedBox height
  static const double _itemH = 64.0;

  // Vertical offset to the first nav item:
  static const double _navTop = 100.0;

  @override
  Widget build(BuildContext context) {
    // Do NOT wrap in Scaffold here. _DesktopScaffold is rendered directly by
    // GoRouter as a page-level widget and already receives tight full-screen
    // constraints. Using Scaffold(body: Row) would loosen those constraints
    // before they reach Expanded(child: body), causing unbounded-height crashes
    // deep in the StatefulNavigationShell → IndexedStack → content chain.
    return Material(
      color: AppColors.slate900,
      child: Column(
        children: [
          if (!kIsWeb &&
              (Platform.isWindows || Platform.isMacOS || Platform.isLinux))
            const SizedBox(
              height: 32,
              child: WindowCaption(
                brightness: Brightness.dark,
                backgroundColor: Colors.transparent,
              ),
            ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: _sidebarWidth,
                  child: Stack(
                    children: [
                      // ── Sliding background pill ─────────────────────────────
                      AnimatedPositioned(
                        duration: _kSlideDuration,
                        curve: _kSlideCurve,
                        top: _navTop + selectedIndex * _itemH + 8,
                        left: 12,
                        right: 12,
                        height: _itemH - 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.greenNude,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      // ── Sidebar content ────────────────────────────────────
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Wordmark
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Center(
                              child: Icon(
                                Icons.storefront,
                                size: 32,
                                color: AppColors.greenNude,
                              ),
                            ),
                          ),

                          const SizedBox(height: 44),

                          // Nav items — each must be exactly _itemH px tall
                          ...List.generate(destinations.length, (i) {
                            return _SidebarItem(
                              destination: destinations[i],
                              isSelected: i == selectedIndex,
                              itemHeight: _itemH,
                              onTap: () => onDestinationSelected(i),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 10, right: 5),
                    decoration: BoxDecoration(
                      color: AppColors.slate100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Single nav item — **no background** (the sliding pill is handled by parent).
/// Must stay exactly [itemHeight] px tall.
class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.destination,
    required this.isSelected,
    required this.itemHeight,
    required this.onTap,
  });

  final AppNavDestination destination;
  final bool isSelected;
  final double itemHeight;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return Tooltip(
      message: widget.destination.label,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 300),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: SizedBox(
            height: widget.itemHeight, // exact height — must match _navTop math
            width: double.infinity,
            child: Center(
              child: AnimatedSwitcher(
                duration: _kSlideDuration,
                child: IconTheme(
                  key: ValueKey(isSelected),
                  data: IconThemeData(
                    color: isSelected
                        ? AppColors.slate900
                        : _hovered
                            ? Colors.white
                            : AppColors.slate400,
                    size: 24,
                  ),
                  child: isSelected
                      ? widget.destination.selectedIcon
                      : widget.destination.icon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
