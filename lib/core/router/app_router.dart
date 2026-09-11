import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/order/presentation/screens/order_create_screen.dart';
import '../../features/order/presentation/screens/order_detail_screen.dart';
import '../../features/order/presentation/screens/order_list_screen.dart';
import '../../features/payment/presentation/screens/payment_entry_screen.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/product/presentation/screens/product_form_screen.dart';
import '../../features/product/presentation/screens/product_list_screen.dart';
import '../../features/product/presentation/screens/variant_form_screen.dart';
import '../responsive/adaptive_scaffold.dart';

/// Named route paths used throughout the app.
class AppRoutes {
  AppRoutes._();

  static const String products = '/products';
  static const String productNew = '/products/new';
  static const String productDetail = '/products/:id';
  static const String productEdit = '/products/:id/edit';
  static const String productVariantNew = '/products/:id/variants/new';
  static const String productVariantEdit =
      '/products/:id/variants/:variantId/edit';

  static const String orders = '/orders';
  static const String orderNew = '/orders/new';
  static const String orderDetail = '/orders/:id';
  static const String orderPayment = '/orders/:id/payment';
}

/// Shell widget that wraps the main navigation chrome around routed pages.
class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const List<AppNavDestination> _destinations = [
    AppNavDestination(
      label: 'Products',
      icon: Icon(Icons.inventory_2_outlined),
      selectedIcon: Icon(Icons.inventory_2),
      route: AppRoutes.products,
    ),
    AppNavDestination(
      label: 'Orders',
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      route: AppRoutes.orders,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: _destinations,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: navigationShell.goBranch,
      body: navigationShell,
    );
  }
}

/// Application router configuration.
final appRouter = GoRouter(
  initialLocation: AppRoutes.products,
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _AppShell(navigationShell: navigationShell),
      branches: [
        // ── Products branch ──────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.products,
              name: 'products',
              builder: (context, state) => const ProductListScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  name: 'productNew',
                  builder: (context, state) =>
                      const ProductFormScreen(productId: null),
                ),
                GoRoute(
                  path: ':id',
                  name: 'productDetail',
                  builder: (context, state) => ProductDetailScreen(
                    productId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: 'productEdit',
                      builder: (context, state) => ProductFormScreen(
                        productId: state.pathParameters['id'],
                      ),
                    ),
                    GoRoute(
                      path: 'variants/new',
                      name: 'variantNew',
                      builder: (context, state) => VariantFormScreen(
                        productId: state.pathParameters['id']!,
                        variantId: null,
                      ),
                    ),
                    GoRoute(
                      path: 'variants/:variantId/edit',
                      name: 'variantEdit',
                      builder: (context, state) => VariantFormScreen(
                        productId: state.pathParameters['id']!,
                        variantId: state.pathParameters['variantId'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // ── Orders branch ─────────────────────────────────────────────────
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.orders,
              name: 'orders',
              builder: (context, state) => const OrderListScreen(),
              routes: [
                GoRoute(
                  path: 'new',
                  name: 'orderNew',
                  builder: (context, state) => const OrderCreateScreen(),
                ),
                GoRoute(
                  path: ':id',
                  name: 'orderDetail',
                  builder: (context, state) => OrderDetailScreen(
                    orderId: state.pathParameters['id']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'payment',
                      name: 'orderPayment',
                      builder: (context, state) => PaymentEntryScreen(
                        orderId: state.pathParameters['id']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
