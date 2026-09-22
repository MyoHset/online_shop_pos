import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/category_search_bar.dart';
import '../../../../core/widgets/search_text_field.dart';
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
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const _SearchAction(),
          IconButton(
            icon: const Icon(Icons.storefront),
            tooltip: 'Browse for Customer',
            onPressed: () => context.push('/browse-for-customer'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add product',
            onPressed: () => context.pushNamed('productNew'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.slate200, height: 1),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: CategorySearchBar(
              showSearchField: false,
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
          Container(height: 1, color: AppColors.slate200),
          Expanded(
            child: productsAsync.when(
              loading: () => const SkeletonListLoader(),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.refresh(productListProvider.future),
              ),
              data: (products) => products.isEmpty
                  ? const _EmptyView()
                  : _ProductScrollView(products: products),
            ),
          ),
        ],
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
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const _SearchAction(),
          IconButton(
            icon: const Icon(Icons.storefront),
            tooltip: 'Browse for Customer',
            onPressed: () => context.push('/browse-for-customer'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add product',
            onPressed: () => context.pushNamed('productNew'),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.slate200, height: 1),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: CategorySearchBar(
              showSearchField: false,
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
          Container(height: 1, color: AppColors.slate200),
          Expanded(
            child: productsAsync.when(
              loading: () => const SkeletonListLoader(),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.refresh(productListProvider.future),
              ),
              data: (products) => products.isEmpty
                  ? const _EmptyView()
                  : _ProductScrollView(products: products),
            ),
          ),
        ],
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
    final categoriesAsync = ref.watch(productCategoriesProvider);
    final brandsAsync = ref.watch(productBrandsProvider);
    final filter = ref.watch(productFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.slate50,
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const _SearchAction(),
          IconButton(
            icon: const Icon(Icons.storefront),
            tooltip: 'Browse for Customer',
            onPressed: () => context.push('/browse-for-customer'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add product',
            onPressed: () => context.pushNamed('productNew'),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.slate200, height: 1),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: CategorySearchBar(
              showSearchField: false,
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
          Container(height: 1, color: AppColors.slate200),
          Expanded(
            child: productsAsync.when(
              loading: () => const SkeletonListLoader(),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.refresh(productListProvider.future),
              ),
              data: (products) => products.isEmpty
                  ? const _EmptyView()
                  : _ProductScrollView(products: products),
            ),
          ),
        ],
      ),
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
              maxCrossAxisExtent: 220,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 220,
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

// ── Search Action ──────────────────────────────────────────────────────────────

class _SearchAction extends ConsumerStatefulWidget {
  const _SearchAction();

  @override
  ConsumerState<_SearchAction> createState() => _SearchActionState();
}

class _SearchActionState extends ConsumerState<_SearchAction> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(productFilterProvider);

    if (!_expanded) {
      return IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Search',
        onPressed: () {
          setState(() {
            _expanded = true;
          });
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchTextField(
            value: filter.search,
            onChanged: (s) => ref.read(productFilterProvider.notifier).setSearch(s),
            width: 250,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close Search',
            onPressed: () {
              ref.read(productFilterProvider.notifier).setSearch('');
              setState(() {
                _expanded = false;
              });
            },
          ),
        ],
      ),
    );
  }
}
