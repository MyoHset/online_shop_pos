import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';
import '../models/variant_image_model.dart';
import '../models/variant_model.dart';

/// Remote data source for all product/variant Supabase operations.
///
/// This is the ONLY place in the codebase where Supabase table queries
/// related to products are written. All methods throw internal [Exception]
/// subtypes that are caught and mapped to [Failure]s in the repository.
class ProductRemoteDataSource {
  const ProductRemoteDataSource(this._client);

  final SupabaseClient _client;

  static const String _productSelect = '''
    *,
    product_variants(
      *,
      variant_images(*)
    )
  ''';

  Future<List<ProductModel>> getProducts({
    String? searchQuery,
    String? category,
    int page = 0,
    int pageSize = 30,
  }) async {
    try {
      var query = _client
          .from(SupabaseConstants.productsTable)
          .select(_productSelect)
          .eq('is_active', true);

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.ilike('name', '%$searchQuery%');
      }
      if (category != null && category.isNotEmpty) {
        query = query.eq('category', category);
      }

      final data = await query
          .order('name')
          .range(page * pageSize, (page + 1) * pageSize - 1);
      return (data as List)
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final data = await _client
          .from(SupabaseConstants.productsTable)
          .select(_productSelect)
          .eq('id', id)
          .single();
      return ProductModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<ProductModel> createProduct({
    required String name,
    String? description,
    required double basePrice,
    String? category,
    String? brand,
    String? productCode,
  }) async {
    try {
      final data = await _client
          .from(SupabaseConstants.productsTable)
          .insert({
            'name': name,
            'description': description,
            'base_price': basePrice,
            'category': category,
            'brand': brand,
            'product_code': productCode,
            'is_active': true,
          })
          .select(_productSelect)
          .single();
      return ProductModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<ProductModel> updateProduct({
    required String id,
    String? name,
    String? description,
    double? basePrice,
    String? category,
    String? brand,
    String? productCode,
    bool? isActive,
  }) async {
    try {
      final updates = <String, dynamic>{
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (basePrice != null) 'base_price': basePrice,
        if (category != null) 'category': category,
        if (brand != null) 'brand': brand,
        if (productCode != null) 'product_code': productCode,
        if (isActive != null) 'is_active': isActive,
      };

      final data = await _client
          .from(SupabaseConstants.productsTable)
          .update(updates)
          .eq('id', id)
          .select(_productSelect)
          .single();
      return ProductModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<VariantModel> createVariant({
    required String productId,
    String? size,
    String? color,
    double? priceOverride,
    required int stockQuantity,
    int? weightGrams,
  }) async {
    try {
      final data = await _client
          .from(SupabaseConstants.productVariantsTable)
          .insert({
            'product_id': productId,
            'size': size,
            'color': color,
            'price_override': priceOverride,
            'stock_quantity': stockQuantity,
            'stock_reserved': 0,
            'weight_grams': weightGrams,
            'is_active': true,
          })
          .select('*, variant_images(*)')
          .single();
      return VariantModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<VariantModel> updateVariant({
    required String id,
    String? size,
    String? color,
    double? priceOverride,
    int? stockQuantity,
    int? weightGrams,
    bool? isActive,
  }) async {
    try {
      final updates = <String, dynamic>{
        if (size != null) 'size': size,
        if (color != null) 'color': color,
        if (priceOverride != null) 'price_override': priceOverride,
        if (stockQuantity != null) 'stock_quantity': stockQuantity,
        if (weightGrams != null) 'weight_grams': weightGrams,
        if (isActive != null) 'is_active': isActive,
      };

      final data = await _client
          .from(SupabaseConstants.productVariantsTable)
          .update(updates)
          .eq('id', id)
          .select('*, variant_images(*)')
          .single();
      return VariantModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<VariantImageModel> uploadVariantImage({
    required String variantId,
    required File imageFile,
    required bool isPrimary,
  }) async {
    try {
      final fileExt = imageFile.path.split('.').last;
      final fileName =
          '${variantId}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final storagePath = 'variants/$variantId/$fileName';

      await _client.storage
          .from(SupabaseConstants.variantImagesBucket)
          .upload(storagePath, imageFile);

      final imageUrl = _client.storage
          .from(SupabaseConstants.variantImagesBucket)
          .getPublicUrl(storagePath);

      // If this is the primary image, unset others first
      if (isPrimary) {
        await _client
            .from(SupabaseConstants.variantImagesTable)
            .update({'is_primary': false})
            .eq('variant_id', variantId);
      }

      // Get current max sort_order
      final existing = await _client
          .from(SupabaseConstants.variantImagesTable)
          .select('sort_order')
          .eq('variant_id', variantId)
          .order('sort_order', ascending: false)
          .limit(1);
      final maxSortOrder =
          existing.isEmpty ? 0 : (existing.first['sort_order'] as int);

      final data = await _client
          .from(SupabaseConstants.variantImagesTable)
          .insert({
            'variant_id': variantId,
            'image_url': imageUrl,
            'is_primary': isPrimary,
            'sort_order': maxSortOrder + 1,
          })
          .select()
          .single();

      return VariantImageModel.fromJson(data);
    } on StorageException catch (e) {
      throw ImageUploadException(e.message);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteVariantImage(String imageId) async {
    try {
      // Get the image URL first to delete from storage
      final data = await _client
          .from(SupabaseConstants.variantImagesTable)
          .select('image_url')
          .eq('id', imageId)
          .single();

      final imageUrl = data['image_url'] as String;

      // Extract storage path from public URL
      final uri = Uri.parse(imageUrl);
      final storagePath = uri.pathSegments
          .skipWhile((s) => s != SupabaseConstants.variantImagesBucket)
          .skip(1)
          .join('/');

      await _client.storage
          .from(SupabaseConstants.variantImagesBucket)
          .remove([storagePath]);

      await _client
          .from(SupabaseConstants.variantImagesTable)
          .delete()
          .eq('id', imageId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
