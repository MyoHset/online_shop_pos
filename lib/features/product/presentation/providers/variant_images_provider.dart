import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/variant_image.dart';
import 'product_list_provider.dart';

/// Provider for fetching all images of a specific variant.
final variantImagesProvider = FutureProvider.family.autoDispose<List<VariantImage>, String>(
  (ref, variantId) async {
    final repository = ref.watch(productRepositoryProvider);
    final result = await repository.getVariantImages(variantId);
    return result.fold(
      (failure) => throw failure,
      (images) => images,
    );
  },
);
