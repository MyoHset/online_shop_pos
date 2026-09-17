import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'product_list_provider.dart';

part 'product_brands_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> productBrands(Ref ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getBrands();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (brands) => brands,
  );
}
