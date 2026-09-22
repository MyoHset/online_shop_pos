// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VariantDetailModel _$VariantDetailModelFromJson(Map<String, dynamic> json) =>
    _VariantDetailModel(
      shopId: json['shop_id'] as String?,
      productName: json['product_name'] as String,
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      variantId: json['variant_id'] as String,
      sku: json['sku'] as String?,
      size: json['size'] as String?,
      color: json['color'] as String?,
      finalPrice: (json['final_price'] as num).toDouble(),
      availableStock: (json['available_stock'] as num).toInt(),
      primaryImage: json['primary_image'] as String?,
    );

Map<String, dynamic> _$VariantDetailModelToJson(_VariantDetailModel instance) =>
    <String, dynamic>{
      'shop_id': instance.shopId,
      'product_name': instance.productName,
      'category': instance.category,
      'brand': instance.brand,
      'variant_id': instance.variantId,
      'sku': instance.sku,
      'size': instance.size,
      'color': instance.color,
      'final_price': instance.finalPrice,
      'available_stock': instance.availableStock,
      'primary_image': instance.primaryImage,
    };
