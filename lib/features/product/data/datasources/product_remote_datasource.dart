import 'dart:io';
import 'package:flutter/foundation.dart';
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

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _logCall(String fn, [Map<String, dynamic>? params]) {
    debugPrint('[Supabase] ▶ $fn${params != null ? ' | params: $params' : ''}');
  }

  void _logError(String fn, Object error, StackTrace stack) {
    debugPrint('[Supabase] ✖ $fn | ${error.runtimeType}: $error');
    debugPrint('[Supabase]   StackTrace:\n$stack');
  }

  // ── Product CRUD ─────────────────────────────────────────────────────────────

  Future<List<ProductModel>> getProducts({
    String? searchQuery,
    String? category,
    String? shopId,
    int page = 0,
    int pageSize = 30,
  }) async {
    _logCall('getProducts', {
      'searchQuery': searchQuery,
      'category': category,
      'shopId': shopId,
      'page': page,
      'pageSize': pageSize,
    });
    try {
      var query = _client
          .from(SupabaseConstants.productsTable)
          .select(_productSelect)
          .eq('is_active', true);

      // if (shopId != null && shopId.isNotEmpty) {
      //   query = query.eq('shop_id', shopId);
      // }
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
    } on PostgrestException catch (e, s) {
      _logError('getProducts', e, s);
      throw ServerException(e.message);
    } catch (e, s) {
      _logError('getProducts', e, s);
      throw ServerException(e.toString());
    }
  }

  Future<ProductModel> getProductById(String id) async {
    _logCall('getProductById', {'id': id});
    try {
      final data = await _client
          .from(SupabaseConstants.productsTable)
          .select(_productSelect)
          .eq('id', id)
          .single();
      return ProductModel.fromJson(data);
    } on PostgrestException catch (e, s) {
      _logError('getProductById', e, s);
      throw ServerException(e.message);
    } catch (e, s) {
      _logError('getProductById', e, s);
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
    String? shopId,
  }) async {
    _logCall('createProduct', {
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'category': category,
      'brand': brand,
      'productCode': productCode,
      'shopId': shopId,
    });
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
            if (shopId != null) 'shop_id': shopId,
            'is_active': true,
          })
          .select(_productSelect)
          .single();
      return ProductModel.fromJson(data);
    } on PostgrestException catch (e, s) {
      _logError('createProduct', e, s);
      throw ServerException(e.message);
    } catch (e, s) {
      _logError('createProduct', e, s);
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
    _logCall('updateProduct', {
      'id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'category': category,
      'brand': brand,
      'productCode': productCode,
      'isActive': isActive,
    });
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
    } on PostgrestException catch (e, s) {
      _logError('updateProduct', e, s);
      throw ServerException(e.message);
    } catch (e, s) {
      _logError('updateProduct', e, s);
      throw ServerException(e.toString());
    }
  }

  // ── Variant CRUD ─────────────────────────────────────────────────────────────

  Future<VariantModel> createVariant({
    required String productId,
    String? size,
    String? color,
    double? priceOverride,
    required int stockQuantity,
    int? weightGrams,
  }) async {
    _logCall('createVariant', {
      'productId': productId,
      'size': size,
      'color': color,
      'priceOverride': priceOverride,
      'stockQuantity': stockQuantity,
      'weightGrams': weightGrams,
    });
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
    } on PostgrestException catch (e, s) {
      _logError('createVariant', e, s);
      throw ServerException(e.message);
    } catch (e, s) {
      _logError('createVariant', e, s);
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
    _logCall('updateVariant', {
      'id': id,
      'size': size,
      'color': color,
      'priceOverride': priceOverride,
      'stockQuantity': stockQuantity,
      'weightGrams': weightGrams,
      'isActive': isActive,
    });
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
    } on PostgrestException catch (e, s) {
      _logError('updateVariant', e, s);
      throw ServerException(e.message);
    } catch (e, s) {
      _logError('updateVariant', e, s);
      throw ServerException(e.toString());
    }
  }

}
