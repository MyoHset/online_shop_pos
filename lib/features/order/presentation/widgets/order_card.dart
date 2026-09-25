import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/order.dart';
import 'order_status_badge.dart';

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
    final itemCount = order.items.fold(0, (sum, item) => sum + item.quantity);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.slate50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? AppColors.slate300 : AppColors.slate200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Customer Info & Status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: order.customerName.isEmpty
                          ? AppColors.slate100
                          : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: order.customerName.isEmpty
                            ? AppColors.slate200
                            : AppColors.slate300,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: order.customerName.isEmpty
                        ? const Icon(
                            Icons.storefront_outlined,
                            size: 18,
                            color: AppColors.slate500,
                          )
                        : Text(
                            _getInitials(order.customerName),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.slate800,
                            ),
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName.isEmpty
                              ? 'Walk-in Customer'
                              : order.customerName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        if (order.customerPhone != null &&
                            order.customerPhone!.isNotEmpty)
                          Row(
                            children: [
                              const Icon(
                                Icons.phone_outlined,
                                size: 11,
                                color: AppColors.slate400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                order.customerPhone!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.slate500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            order.orderType.displayLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.slate400,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OrderStatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 10),

              // Middle Row: Order ID, Type Chip, Date
              Row(
                children: [
                  _OrderTypeChip(orderType: order.orderType),
                  const SizedBox(width: 8),
                  Text(
                    '#${order.id.length >= 8 ? order.id.substring(0, 8) : order.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.slate500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.slate400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: AppColors.slate100),
              const SizedBox(height: 8),

              // Bottom Row: Total and Item Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    CurrencyFormatter.format(order.totalAmount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$itemCount items',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: AppColors.slate400,
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
    final bgColor = isOnline ? AppColors.infoBg : AppColors.successBg;
    final fgColor = isOnline ? AppColors.info : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(orderType.iconLabel, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
          Text(
            orderType.displayLabel,
            style: TextStyle(
              color: fgColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
