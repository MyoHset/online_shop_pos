import 'package:flutter/material.dart';
import 'filter_chip_list.dart';
import 'search_text_field.dart';

class CategorySearchBar extends StatelessWidget {
  const CategorySearchBar({
    required this.categories,
    required this.brands,
    required this.selectedCategory,
    required this.selectedBrand,
    required this.searchQuery,
    required this.onCategoryChanged,
    required this.onBrandChanged,
    required this.onSearchChanged,
    this.searchWidth,
    super.key,
  });

  final List<String> categories;
  final List<String> brands;
  final String? selectedCategory;
  final String? selectedBrand;
  final String searchQuery;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onBrandChanged;
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
        FilterChipList(
          label: 'Category',
          options: categories,
          selected: selectedCategory,
          onSelected: onCategoryChanged,
        ),
        const SizedBox(height: 8),
        FilterChipList(
          label: 'Brand',
          options: brands,
          selected: selectedBrand,
          onSelected: onBrandChanged,
        ),
      ],
    );
  }
}
