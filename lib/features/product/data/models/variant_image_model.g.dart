// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VariantImageModel _$VariantImageModelFromJson(Map<String, dynamic> json) =>
    _VariantImageModel(
      id: json['id'] as String,
      variantId: json['variant_id'] as String,
      imageUrl: json['image_url'] as String,
      isPrimary: json['is_primary'] as bool,
      sortOrder: (json['sort_order'] as num).toInt(),
    );

Map<String, dynamic> _$VariantImageModelToJson(_VariantImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variant_id': instance.variantId,
      'image_url': instance.imageUrl,
      'is_primary': instance.isPrimary,
      'sort_order': instance.sortOrder,
    };
