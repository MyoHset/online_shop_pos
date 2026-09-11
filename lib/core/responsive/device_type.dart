import 'package:flutter/widgets.dart';
import '../constants/breakpoints.dart';

/// Categorizes the current screen width into a device type.
enum DeviceType {
  /// < 600 px — phone / small mobile
  mobile,

  /// 600–1023 px — tablet / small laptop
  tablet,

  /// 1024–1439 px — desktop / web
  desktop,

  /// ≥ 1440 px — large desktop / wide monitor
  large;

  /// Resolves [DeviceType] from the current [BuildContext]'s screen width.
  static DeviceType from(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return fromWidth(width);
  }

  /// Resolves [DeviceType] from a raw pixel width value.
  static DeviceType fromWidth(double width) {
    if (width < AppBreakpoints.mobile) return DeviceType.mobile;
    if (width < AppBreakpoints.tablet) return DeviceType.tablet;
    if (width < AppBreakpoints.desktop) return DeviceType.desktop;
    return DeviceType.large;
  }

  bool get isMobile => this == DeviceType.mobile;
  bool get isTablet => this == DeviceType.tablet;
  bool get isDesktop => this == DeviceType.desktop || this == DeviceType.large;
  bool get isWide => this == DeviceType.desktop || this == DeviceType.large;
}
