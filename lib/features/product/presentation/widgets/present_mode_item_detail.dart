import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../order/domain/entities/cart_item.dart';
import '../../../order/presentation/providers/quick_sale_provider.dart';
import '../../domain/entities/variant_detail.dart';

class PresentModeItemDetail extends ConsumerWidget {
  const PresentModeItemDetail({super.key, required this.item});

  final VariantDetail item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizeAndColor = [
      if (item.size != null && item.size!.isNotEmpty) item.size,
      if (item.color != null && item.color!.isNotEmpty) item.color,
    ].join(' / ');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey.shade100,
                child: item.primaryImage != null && item.primaryImage!.isNotEmpty
                    ? Image.network(item.primaryImage!, fit: BoxFit.contain)
                    : const Icon(Icons.image, size: 100, color: Colors.black26),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  if (sizeAndColor.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      sizeAndColor,
                      style: const TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    CurrencyFormatter.format(item.finalPrice),
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: AppButton(
                      label: 'Select this',
                      onPressed: () {
                        // Create CartItem
                        final cartItem = CartItem(
                          variantId: item.variantId,
                          productName: item.productName,
                          variantDisplayName: sizeAndColor,
                          unitPrice: item.finalPrice,
                          quantity: 1,
                          availableStock: item.availableStock,
                        );

                        // Add to Quick Sale Cart
                        ref.read(quickSaleProvider.notifier).addToCart(cartItem);

                        // Pop Present mode full-screen dialog and then push quick sale
                        Navigator.of(context).pop();
                        // Also pop the present mode grid to return to staff view before going to cart?
                        // The prompt says: "navigates to the Quick Sale screen with that item already in the cart, ready for checkout"
                        context.push('/quick-sale');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
