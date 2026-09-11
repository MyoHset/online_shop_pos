import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_detail.dart';

import 'product_list_provider.dart';

part 'product_detail_provider.g.dart';

@riverpod
GetProductDetail getProductDetailUseCase(Ref ref) {
  return GetProductDetail(ref.watch(productRepositoryProvider));
}

/// Provides a single product's full detail (with variants + images).
///
/// Uses `.family` so each product id gets its own cached state.
/// Uses `.autoDispose` so the state is cleared when no widget is listening.
@riverpod
Future<Product> productDetail(Ref ref, String productId) async {
  final useCase = ref.watch(getProductDetailUseCaseProvider);
  final result = await useCase(productId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
}
