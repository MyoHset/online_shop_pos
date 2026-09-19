import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/stock_matrix.dart';
import 'stock_matrix_cell.dart';
import 'stock_matrix_empty_cell.dart';

class StockMatrixTable extends StatelessWidget {
  const StockMatrixTable({
    required this.productId,
    required this.matrix,
    super.key,
  });

  final String productId;
  final StockMatrix matrix;

  @override
  Widget build(BuildContext context) {
    if (matrix.colors.isEmpty || matrix.sizes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'No variant data available for matrix view.',
            style: TextStyle(color: AppColors.slate500),
          ),
        ),
      );
    }

    final bool needsScroll = matrix.colors.length > 4;

    Widget table = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        border: TableBorder.all(
          color: AppColors.slate200,
          width: 1,
          borderRadius: BorderRadius.circular(8),
        ),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // Header Row (Colors)
          TableRow(
            decoration: const BoxDecoration(color: AppColors.slate50),
            children: [
              // Top-left corner
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                alignment: Alignment.center,
                child: const Text(
                  'Size \\ Color',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate500,
                    fontSize: 13,
                  ),
                ),
              ),
              ...matrix.colors.map((color) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text(
                      color,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate700,
                      ),
                    ),
                  )),
            ],
          ),
          // Data Rows (Sizes)
          ...matrix.sizes.map((size) {
            return TableRow(
              children: [
                // Row Header (Size)
                Container(
                  color: AppColors.slate50,
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    size,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate700,
                    ),
                  ),
                ),
                // Data Cells
                ...matrix.colors.map((color) {
                  final stock = matrix.stockFor(size, color);
                  final variantId = matrix.variantIdFor(size, color);
                  
                  return Container(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: stock != null && variantId != null
                        ? StockMatrixCell(
                            productId: productId,
                            variantId: variantId,
                            stock: stock,
                          )
                        : StockMatrixEmptyCell(
                            productId: productId,
                            size: size,
                            color: color,
                          ),
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );

    if (needsScroll) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: table,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: table,
    );
  }
}
