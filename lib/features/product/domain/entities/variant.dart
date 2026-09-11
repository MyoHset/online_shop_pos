import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/app_constants.dart';
import 'variant_image.dart';

part 'variant.freezed.dart';

/// Product variant entity — pure Dart, no framework or Supabase dependencies.
@freezed
abstract class Variant with _$Variant {
  const factory Variant({
    required String id,
    required String productId,
    required String? size,
    required String? color,
    required String sku,
    required double? priceOverride,
    required int stockQuantity,
    required int stockReserved,
    required int? weightGrams,
    required bool isActive,
    @Default([]) List<VariantImage> images,
  }) = _Variant;

  const Variant._();

  /// Available stock = total stock minus reserved quantity.
  int get availableStock => (stockQuantity - stockReserved).clamp(0, stockQuantity);

  /// Whether this variant's available stock is critically low.
  bool get isLowStock =>
      availableStock > 0 && availableStock <= AppConstants.lowStockThreshold;

  /// Whether this variant has zero available stock.
  bool get isOutOfStock => availableStock <= 0;

  /// The effective selling price (override if set, otherwise falls back to
  /// the product's base price — resolved at presentation layer).
  double? get effectivePrice => priceOverride;

  /// The primary image URL for this variant, if any.
  String? get primaryImageUrl =>
      images.where((img) => img.isPrimary).firstOrNull?.imageUrl ??
      images.firstOrNull?.imageUrl;

  /// A human-readable display name combining size and color.
  String get displayName {
    final parts = [if (size != null) size!, if (color != null) color!];
    return parts.isEmpty ? sku : parts.join(' / ');
  }
}
