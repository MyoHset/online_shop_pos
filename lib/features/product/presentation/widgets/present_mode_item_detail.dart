import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/variant_detail.dart';
import '../providers/present_selected_provider.dart';

class PresentModeItemDetail extends ConsumerWidget {
  const PresentModeItemDetail({super.key, required this.item});

  final VariantDetail item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizeAndColor = [
      if (item.size != null && item.size!.isNotEmpty) item.size,
      if (item.color != null && item.color!.isNotEmpty) item.color,
    ].join(' / ');

    final selectedItems = ref.watch(presentSelectedItemsProvider);
    final isSelected = selectedItems.containsKey(item.variantId);

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
          ),
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
                child: item.primaryImage != null &&
                        item.primaryImage!.isNotEmpty
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
                    color: Colors.black.withValues(alpha: 0.05),
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
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  if (sizeAndColor.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      sizeAndColor,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    CurrencyFormatter.format(item.finalPrice),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: AppButton(
                      label: isSelected
                          ? 'Remove from Selection'
                          : 'Add to Selection',
                      variant: isSelected
                          ? AppButtonVariant.secondary
                          : AppButtonVariant.primary,
                      onPressed: () {
                        ref
                            .read(presentSelectedItemsProvider.notifier)
                            .toggle(item);
                        Navigator.of(context).pop();
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
