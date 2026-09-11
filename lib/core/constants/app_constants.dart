/// Application-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'Shop POS';
  static const int productPageSize = 30;
  static const int orderPageSize = 20;
  static const int lowStockThreshold = 5;

  /// Maximum image size for upload in bytes (5 MB).
  static const int maxImageSizeBytes = 5 * 1024 * 1024;
}
