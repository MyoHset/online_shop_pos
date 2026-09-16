import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/variant_image_model.dart';

class VariantImageRemoteDataSource {
  const VariantImageRemoteDataSource(this._client);

  final SupabaseClient _client;

  void _logCall(String fn, [Map<String, dynamic>? params]) {
    debugPrint('[Supabase] ▶ $fn${params != null ? ' | params: $params' : ''}');
  }

  void _logError(String fn, Object error, StackTrace stack) {
    debugPrint('[Supabase] ✖ $fn | ${error.runtimeType}: $error');
    debugPrint('[Supabase]   StackTrace:\n$stack');
  }

  Future<String> uploadFile(File file, {required String variantId, required String shopId}) async {
    _logCall('uploadFile', {
      'variantId': variantId,
      'shopId': shopId,
      'path': file.path,
    });
    try {
      final fileExt = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final storagePath = 'variants/$shopId/$variantId/$fileName';

      await _client.storage
          .from(SupabaseConstants.variantImagesBucket)
          .upload(storagePath, file);

      final imageUrl = _client.storage
          .from(SupabaseConstants.variantImagesBucket)
          .getPublicUrl(storagePath);

      return imageUrl;
    } on StorageException catch (e, s) {
      _logError('uploadFile', e, s);
      throw ImageUploadException(e.message);
    } catch (e, s) {
      _logError('uploadFile', e, s);
      throw ServerException(e.toString());
    }
  }

  Future<VariantImageModel> attachImage({
    required String variantId,
    required String imageUrl,
    required bool isPrimary,
  }) async {
    _logCall('attachImage', {
      'variantId': variantId,
      'imageUrl': imageUrl,
      'isPrimary': isPrimary,
    });
    try {
      if (isPrimary) {
        await _client
            .from(SupabaseConstants.variantImagesTable)
            .update({'is_primary': false})
            .eq('variant_id', variantId);
      }

      final existing = await _client
          .from(SupabaseConstants.variantImagesTable)
          .select('sort_order')
          .eq('variant_id', variantId)
          .order('sort_order', ascending: false)
          .limit(1);
      
      final maxSortOrder = existing.isEmpty ? 0 : (existing.first['sort_order'] as int);

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
    } on PostgrestException catch (e, s) {
      _logError('attachImage', e, s);
      throw ServerException(e.message);
    } catch (e, s) {
      _logError('attachImage', e, s);
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteImage(String imageId) async {
    _logCall('deleteImage', {'imageId': imageId});
    try {
      final data = await _client
          .from(SupabaseConstants.variantImagesTable)
          .select('image_url')
          .eq('id', imageId)
          .single();

      final imageUrl = data['image_url'] as String;
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
    } on PostgrestException catch (e, s) {
      _logError('deleteImage', e, s);
      throw ServerException(e.message);
    } catch (e, s) {
      _logError('deleteImage', e, s);
      throw ServerException(e.toString());
    }
  }
}
