import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/variant_detail.dart';
import '../providers/present_selected_provider.dart';
import 'present_mode_item_detail.dart';

class PresentModeGrid extends StatelessWidget {
  const PresentModeGrid({super.key, required this.items});

  final List<VariantDetail> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.76,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _PresentModeTile(item: item);
      },
    );
  }
}

class _PresentModeTile extends ConsumerWidget {
  const _PresentModeTile({required this.item});

  final VariantDetail item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(presentSelectedItemsProvider);
    final isSelected = selectedItems.containsKey(item.variantId);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
          width: isSelected ? 3 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  blurRadius: 14,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(presentSelectedItemsProvider.notifier).toggle(item);
          },
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Product Image
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade100,
                      child: item.primaryImage != null &&
                              item.primaryImage!.isNotEmpty
                          ? Image.network(item.primaryImage!, fit: BoxFit.cover)
                          : const Icon(
                              Icons.image,
                              size: 56,
                              color: Colors.black26,
                            ),
                    ),
                  ),
                  // Product Details
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    color: isSelected ? const Color(0xFFECFDF5) : Colors.white,
                    child: Column(
                      children: [
                        Text(
                          item.productName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.size != null || item.color != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            [item.size, item.color]
                                .where((e) => e != null && e.isNotEmpty)
                                .join(' / '),
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected
                                  ? const Color(0xFF047857)
                                  : Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          CurrencyFormatter.format(item.finalPrice),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? const Color(0xFF065F46)
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Top-right Selection Check Badge
              Positioned(
                top: 10,
                right: 10,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFF10B981)
                        : Colors.black.withValues(alpha: 0.35),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    isSelected ? Icons.check : Icons.add,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),

              // Top-left Info / Fullscreen Preview Button
              Positioned(
                top: 10,
                left: 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PresentModeItemDetail(item: item),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fullscreen,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
