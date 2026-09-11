import 'package:flutter/widgets.dart';
import 'device_type.dart';

/// Responsive utility extensions on [BuildContext].
extension ResponsiveExtensions on BuildContext {
  /// The resolved [DeviceType] for the current screen width.
  DeviceType get deviceType => DeviceType.from(this);

  /// Returns `true` if the screen width is in the mobile range (< 600 px).
  bool get isMobile => deviceType.isMobile;

  /// Returns `true` if the screen width is in the tablet range (600–1023 px).
  bool get isTablet => deviceType.isTablet;

  /// Returns `true` if the screen width is in desktop/large range (≥ 1024 px).
  bool get isDesktop => deviceType.isDesktop;

  /// Returns a value appropriate for the current [DeviceType].
  ///
  /// If [tablet] or [desktop] are omitted, [mobile] is used as fallback.
  ///
  /// ```dart
  /// final fontSize = context.responsiveValue(
  ///   mobile: 14.0,
  ///   tablet: 16.0,
  ///   desktop: 18.0,
  /// );
  /// ```
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
      case DeviceType.large:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Horizontal content padding that scales with device type.
  double get horizontalPadding => responsiveValue(
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      );
}
