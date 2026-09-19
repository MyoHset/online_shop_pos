import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FilterChipList extends StatelessWidget {
  const FilterChipList({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String label;
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(
                  'All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        selected == null ? FontWeight.w600 : FontWeight.w500,
                    color: AppColors.slate900,
                  ),
                ),
                selected: selected == null,
                selectedColor: AppColors.greenNude,
                backgroundColor: Colors.white,
                showCheckmark: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: selected == null
                        ? AppColors.greenNude
                        : AppColors.slate200,
                    width: 1,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onSelected: (_) => onSelected(null),
              ),
            ),
            ...options.map((option) {
              final isSelected = selected == option;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
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
                      color:
                          isSelected ? AppColors.greenNude : AppColors.slate200,
                      width: 1,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  onSelected: (_) => onSelected(isSelected ? null : option),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
