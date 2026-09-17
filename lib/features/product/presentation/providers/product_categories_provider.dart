import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'product_list_provider.dart';

part 'product_categories_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> productCategories(Ref ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getCategories();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (categories) => categories,
  );
}
