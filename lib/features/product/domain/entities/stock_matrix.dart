import 'variant.dart';

class StockMatrix {
  const StockMatrix({
    required this.sizes,
    required this.colors,
    required this.stockByKey,
    required this.variantIdByKey,
  });

  final List<String> sizes;
  final List<String> colors;
  
  /// Key format: '$size-$color' -> available stock
  final Map<String, int?> stockByKey;
  
  /// Key format: '$size-$color' -> variant id
  final Map<String, String?> variantIdByKey;

  int? stockFor(String size, String color) => stockByKey['$size-$color'];
  
  String? variantIdFor(String size, String color) => variantIdByKey['$size-$color'];

  factory StockMatrix.fromVariants(List<Variant> variants) {
    final sizes = variants.map((v) => v.size?.trim().isNotEmpty == true ? v.size! : 'Default').toSet().toList()..sort();
    final colors = variants.map((v) => v.color?.trim().isNotEmpty == true ? v.color! : 'Default').toSet().toList()..sort();
    
    final stockByKey = <String, int?>{};
    final variantIdByKey = <String, String?>{};
    
    for (final v in variants) {
      final size = v.size?.trim().isNotEmpty == true ? v.size! : 'Default';
      final color = v.color?.trim().isNotEmpty == true ? v.color! : 'Default';
      final key = '$size-$color';
      
      stockByKey[key] = v.availableStock;
      variantIdByKey[key] = v.id;
    }
    
    return StockMatrix(
      sizes: sizes,
      colors: colors,
      stockByKey: stockByKey,
      variantIdByKey: variantIdByKey,
    );
  }
}
