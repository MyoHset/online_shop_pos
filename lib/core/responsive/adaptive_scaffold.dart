import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../responsive/device_type.dart';
import '../responsive/responsive_extensions.dart';

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
/// - [BottomNavigationBar] on mobile (< 600 px)
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
    return Scaffold(
      body: body,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.slate200)),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onDestinationSelected,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.slate900,
          unselectedItemColor: AppColors.slate400,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            letterSpacing: 0.2,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 11,
          ),
          items: destinations
              .map(
                (d) => BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: d.icon,
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: d.selectedIcon,
                  ),
                  label: d.label,
                ),
              )
              .toList(),
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
  static const double _iconSize = 40.0;   // per-item height in Stack
  static const double _topOffset = 68.0;  // logo(20+32+16) = 68

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

  static const double _sidebarWidth = 220;

  // Fixed item height — must match _SidebarItem's SizedBox height
  static const double _itemH = 40.0;

  // Vertical offset to the first nav item:
  // paddingTop(22) + logo(28) + gap(20) + divider(1) + gap(8) + menuLabel(24) = 103
  static const double _navTop = 103.0;

  @override
  Widget build(BuildContext context) {
    // Do NOT wrap in Scaffold here. _DesktopScaffold is rendered directly by
    // GoRouter as a page-level widget and already receives tight full-screen
    // constraints. Using Scaffold(body: Row) would loosen those constraints
    // before they reach Expanded(child: body), causing unbounded-height crashes
    // deep in the StatefulNavigationShell → IndexedStack → content chain.
    return ColoredBox(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: _sidebarWidth,
            child: ColoredBox(
              color: Colors.white,
              child: Stack(
                children: [
                  // ── Sliding background pill ─────────────────────────────
                  AnimatedPositioned(
                    duration: _kSlideDuration,
                    curve: _kSlideCurve,
                    top: _navTop + selectedIndex * _itemH + 1,
                    left: 10,
                    right: 10,
                    height: _itemH - 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),

                  // ── Sidebar content ────────────────────────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wordmark
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.slate900,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.storefront,
                                  size: 16, color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Shop POS',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate900,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(height: 1, color: AppColors.slate100),
                      ),
                      const SizedBox(height: 8),

                      // Section label  (height ≈ 24px → top of items = 103)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 4, 20, 6),
                        child: Text(
                          'MENU',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            color: AppColors.slate400,
                          ),
                        ),
                      ),

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
          ),
          Container(width: 1, color: AppColors.slate100),
          Expanded(child: body),
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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          height: widget.itemHeight, // exact height — must match _navTop math
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                // Left accent bar — slides with the pill via AnimatedOpacity
                AnimatedOpacity(
                  duration: _kSlideDuration,
                  opacity: isSelected ? 1.0 : 0.0,
                  child: Container(
                    width: 3,
                    height: 16,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppColors.slate900,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (!isSelected)
                  const SizedBox(width: 13), // keeps layout stable

                // Icon
                AnimatedSwitcher(
                  duration: _kSlideDuration,
                  child: IconTheme(
                    key: ValueKey(isSelected),
                    data: IconThemeData(
                      color: isSelected
                          ? AppColors.slate900
                          : _hovered
                              ? AppColors.slate600
                              : AppColors.slate400,
                      size: 18,
                    ),
                    child: isSelected
                        ? widget.destination.selectedIcon
                        : widget.destination.icon,
                  ),
                ),
                const SizedBox(width: 12),

                // Label
                AnimatedDefaultTextStyle(
                  duration: _kSlideDuration,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.slate900
                        : _hovered
                            ? AppColors.slate600
                            : AppColors.slate500,
                    letterSpacing: -0.1,
                  ),
                  child: Text(widget.destination.label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
