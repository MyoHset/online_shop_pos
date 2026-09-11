/// Responsive layout breakpoints.
///
/// Use [DeviceType] resolver from [core/responsive/device_type.dart] rather
/// than comparing against these values directly in widgets.
class AppBreakpoints {
  AppBreakpoints._();

  /// Below this width → phone layout.
  static const double mobile = 600;

  /// 600–1023 → tablet / small laptop layout.
  static const double tablet = 1024;

  /// 1024–1439 → desktop / web layout.
  static const double desktop = 1440;

  /// ≥ 1440 → large desktop / wide monitor layout.
  static const double large = 1440;
}
