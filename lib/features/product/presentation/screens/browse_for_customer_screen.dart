import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/browse_for_customer_provider.dart';
import '../providers/product_list_provider.dart'; // To fetch categories/brands
import '../utils/share_caption_builder.dart';
import '../widgets/browse_result_grid.dart';

import '../../data/datasources/product_remote_datasource.dart';
import '../../../../core/network/supabase_client_provider.dart';

final sizesProvider = FutureProvider<List<String>>((ref) async {
  final dataSource = ProductRemoteDataSource(ref.watch(supabaseClientProvider));
  return dataSource.getSizes();
});

class BrowseForCustomerScreen extends ConsumerWidget {
  const BrowseForCustomerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(browseFilterProvider);
    final filterNotifier = ref.read(browseFilterProvider.notifier);
    final resultsAsync = ref.watch(browseResultsProvider);
    
    // We can reuse getCategoriesProvider and getBrandsProvider if they were extracted, 
    // but typically we can just fetch them via their respective usecases or providers.
    // For simplicity, using simple FutureProviders if needed, or if they exist in productFilterProvider, but that is private.
    // Let's create local FutureProviders for dropdowns.

    return Scaffold(
      backgroundColor: AppColors.slate100,
      appBar: CustomAppBar(
        titleText: 'Browse for Customer',
        actions: [
          IconButton(
            icon:  Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 2 / 3,
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'More Filters',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final filterState = ref.watch(browseFilterProvider);
                    final filterNotifier = ref.read(browseFilterProvider.notifier);
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: [
                          _buildCategoryFilter(context, ref, filterState, filterNotifier),
                          const SizedBox(height: 16),
                          _buildBrandFilter(context, ref, filterState, filterNotifier),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Bar
          Builder(
            builder: (innerContext) => Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 4.0),
                    child: Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.tune, color: AppColors.slate700),
                          onPressed: () => Scaffold.of(innerContext).openEndDrawer(),
                        ),
                      if (filterState.category != null || filterState.brand != null)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.danger,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildSizeFilter(context, ref, filterState, filterNotifier),
                ),
                if (filterState.category != null || filterState.brand != null || filterState.size != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.clear, size: 20, color: AppColors.danger),
                      onPressed: filterNotifier.clearFilters,
                      tooltip: 'Clear Filters',
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        // Results
          Expanded(
            child: resultsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('No items found for the selected filters.'));
                }
                return BrowseResultGrid(items: items);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          // Action Bar
          if (resultsAsync.hasValue && (resultsAsync.value?.isNotEmpty ?? false))
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Share (${resultsAsync.value!.length > 10 ? 10 : resultsAsync.value!.length})',
                      variant: AppButtonVariant.secondary,
                      onPressed: () async {
                        final shopName = ref.read(authControllerProvider).value?.shopName ?? 'Our Shop';
                        await shareTopResults(resultsAsync.value!, shopName);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      label: 'Present',
                      onPressed: () {
                        context.push('/browse-for-customer/present');
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context, WidgetRef ref, BrowseFilterState filterState, BrowseFilter notifier) {
    // Ideally use a provider that caches categories. Let's assume we fetch it via a local FutureProvider.
    return _FilterChips<String>(
      label: 'CATEGORY',
      value: filterState.category,
      provider: _categoriesProvider,
      onChanged: notifier.updateCategory,
      isWrap: true,
    );
  }

  Widget _buildBrandFilter(BuildContext context, WidgetRef ref, BrowseFilterState filterState, BrowseFilter notifier) {
    return _FilterChips<String>(
      label: 'BRAND',
      value: filterState.brand,
      provider: _brandsProvider,
      onChanged: notifier.updateBrand,
      isWrap: true,
    );
  }

  Widget _buildSizeFilter(BuildContext context, WidgetRef ref, BrowseFilterState filterState, BrowseFilter notifier) {
    return _FilterChips<String>(
      label: 'SIZE',
      value: filterState.size,
      provider: sizesProvider,
      onChanged: notifier.updateSize,
      hideLabel: true,
    );
  }


}

// Local providers for dropdowns
final _categoriesProvider = FutureProvider<List<String>>((ref) async {
  final dataSource = ProductRemoteDataSource(ref.watch(supabaseClientProvider));
  return dataSource.getCategories();
});

final _brandsProvider = FutureProvider<List<String>>((ref) async {
  final dataSource = ProductRemoteDataSource(ref.watch(supabaseClientProvider));
  return dataSource.getBrands();
});

class _FilterChips<T> extends ConsumerWidget {
  const _FilterChips({
    required this.label,
    required this.value,
    required this.provider,
    required this.onChanged,
    this.hideLabel = false,
    this.isWrap = false,
  });

  final String label;
  final T? value;
  final FutureProvider<List<T>> provider;
  final ValueChanged<T?> onChanged;
  final bool hideLabel;
  final bool isWrap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(provider);

    return itemsAsync.maybeWhen(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(bottom: hideLabel ? 0 : 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!hideLabel)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              if (isWrap)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: items.map((item) {
                      final isSelected = value == item;
                      return InkWell(
                        onTap: () => onChanged(isSelected ? null : item),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.greenNude : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.greenNude : AppColors.slate300,
                            ),
                          ),
                          child: Text(
                            item.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? Colors.white : AppColors.slate700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              else
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = value == item;
                      return InkWell(
                        onTap: () => onChanged(isSelected ? null : item),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.greenNude : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.greenNude : AppColors.slate300,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            item.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? Colors.white : AppColors.slate700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
