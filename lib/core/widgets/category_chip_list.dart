import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CategoryChipList extends StatelessWidget {
  const CategoryChipList({
    required this.categories,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  Widget _buildChip(String label, bool isSelected, VoidCallback onSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: AppColors.slate900,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.greenNude,
        backgroundColor: Colors.white,
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isSelected ? AppColors.greenNude : AppColors.slate200,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        onSelected: (_) => onSelected(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _buildChip(
            'All',
            selected == null,
            () => onSelected(null),
          ),
          ...categories.map((category) {
            return _buildChip(
              category,
              selected == category,
              () => onSelected(selected == category ? null : category),
            );
          }),
        ],
      ),
    );
  }
}
