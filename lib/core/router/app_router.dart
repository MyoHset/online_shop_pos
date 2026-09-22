import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/domain/entities/staff_role.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_home_screen.dart';
import '../../features/order/presentation/screens/order_create_screen.dart';
import '../../features/order/presentation/screens/order_detail_screen.dart';
import '../../features/order/presentation/screens/order_list_screen.dart';
import '../../features/order/presentation/screens/quick_sale_screen.dart';
import '../../features/payment/presentation/screens/payment_entry_screen.dart';
import '../../features/product/presentation/screens/browse_for_customer_screen.dart';
import '../../features/product/presentation/screens/present_mode_screen.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/product/presentation/screens/product_form_screen.dart';
import '../../features/product/presentation/screens/product_list_screen.dart';
import '../../features/product/presentation/screens/variant_form_screen.dart';
import '../../features/staff/presentation/screens/invite_staff_screen.dart';
import '../../features/staff/presentation/screens/staff_list_screen.dart';
import '../network/supabase_client_provider.dart';
import '../responsive/adaptive_scaffold.dart';

part 'app_router.g.dart';

/// Named route paths used throughout the app.
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String dashboard = '/';

  static const String products = '/products';
  static const String productNew = '/products/new';
  static const String productDetail = '/products/:id';
  static const String productEdit = '/products/:id/edit';
  static const String productVariantNew = '/products/:id/variants/new';
  static const String productVariantEdit =
      '/products/:id/variants/:variantId/edit';

  static const String browseForCustomer = '/browse-for-customer';

  static const String quickSale = '/quick-sale';

  static const String orders = '/orders';
  static const String orderNew = '/orders/new';
  static const String orderDetail = '/orders/:id';
  static const String orderPayment = '/orders/:id/payment';

  static const String staff = '/staff';
  static const String staffInvite = '/staff/invite';
}

/// Shell widget that wraps the main navigation chrome around routed pages.
class _AppShell extends ConsumerWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(currentStaffRoleProvider);
    final role = roleAsync.value ?? StaffRole.staff;

    final destinations = [
      const AppNavDestination(
        label: 'Quick Sale',
        icon: Icon(Icons.point_of_sale_outlined),
        selectedIcon: Icon(Icons.point_of_sale),
        route: AppRoutes.quickSale,
      ),
      const AppNavDestination(
        label: 'Dashboard',
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        route: AppRoutes.dashboard,
      ),
      const AppNavDestination(
        label: 'Products',
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2),
        route: AppRoutes.products,
      ),
      const AppNavDestination(
        label: 'Orders',
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long),
        route: AppRoutes.orders,
      ),
      if (role.canManageStaff)
        const AppNavDestination(
          label: 'Staff',
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people),
          route: AppRoutes.staff,
        ),
    ];

    return AdaptiveScaffold(
      destinations: destinations,
      selectedIndex: navigationShell.currentIndex < destinations.length
          ? navigationShell.currentIndex
          : 0,
      onDestinationSelected: (index) {
        if (index < destinations.length) {
          navigationShell.goBranch(index);
        }
      },
      body: navigationShell,
    );
  }
}

@riverpod
GoRouter appRouter(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = supabase.auth.currentUser != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.forgotPassword;

      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.quickSale;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.browseForCustomer,
        name: 'browseForCustomer',
        builder: (context, state) => const BrowseForCustomerScreen(),
        routes: [
          GoRoute(
            path: 'present',
            name: 'presentMode',
            builder: (context, state) => const PresentModeScreen(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _AppShell(navigationShell: navigationShell),
        branches: [
          // ── Quick Sale branch ─────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.quickSale,
                name: 'quickSale',
                builder: (context, state) => const QuickSaleScreen(),
              ),
            ],
          ),

          // ── Dashboard branch ─────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: 'dashboard',
                builder: (context, state) => const DashboardHomeScreen(),
              ),
            ],
          ),

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

          // ── Staff branch ──────────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.staff,
                name: 'staff',
                builder: (context, state) => const StaffListScreen(),
                routes: [
                  GoRoute(
                    path: 'invite',
                    name: 'staffInvite',
                    builder: (context, state) => const InviteStaffScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
