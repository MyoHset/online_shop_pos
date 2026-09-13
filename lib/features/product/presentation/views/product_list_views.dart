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
            : _ProductScrollView(products: products, showColumns: false),
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
            : _ProductScrollView(products: products, showColumns: true),
      ),
    );
  }
}

// ── Desktop ─────────────────────────────────────────────────────────────────────

/// Desktop view renders inside [_DesktopScaffold]'s [Expanded] — no extra
/// [Scaffold] wrapper needed. Returns a Column: toolbar + content area.
class ProductListDesktopView extends ConsumerWidget {
  const ProductListDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Column(
      children: [
        // Toolbar row (fixed height)
        _DesktopToolbarBar(
          onSearch: (q) => ref.read(productListProvider.notifier).search(q),
          onAdd: () => context.pushNamed('productNew'),
        ),
        // Content fills remaining height
        Expanded(
          child: productsAsync.when(
            loading: () => const SkeletonListLoader(),
            error: (e, _) => AppErrorWidget(
              message: e.toString(),
              onRetry: () => ref.refresh(productListProvider.future),
            ),
            data: (products) => products.isEmpty
                ? const _EmptyView()
                : _ProductScrollView(products: products, showColumns: true),
          ),
        ),
      ],
    );
  }
}

// ── Desktop AppBar toolbar ─────────────────────────────────────────────────────

class _DesktopToolbarBar extends StatefulWidget {
  const _DesktopToolbarBar({required this.onSearch, required this.onAdd});

  final void Function(String) onSearch;
  final VoidCallback onAdd;

  @override
  State<_DesktopToolbarBar> createState() => _DesktopToolbarBarState();
}

class _DesktopToolbarBarState extends State<_DesktopToolbarBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 260,
                    child: TextField(
                      onChanged: widget.onSearch,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Search…',
                        prefixIcon: Icon(Icons.search,
                            size: 17, color: AppColors.slate400),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        isDense: true,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: widget.onAdd,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Product',
                          style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.slate200),
        ],
      ),
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

/// Fills the available space from Scaffold.body and scrolls correctly.
class _ProductScrollView extends StatelessWidget {
  const _ProductScrollView({
    required this.products,
    required this.showColumns,
  });

  final List<Product> products;
  final bool showColumns;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Column header (tablet / desktop only)
        if (showColumns)
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: AppColors.slate50,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: const Row(
                    children: [
                      SizedBox(width: 54),
                      Expanded(flex: 5, child: _ColHeader('Product')),
                      Expanded(flex: 3, child: _ColHeader('Price')),
                      Expanded(flex: 3, child: _ColHeader('Stock')),
                      SizedBox(width: 80),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.slate100),
              ],
            ),
          ),

        // Product rows
        SliverList.separated(
          itemCount: products.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: AppColors.slate100),
          itemBuilder: (context, i) {
            final p = products[i];
            return ProductCard(
              product: p,
              onTap: () => context.pushNamed(
                'productDetail',
                pathParameters: {'id': p.id},
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ColHeader extends StatelessWidget {
  const _ColHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: AppColors.slate400,
      ),
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
