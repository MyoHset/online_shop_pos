import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../domain/entities/product.dart';
import '../providers/product_list_provider.dart';
import '../widgets/product_card.dart';

// ── Mobile ─────────────────────────────────────────────────────────────────────

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
          preferredSize: const Size.fromHeight(52),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _SearchBar(
              width: 260,
              onSearch: (q) => ref.read(productListProvider.notifier).search(q),
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
      appBar: _DesktopToolbarBar(
        onSearch: (q) => ref.read(productListProvider.notifier).search(q),
        onAdd: () => context.pushNamed('productNew'),
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

// ── Desktop AppBar toolbar ─────────────────────────────────────────────────────

class _DesktopToolbarBar extends StatefulWidget implements PreferredSizeWidget {
  const _DesktopToolbarBar({required this.onSearch, required this.onAdd});

  final void Function(String) onSearch;
  final VoidCallback onAdd;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  State<_DesktopToolbarBar> createState() => _DesktopToolbarBarState();
}

class _DesktopToolbarBarState extends State<_DesktopToolbarBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Products'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _SearchBar(
            width: 260,
            onSearch: widget.onSearch,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Add product',
          onPressed: widget.onAdd,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

// ── Search bar (mobile / tablet AppBar bottom) ─────────────────────────────────

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.onSearch, this.width});

  final void Function(String) onSearch;
  final double? width;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget field = TextField(
      controller: _ctrl,
      onChanged: (v) {
        setState(() {});
        widget.onSearch(v);
      },
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: 'Search products…',
        prefixIcon:
            const Icon(Icons.search, size: 18, color: AppColors.slate400),
        suffixIcon: _ctrl.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 16),
                onPressed: () {
                  _ctrl.clear();
                  setState(() {});
                  widget.onSearch('');
                },
              )
            : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        isDense: true,
      ),
    );

    if (widget.width != null) {
      return SizedBox(width: widget.width, child: field);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: field,
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
