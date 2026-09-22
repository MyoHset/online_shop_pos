import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/stock_matrix.dart';
import 'product_detail_provider.dart';

final stockMatrixProvider = Provider.family<StockMatrix?, String>((ref, productId) {
  final productAsync = ref.watch(productDetailProvider(productId));
  
  return productAsync.maybeWhen(
    data: (product) => StockMatrix.fromVariants(product.variants),
    orElse: () => null,
  );
});
