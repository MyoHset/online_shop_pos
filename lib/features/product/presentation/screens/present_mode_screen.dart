import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../order/domain/entities/cart_item.dart';
import '../../../order/presentation/providers/quick_sale_provider.dart';
import '../providers/browse_for_customer_provider.dart';
import '../providers/present_selected_provider.dart';
import '../widgets/present_mode_grid.dart';

class PresentModeScreen extends ConsumerWidget {
  const PresentModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(browseResultsProvider);
    final selectedItems = ref.watch(presentSelectedItemsProvider);
    final selectedCount = selectedItems.length;

    final totalPrice = selectedItems.values.fold<double>(
      0.0,
      (sum, item) => sum + item.finalPrice,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark immersive background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Presentation',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              selectedCount == 0
                  ? 'Tap items to select'
                  : '$selectedCount item${selectedCount > 1 ? 's' : ''} selected',
              style: TextStyle(
                color: selectedCount > 0
                    ? const Color(0xFF34D399)
                    : Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          if (selectedCount > 0)
            TextButton(
              onPressed: () {
                ref.read(presentSelectedItemsProvider.notifier).clear();
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Exit Present Mode',
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      extendBodyBehindAppBar: false,
      body: SafeArea(
        bottom: false,
        child: resultsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return const Center(
                child: Text(
                  'No items available.',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }
            return PresentModeGrid(items: items);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (e, _) => Center(
            child:
                Text('Error: $e', style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
      bottomNavigationBar: selectedCount == 0
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$selectedCount item${selectedCount > 1 ? 's' : ''} selected',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.slate600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            CurrencyFormatter.format(totalPrice),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.slate900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.slate900,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.shopping_cart_checkout),
                        label: Text(
                          'Checkout ($selectedCount)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          final quickSale =
                              ref.read(quickSaleProvider.notifier);
                          for (final item in selectedItems.values) {
                            final sizeAndColor = [
                              if (item.size != null && item.size!.isNotEmpty)
                                item.size,
                              if (item.color != null && item.color!.isNotEmpty)
                                item.color,
                            ].join(' / ');

                            quickSale.addToCart(
                              CartItem(
                                variantId: item.variantId,
                                productName: item.productName,
                                variantDisplayName: sizeAndColor,
                                unitPrice: item.finalPrice,
                                quantity: 1,
                                availableStock: item.availableStock,
                              ),
                            );
                          }

                          // Clear selection in present mode
                          ref
                              .read(presentSelectedItemsProvider.notifier)
                              .clear();

                          // Navigate to Quick Sale
                          context.go(AppRoutes.quickSale);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
