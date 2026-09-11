import 'package:freezed_annotation/freezed_annotation.dart';

part 'variant_image.freezed.dart';

/// Image record associated with a product variant.
@freezed
abstract class VariantImage with _$VariantImage {
  const factory VariantImage({
    required String id,
    required String variantId,
    required String imageUrl,
    required bool isPrimary,
    required int sortOrder,
  }) = _VariantImage;
}
