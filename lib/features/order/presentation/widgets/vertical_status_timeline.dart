import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/order.dart';

class VerticalStatusTimeline extends StatelessWidget {
  const VerticalStatusTimeline({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    // Generate mock history based on current status for UI demonstration
    final history = _generateHistory(order);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Status Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.slate900,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(history.length, (index) {
          final item = history[index];
          final isLast = index == history.length - 1;
          final isFirst = index == 0;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 32,
                  child: Column(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: item.isActive
                                ? AppColors.slate900
                                : AppColors.slate300,
                            width: 2,
                          ),
                        ),
                        child: item.isActive && isFirst
                            ? Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: AppColors.slate900,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: item.isActive
                                ? AppColors.slate900
                                : AppColors.slate200,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: item.isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 14,
                                color: item.isActive
                                    ? AppColors.slate900
                                    : AppColors.slate500,
                              ),
                            ),
                            if (item.time != null)
                              Text(
                                item.time!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: item.isActive
                                      ? AppColors.slate500
                                      : AppColors.slate400,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: item.isActive
                                ? AppColors.slate600
                                : AppColors.slate400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  List<_TimelineItem> _generateHistory(Order order) {
    final status = order.status;
    final List<_TimelineItem> items = [];

    final bool isDelivered = status == OrderStatus.delivered;
    final bool isShipped = isDelivered || status == OrderStatus.shipped;
    final bool isPacked = isShipped || status == OrderStatus.packed;
    final bool isConfirmed =
        isPacked || status == OrderStatus.confirmed || status == OrderStatus.pending;

    if (isDelivered) {
      items.add(_TimelineItem(
        title: 'Order Delivered',
        description: 'Package has been delivered to the customer.',
        time: _formatTime(order.updatedAt),
        isActive: status == OrderStatus.delivered,
      ));
    }

    if (isShipped) {
      items.add(_TimelineItem(
        title: 'Order Shipped',
        description: 'Package has left the facility.',
        time: isDelivered ? null : _formatTime(order.updatedAt),
        isActive: status == OrderStatus.shipped,
      ));
    }

    if (isPacked) {
      items.add(_TimelineItem(
        title: 'Order in Packing',
        description: 'Your items are being packed.',
        time: isShipped ? null : _formatTime(order.updatedAt),
        isActive: status == OrderStatus.packed,
      ));
    }

    if (isConfirmed) {
      items.add(_TimelineItem(
        title: 'Order Confirmed',
        description: 'Order details verified and payments checked.',
        time: isPacked ? null : _formatTime(order.createdAt),
        isActive: status == OrderStatus.confirmed || status == OrderStatus.pending,
      ));
    }

    if (status == OrderStatus.cancelled) {
      items.insert(
          0,
          _TimelineItem(
            title: 'Order Cancelled',
            description: 'This order has been cancelled.',
            time: _formatTime(order.updatedAt),
            isActive: true,
          ));
    }

    return items;
  }

  String _formatTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _TimelineItem {
  const _TimelineItem({
    required this.title,
    required this.description,
    this.time,
    required this.isActive,
  });

  final String title;
  final String description;
  final String? time;
  final bool isActive;
}
