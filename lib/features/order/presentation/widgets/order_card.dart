import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/order.dart';
import 'order_status_badge.dart';

/// Clean, compact, and data-comprehensive card for mobile order list.
class OrderCard extends StatefulWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  final Order order;
  final VoidCallback onTap;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final dateStr = DateFormat('MMM d, yyyy • hh:mm a').format(order.createdAt);
    final totalItemsCount =
        order.items.fold(0, (sum, item) => sum + item.quantity);
    final shortId = order.id.length >= 8
        ? order.id.substring(0, 8).toUpperCase()
        : order.id.toUpperCase();

    final isOnline = order.orderType == OrderType.online;
    final hasAddress =
        isOnline && (order.customerAddress?.trim().isNotEmpty ?? false);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        decoration: BoxDecoration(
          color: _hovered ? AppColors.slate50 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered ? AppColors.slate300 : AppColors.slate200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.slate900.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Top Header: Order ID + Order Type + Status Badge ──
                  Row(
                    children: [
                      // Order ID Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.slate100,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.slate200,
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          '#$shortId',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: AppColors.slate800,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Order Type Badge
                      _OrderTypeChip(orderType: order.orderType),

                      const Spacer(),

                      // Status Badge
                      OrderStatusBadge(
                        status: order.status,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ── Customer Information ──
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: AppColors.slate500,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.slate800,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: order.customerName.isEmpty
                                    ? 'Walk-in Customer'
                                    : order.customerName,
                              ),
                              if (order.customerPhone != null &&
                                  order.customerPhone!.trim().isNotEmpty) ...[
                                TextSpan(
                                  text: ' • ${order.customerPhone!.trim()}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.slate500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Delivery Address (for online orders)
                  if (hasAddress) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: AppColors.slate400,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            order.customerAddress!.trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.slate600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 4),
                  // Date and Time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.slate400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.slate500,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  // ── Items Preview (Comprehensive Data) ──
                  if (order.items.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.slate50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.slate200.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.shopping_bag_outlined,
                                size: 13,
                                color: AppColors.slate500,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '$totalItemsCount ${totalItemsCount == 1 ? 'item' : 'items'}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.slate700,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                'Preview',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.slate400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          // Display up to 2 items
                          ...order.items.take(2).map((item) {
                            final variantInfo =
                                item.variantDisplayName != null &&
                                        item.variantDisplayName!.isNotEmpty
                                    ? ' (${item.variantDisplayName})'
                                    : '';
                            return Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: AppColors.slate400,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${item.quantity}x ${item.productName ?? 'Item'}$variantInfo',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.slate600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.format(item.subtotal),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.slate700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          if (order.items.length > 2)
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text(
                                '+ ${order.items.length - 2} more item(s)...',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.slate500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),
                  const Divider(height: 1, color: AppColors.slate200),
                  const SizedBox(height: 10),

                  // ── Footer: Total Amount, Discount & Details Action ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (order.discountAmount > 0)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                'Discount: -${CurrencyFormatter.format(order.discountAmount)}',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.danger,
                                ),
                              ),
                            ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              const Text(
                                'Total: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.slate500,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(order.totalAmount),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.slate900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Details Link
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greenNude.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Details',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.greenNude,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10,
                              color: AppColors.greenNude,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

/// Small pill chip showing the order type on cards.
class _OrderTypeChip extends StatelessWidget {
  const _OrderTypeChip({required this.orderType});
  final OrderType orderType;

  @override
  Widget build(BuildContext context) {
    final isOnline = orderType == OrderType.online;
    final bgColor = isOnline
        ? AppColors.info.withValues(alpha: 0.12)
        : AppColors.success.withValues(alpha: 0.12);
    final fgColor = isOnline ? AppColors.info : AppColors.success;
    final icon =
        isOnline ? Icons.local_shipping_outlined : Icons.storefront_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fgColor),
          const SizedBox(width: 4),
          Text(
            orderType.displayLabel,
            style: TextStyle(
              color: fgColor,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
