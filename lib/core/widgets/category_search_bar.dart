import 'package:flutter/material.dart';
import 'category_chip_list.dart';
import 'search_text_field.dart';

class CategorySearchBar extends StatelessWidget {
  const CategorySearchBar({
    required this.categories,
    required this.selectedCategory,
    required this.searchQuery,
    required this.onCategoryChanged,
    required this.onSearchChanged,
    this.searchWidth,
    super.key,
  });

  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String> onSearchChanged;
  final double? searchWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchTextField(
          value: searchQuery,
          onChanged: onSearchChanged,
          width: searchWidth,
        ),
        const SizedBox(height: 8),
        CategoryChipList(
          categories: categories,
          selected: selectedCategory,
          onSelected: onCategoryChanged,
        ),
      ],
    );
  }
}
