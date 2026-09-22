import 'package:freezed_annotation/freezed_annotation.dart';

part 'variant_detail.freezed.dart';

@freezed
abstract class VariantDetail with _$VariantDetail {
  const factory VariantDetail({
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
  }) = _VariantDetail;
}
