/// Supabase project configuration.
///
/// Replace these placeholder values with your actual Supabase project URL
/// and anon key before running the application.
class SupabaseConstants {
  SupabaseConstants._();

  /// Your Supabase project URL.
  /// Example: 'https://xyzcompany.supabase.co'
  static const String supabaseUrl = 'https://fjikjxvsspoqrztexlmw.supabase.co';

  /// Your Supabase project anon key.
  static const String supabaseAnonKey =
      'sb_publishable_rSKZEIik1PO51c-qyHc5Zg_ftdI6mnv';

  // Table names
  static const String productsTable = 'products';
  static const String productVariantsTable = 'product_variants';
  static const String variantImagesTable = 'variant_images';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';
  static const String paymentsTable = 'payments';

  // Storage buckets
  static const String variantImagesBucket = 'variant-images';

  // RPC function names
  static const String reserveStockRpc = 'reserve_stock';
  static const String releaseStockRpc = 'release_stock';
  static const String confirmStockDeductionRpc = 'confirm_stock_deduction';
}
