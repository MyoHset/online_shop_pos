import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../domain/entities/product.dart';
import '../providers/product_list_provider.dart';
import '../widgets/product_card.dart';

/// Mobile product list view — single-column, search bar at top.
class ProductListMobileView extends ConsumerWidget {
  const ProductListMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

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
          preferredSize: const Size.fromHeight(64),
          child: _SearchBar(
            onSearch: (q) => ref.read(productListProvider.notifier).search(q),
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
            ? const _EmptyProductsView()
            : _ProductListView(products: products),
      ),
    );
  }
}

/// Tablet product list view — 2-column grid.
class ProductListTabletView extends ConsumerWidget {
  const ProductListTabletView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _SearchBar(
              width: 280,
              onSearch: (q) =>
                  ref.read(productListProvider.notifier).search(q),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add product',
            onPressed: () => context.pushNamed('productNew'),
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
            ? const _EmptyProductsView()
            : _ProductGridView(products: products, crossAxisCount: 2),
      ),
    );
  }
}

/// Desktop product list view — left panel grid + right detail panel.
class ProductListDesktopView extends ConsumerWidget {
  const ProductListDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      body: Column(
        children: [
          _DesktopToolbar(
            onSearch: (q) => ref.read(productListProvider.notifier).search(q),
            onAdd: () => context.pushNamed('productNew'),
          ),
          const Divider(height: 1),
          Expanded(
            child: productsAsync.when(
              loading: () => const SkeletonListLoader(),
              error: (e, _) => AppErrorWidget(
                message: e.toString(),
                onRetry: () => ref.refresh(productListProvider.future),
              ),
              data: (products) => products.isEmpty
                  ? const _EmptyProductsView()
                  : _ProductGridView(
                      products: products,
                      crossAxisCount: 3,
                      padding: const EdgeInsets.all(24),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared sub-widgets ─────────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.onSearch, this.width});

  final void Function(String) onSearch;
  final double? width;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget field = TextField(
      controller: _controller,
      onChanged: widget.onSearch,
      decoration: InputDecoration(
        hintText: 'Search products…',
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  _controller.clear();
                  widget.onSearch('');
                },
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        isDense: true,
      ),
    );

    if (widget.width != null) {
      field = SizedBox(width: widget.width, child: field);
    } else {
      field = Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: field,
      );
    }

    return field;
  }
}

class _DesktopToolbar extends StatelessWidget {
  const _DesktopToolbar({required this.onSearch, required this.onAdd});

  final void Function(String) onSearch;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Text(
            'Products',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 320,
            child: TextField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                hintText: 'Search products…',
                prefixIcon: Icon(Icons.search, size: 20),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                isDense: true,
              ),
            ),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Product'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.slate900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => context.pushNamed(
            'productDetail',
            pathParameters: {'id': product.id},
          ),
        );
      },
    );
  }
}

class _ProductGridView extends StatelessWidget {
  const _ProductGridView({
    required this.products,
    required this.crossAxisCount,
    this.padding,
  });

  final List<Product> products;
  final int crossAxisCount;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.4,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => context.pushNamed(
            'productDetail',
            pathParameters: {'id': product.id},
          ),
        );
      },
    );
  }
}

class _EmptyProductsView extends StatelessWidget {
  const _EmptyProductsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined,
              size: 64, color: AppColors.slate300),
          const SizedBox(height: 16),
          Text(
            'No products yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.slate500,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first product to get started.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.slate400,
                ),
          ),
        ],
      ),
    );
  }
}
