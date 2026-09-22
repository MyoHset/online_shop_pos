import 'package:freezed_annotation/freezed_annotation.dart';
import 'variant.dart';

part 'product.freezed.dart';

/// Core product entity — pure Dart, no framework or Supabase dependencies.
@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    String? shopId,
    required String name,
    required String? description,
    required double basePrice,
    required String? category,
    required String? brand,
    required String? productCode,
    required bool isActive,
    @Default([]) List<Variant> variants,
  }) = _Product;

  const Product._();

  /// Total available stock across all active variants.
  int get totalAvailableStock => variants
      .where((v) => v.isActive)
      .fold(0, (sum, v) => sum + v.availableStock);

  /// Number of active variants.
  int get activeVariantCount => variants.where((v) => v.isActive).length;

  /// Whether any active variant is low on stock.
  bool get hasLowStockVariant =>
      variants.where((v) => v.isActive).any((v) => v.isLowStock);

  /// Whether all active variants are out of stock.
  bool get isOutOfStock =>
      variants.where((v) => v.isActive).every((v) => v.isOutOfStock);

  /// Representative image URL (from the variant with highest available stock).
  String? get primaryImageUrl {
    if (variants.isEmpty) return null;
    final activeVariants = variants.where((v) => v.isActive).toList();
    if (activeVariants.isEmpty) return null;
    activeVariants.sort((a, b) => b.availableStock.compareTo(a.availableStock));
    return activeVariants.first.primaryImageUrl;
  }
}
