import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/variant.dart';
import 'variant_image_model.dart';

part 'variant_model.freezed.dart';
part 'variant_model.g.dart';

/// Data model for [Variant] — includes JSON serialization for Supabase.
@freezed
abstract class VariantModel with _$VariantModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory VariantModel({
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
    @Default([]) List<VariantImageModel> variantImages,
  }) = _VariantModel;

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);

  const VariantModel._();

  /// Maps this data model to the domain [Variant] entity.
  Variant toEntity() => Variant(
        id: id,
        productId: productId,
        size: size,
        color: color,
        sku: sku,
        priceOverride: priceOverride,
        stockQuantity: stockQuantity,
        stockReserved: stockReserved,
        weightGrams: weightGrams,
        isActive: isActive,
        images: variantImages.map((img) => img.toEntity()).toList(),
      );
}
