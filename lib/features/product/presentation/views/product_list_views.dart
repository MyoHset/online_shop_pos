import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/category_search_bar.dart';
import '../../domain/entities/product.dart';
import '../providers/product_brands_provider.dart';
import '../providers/product_categories_provider.dart';
import '../providers/product_filter_provider.dart';
import '../providers/product_list_provider.dart';
import '../widgets/product_card.dart';

// ── Mobile ─────────────────────────────────────────────────────────────────────

class ProductListMobileView extends ConsumerWidget {
  const ProductListMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    final categoriesAsync = ref.watch(productCategoriesProvider);
    final brandsAsync = ref.watch(productBrandsProvider);
    final filter = ref.watch(productFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add product',
            onPressed: () => context.pushNamed('productNew'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(170),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: CategorySearchBar(
              categories: categoriesAsync.value ?? [],
              brands: brandsAsync.value ?? [],
              selectedCategory: filter.category,
              selectedBrand: filter.brand,
              searchQuery: filter.search,
              onCategoryChanged: (c) => ref.read(productFilterProvider.notifier).setCategory(c),
              onBrandChanged: (b) => ref.read(productFilterProvider.notifier).setBrand(b),
              onSearchChanged: (s) => ref.read(productFilterProvider.notifier).setSearch(s),
            ),
          ),
        ),
      ),
      body: productsAsync.when(
        loading: () => const SkeletonListLoader(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.refresh(productListProvider.future),
        ),
        data: (products) => products.isEmpty
            ? const _EmptyView()
            : _ProductScrollView(products: products),
      ),
    );
  }
}

// ── Tablet ─────────────────────────────────────────────────────────────────────

class ProductListTabletView extends ConsumerWidget {
  const ProductListTabletView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    final categoriesAsync = ref.watch(productCategoriesProvider);
    final brandsAsync = ref.watch(productBrandsProvider);
    final filter = ref.watch(productFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        toolbarHeight: 90,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 320,
              child: CategorySearchBar(
                searchWidth: 320,
                categories: categoriesAsync.value ?? [],
                brands: brandsAsync.value ?? [],
                selectedCategory: filter.category,
                selectedBrand: filter.brand,
                searchQuery: filter.search,
                onCategoryChanged: (c) => ref.read(productFilterProvider.notifier).setCategory(c),
                onBrandChanged: (b) => ref.read(productFilterProvider.notifier).setBrand(b),
                onSearchChanged: (s) => ref.read(productFilterProvider.notifier).setSearch(s),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add product',
                onPressed: () => context.pushNamed('productNew'),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: productsAsync.when(
        loading: () => const SkeletonListLoader(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.refresh(productListProvider.future),
        ),
        data: (products) => products.isEmpty
            ? const _EmptyView()
            : _ProductScrollView(products: products),
      ),
    );
  }
}

// ── Desktop ─────────────────────────────────────────────────────────────────────

/// Desktop view uses its own inner [Scaffold].
///
/// [StatefulNavigationShell] renders children via [IndexedStack], which loosens
/// constraints (0..max) regardless of what the parent passes. [Scaffold]
/// handles layout with its own internal layout delegate, bypassing the loose-
/// constraint problem entirely — the correct Flutter-idiomatic solution.
class ProductListDesktopView extends ConsumerWidget {
  const ProductListDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: const _DesktopToolbarBar(),
      body: productsAsync.when(
        loading: () => const SkeletonListLoader(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.refresh(productListProvider.future),
        ),
        data: (products) => products.isEmpty
            ? const _EmptyView()
            : _ProductScrollView(products: products),
      ),
    );
  }
}

// ── Desktop AppBar toolbar ─────────────────────────────────────────────────────

class _DesktopToolbarBar extends ConsumerWidget implements PreferredSizeWidget {
  const _DesktopToolbarBar();

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(productCategoriesProvider);
    final brandsAsync = ref.watch(productBrandsProvider);
    final filter = ref.watch(productFilterProvider);

    return AppBar(
      title: const Text('Products'),
      toolbarHeight: 90,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 320,
            child: CategorySearchBar(
              searchWidth: 320,
              categories: categoriesAsync.value ?? [],
              brands: brandsAsync.value ?? [],
              selectedCategory: filter.category,
              selectedBrand: filter.brand,
              searchQuery: filter.search,
              onCategoryChanged: (c) => ref.read(productFilterProvider.notifier).setCategory(c),
              onBrandChanged: (b) => ref.read(productFilterProvider.notifier).setBrand(b),
              onSearchChanged: (s) => ref.read(productFilterProvider.notifier).setSearch(s),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add product',
              onPressed: () => context.pushNamed('productNew'),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}



// ── Product scroll view ────────────────────────────────────────────────────────

class _ProductScrollView extends StatelessWidget {
  const _ProductScrollView({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 135,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final p = products[i];
                return ProductCard(
                  product: p,
                  onTap: () => context.pushNamed(
                    'productDetail',
                    pathParameters: {'id': p.id},
                  ),
                );
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.slate300),
          SizedBox(height: 12),
          Text(
            'No products yet',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.slate500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Add your first product to get started.',
            style: TextStyle(fontSize: 12, color: AppColors.slate400),
          ),
        ],
      ),
    );
  }
}
