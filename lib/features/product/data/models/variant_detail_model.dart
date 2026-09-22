import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/variant_detail.dart';

part 'variant_detail_model.freezed.dart';
part 'variant_detail_model.g.dart';

@freezed
abstract class VariantDetailModel with _$VariantDetailModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory VariantDetailModel({
    String? shopId,
    required String productName,
    String? category,
    String? brand,
    required String variantId,
    String? sku,
    String? size,
    String? color,
    required double finalPrice,
    required int availableStock,
    String? primaryImage,
  }) = _VariantDetailModel;

  factory VariantDetailModel.fromJson(Map<String, dynamic> json) =>
      _$VariantDetailModelFromJson(json);

  const VariantDetailModel._();

  VariantDetail toEntity() => VariantDetail(
        shopId: shopId,
        productName: productName,
        category: category,
        brand: brand,
        variantId: variantId,
        sku: sku,
        size: size,
        color: color,
        finalPrice: finalPrice,
        availableStock: availableStock,
        primaryImage: primaryImage,
      );
}
