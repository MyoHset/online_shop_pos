import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Opens a sleek top sheet dialog for filtering categories and brands.
void showFilterTopSheet(
  BuildContext context, {
  required List<String> categories,
  required List<String> brands,
  required String? selectedCategory,
  required String? selectedBrand,
  required ValueChanged<String?> onCategoryChanged,
  required ValueChanged<String?> onBrandChanged,
  required VoidCallback onReset,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss Filter',
    barrierColor: Colors.black.withValues(alpha: 0.35),
    transitionDuration: const Duration(milliseconds: 280),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(
          opacity: curved,
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.topCenter,
        child: _FilterTopSheetContent(
          categories: categories,
          brands: brands,
          selectedCategory: selectedCategory,
          selectedBrand: selectedBrand,
          onCategoryChanged: onCategoryChanged,
          onBrandChanged: onBrandChanged,
          onReset: onReset,
        ),
      );
    },
  );
}

class _FilterTopSheetContent extends StatefulWidget {
  const _FilterTopSheetContent({
    required this.categories,
    required this.brands,
    required this.selectedCategory,
    required this.selectedBrand,
    required this.onCategoryChanged,
    required this.onBrandChanged,
    required this.onReset,
  });

  final List<String> categories;
  final List<String> brands;
  final String? selectedCategory;
  final String? selectedBrand;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onBrandChanged;
  final VoidCallback onReset;

  @override
  State<_FilterTopSheetContent> createState() => _FilterTopSheetContentState();
}

class _FilterTopSheetContentState extends State<_FilterTopSheetContent> {
  late String? _category;
  late String? _brand;

  @override
  void initState() {
    super.initState();
    _category = widget.selectedCategory;
    _brand = widget.selectedBrand;
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = (_category != null ? 1 : 0) + (_brand != null ? 1 : 0);

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta != null && details.primaryDelta! < -6) {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.78,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppColors.slate900.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Sheet Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.greenNude.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.greenNude,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Filter Products',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.slate900,
                        ),
                      ),
                      if (activeCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greenNude.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$activeCount active',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.greenNude,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (activeCount > 0)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _category = null;
                              _brand = null;
                            });
                            widget.onReset();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.danger,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.slate600,
                        ),
                        tooltip: 'Close',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Container(height: 1, color: AppColors.slate200),
                // Filter Sections
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate800,
                              ),
                            ),
                            if (_category != null)
                              GestureDetector(
                                onTap: () {
                                  setState(() => _category = null);
                                  widget.onCategoryChanged(null);
                                },
                                child: const Text(
                                  'Clear',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.slate500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _TopSheetFilterChip(
                              label: 'All Categories',
                              isSelected: _category == null,
                              onTap: () {
                                setState(() => _category = null);
                                widget.onCategoryChanged(null);
                              },
                            ),
                            ...widget.categories.map(
                              (opt) => _TopSheetFilterChip(
                                label: opt,
                                isSelected: _category == opt,
                                onTap: () {
                                  final newVal = _category == opt ? null : opt;
                                  setState(() => _category = newVal);
                                  widget.onCategoryChanged(newVal);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Brand Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Brand',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.slate800,
                              ),
                            ),
                            if (_brand != null)
                              GestureDetector(
                                onTap: () {
                                  setState(() => _brand = null);
                                  widget.onBrandChanged(null);
                                },
                                child: const Text(
                                  'Clear',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.slate500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _TopSheetFilterChip(
                              label: 'All Brands',
                              isSelected: _brand == null,
                              onTap: () {
                                setState(() => _brand = null);
                                widget.onBrandChanged(null);
                              },
                            ),
                            ...widget.brands.map(
                              (opt) => _TopSheetFilterChip(
                                label: opt,
                                isSelected: _brand == opt,
                                onTap: () {
                                  final newVal = _brand == opt ? null : opt;
                                  setState(() => _brand = newVal);
                                  widget.onBrandChanged(newVal);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(height: 1, color: AppColors.slate200),
                // Bottom Apply button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenNude,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 8),
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.slate300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopSheetFilterChip extends StatelessWidget {
  const _TopSheetFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenNude : AppColors.slate100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.greenNude : AppColors.slate200,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.slate800,
          ),
        ),
      ),
    );
  }
}

/// Compact Mobile Search Bar and Filter Header.
///
/// Combines a 40px search input box with a filter trigger button.
/// Displays active category & brand badges directly beneath when filters are active.
class MobileSearchFilterHeader extends StatefulWidget {
  const MobileSearchFilterHeader({
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedCategory,
    required this.selectedBrand,
    required this.onCategoryChanged,
    required this.onBrandChanged,
    required this.onClearFilters,
    required this.onOpenFilter,
    this.hintText = 'Search products...',
    super.key,
  });

  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String? selectedCategory;
  final String? selectedBrand;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onBrandChanged;
  final VoidCallback onClearFilters;
  final VoidCallback onOpenFilter;
  final String hintText;

  @override
  State<MobileSearchFilterHeader> createState() =>
      _MobileSearchFilterHeaderState();
}

class _MobileSearchFilterHeaderState extends State<MobileSearchFilterHeader> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant MobileSearchFilterHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.searchQuery,
        selection: TextSelection.collapsed(offset: widget.searchQuery.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasCategory = widget.selectedCategory != null;
    final hasBrand = widget.selectedBrand != null;
    final hasFilter = hasCategory || hasBrand;
    final activeCount = (hasCategory ? 1 : 0) + (hasBrand ? 1 : 0);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.slate200, width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Search Input Box
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.slate100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.slate200, width: 1),
                  ),
                  child: TextField(
                    controller: _controller,
                    onChanged: widget.onSearchChanged,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.slate900,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: AppColors.slate400,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: AppColors.slate400,
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      suffixIcon: widget.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.cancel_rounded,
                                size: 16,
                                color: AppColors.slate400,
                              ),
                              onPressed: () {
                                _controller.clear();
                                widget.onSearchChanged('');
                              },
                              splashRadius: 16,
                              padding: EdgeInsets.zero,
                            )
                          : null,
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Filter Trigger Pill
              InkWell(
                onTap: widget.onOpenFilter,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: hasFilter
                        ? AppColors.greenNude.withValues(alpha: 0.15)
                        : AppColors.slate100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          hasFilter ? AppColors.greenNude : AppColors.slate200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        size: 18,
                        color: hasFilter
                            ? AppColors.greenNude
                            : AppColors.slate700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: hasFilter
                              ? AppColors.greenNude
                              : AppColors.slate800,
                        ),
                      ),
                      if (activeCount > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greenNude,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$activeCount',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (hasFilter) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 28,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (hasCategory)
                    _ActiveFilterBadge(
                      label: 'Cat: ${widget.selectedCategory}',
                      onDelete: () => widget.onCategoryChanged(null),
                    ),
                  if (hasBrand)
                    _ActiveFilterBadge(
                      label: 'Brand: ${widget.selectedBrand}',
                      onDelete: () => widget.onBrandChanged(null),
                    ),
                  TextButton(
                    onPressed: widget.onClearFilters,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Clear all',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActiveFilterBadge extends StatelessWidget {
  const _ActiveFilterBadge({
    required this.label,
    required this.onDelete,
  });

  final String label;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.fromLTRB(10, 4, 6, 4),
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.slate200, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.slate800,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: AppColors.slate500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
