import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A reusable, highly customizable data table component that defaults to 
/// stretching full width, while remaining horizontally scrollable on smaller screens.
class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.headingRowColor,
    this.dataRowColor,
    this.dataRowMaxHeight = 64,
    this.horizontalMargin = 24,
    this.columnSpacing = 56,
    this.minWidth,
  });

  /// The configuration and labels for the columns.
  final List<DataColumn> columns;

  /// The data to display in each row.
  final List<DataRow> rows;

  /// The background color for the heading row. Defaults to [AppColors.slate50].
  final Color? headingRowColor;

  /// The background color for the data rows.
  final Color? dataRowColor;

  /// The maximum height of each data row.
  final double dataRowMaxHeight;

  /// The horizontal margin between the edges of the table and the content.
  final double horizontalMargin;

  /// The horizontal margin between the contents of each data column.
  final double columnSpacing;
  
  /// If provided, the table will take at least this width.
  /// This ensures horizontal scrolling triggers when the screen is too narrow,
  /// but allows the table to stretch to fill wide screens.
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: minWidth ?? constraints.maxWidth,
            ),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(headingRowColor ?? AppColors.slate50),
              dataRowColor: dataRowColor != null ? WidgetStateProperty.all(dataRowColor) : null,
              dataRowMaxHeight: dataRowMaxHeight,
              horizontalMargin: horizontalMargin,
              columnSpacing: columnSpacing,
              columns: columns,
              rows: rows,
            ),
          ),
        );
      },
    );
  }
}
