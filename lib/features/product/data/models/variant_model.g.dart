// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VariantModel _$VariantModelFromJson(Map<String, dynamic> json) =>
    _VariantModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      size: json['size'] as String?,
      color: json['color'] as String?,
      sku: json['sku'] as String,
      priceOverride: (json['price_override'] as num?)?.toDouble(),
      stockQuantity: (json['stock_quantity'] as num).toInt(),
      stockReserved: (json['stock_reserved'] as num).toInt(),
      weightGrams: (json['weight_grams'] as num?)?.toInt(),
      isActive: json['is_active'] as bool,
      variantImages: (json['variant_images'] as List<dynamic>?)
              ?.map(
                  (e) => VariantImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$VariantModelToJson(_VariantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'size': instance.size,
      'color': instance.color,
      'sku': instance.sku,
      'price_override': instance.priceOverride,
      'stock_quantity': instance.stockQuantity,
      'stock_reserved': instance.stockReserved,
      'weight_grams': instance.weightGrams,
      'is_active': instance.isActive,
      'variant_images': instance.variantImages,
    };
