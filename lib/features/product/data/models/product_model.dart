import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product.dart';
import 'variant_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Data model for [Product] — includes JSON serialization for Supabase.
@freezed
abstract class ProductModel with _$ProductModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProductModel({
    required String id,
    required String name,
    required String? description,
    required double basePrice,
    required String? category,
    required String? brand,
    required String? productCode,
    required bool isActive,
    @Default([]) List<VariantModel> productVariants,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  const ProductModel._();

  /// Maps this data model to the domain [Product] entity.
  Product toEntity() => Product(
        id: id,
        name: name,
        description: description,
        basePrice: basePrice,
        category: category,
        brand: brand,
        productCode: productCode,
        isActive: isActive,
        variants: productVariants.map((v) => v.toEntity()).toList(),
      );
}
