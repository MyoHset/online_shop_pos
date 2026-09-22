import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/variant_detail.dart';

class BrowseResultGrid extends StatelessWidget {
  const BrowseResultGrid({super.key, required this.items});

  final List<VariantDetail> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _BrowseResultTile(item: item);
      },
    );
  }
}

class _BrowseResultTile extends StatelessWidget {
  const _BrowseResultTile({required this.item});

  final VariantDetail item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: AppColors.slate100,
              child: item.primaryImage != null && item.primaryImage!.isNotEmpty
                  ? Image.network(item.primaryImage!, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 40, color: AppColors.slate400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyFormatter.format(item.finalPrice),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.slate900),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.greenNude,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${item.availableStock} left',
                        style: const TextStyle(fontSize: 10, color: AppColors.slate700, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                if (item.size != null || item.color != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${item.size ?? ''} ${item.color != null ? '/ ${item.color}' : ''}'.trim(),
                    style: const TextStyle(fontSize: 12, color: AppColors.slate500),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
