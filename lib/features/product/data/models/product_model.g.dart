// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: json['id'] as String,
      shopId: json['shop_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      basePrice: (json['base_price'] as num).toDouble(),
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      productCode: json['product_code'] as String?,
      isActive: json['is_active'] as bool,
      productVariants: (json['product_variants'] as List<dynamic>?)
              ?.map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shop_id': instance.shopId,
      'name': instance.name,
      'description': instance.description,
      'base_price': instance.basePrice,
      'category': instance.category,
      'brand': instance.brand,
      'product_code': instance.productCode,
      'is_active': instance.isActive,
      'product_variants': instance.productVariants,
    };
