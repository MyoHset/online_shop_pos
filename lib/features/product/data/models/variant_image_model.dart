import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/variant_image.dart';

part 'variant_image_model.freezed.dart';
part 'variant_image_model.g.dart';

/// Data model for [VariantImage] — includes JSON serialization for Supabase.
@freezed
abstract class VariantImageModel with _$VariantImageModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory VariantImageModel({
    required String id,
    required String variantId,
    required String imageUrl,
    required bool isPrimary,
    required int sortOrder,
  }) = _VariantImageModel;

  factory VariantImageModel.fromJson(Map<String, dynamic> json) =>
      _$VariantImageModelFromJson(json);

  const VariantImageModel._();

  /// Maps this data model to the domain [VariantImage] entity.
  VariantImage toEntity() => VariantImage(
        id: id,
        variantId: variantId,
        imageUrl: imageUrl,
        isPrimary: isPrimary,
        sortOrder: sortOrder,
      );
}
