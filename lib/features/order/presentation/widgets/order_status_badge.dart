import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/order.dart';

/// Colour-coded status badge for [OrderStatus].
class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status, this.size = StatusBadgeSize.medium});

  final OrderStatus status;
  final StatusBadgeSize size;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      OrderStatus.pending => StatusBadge.warning(
          label: status.displayLabel, size: size,
          icon: const Icon(Icons.hourglass_empty_rounded, size: 14)),
      OrderStatus.confirmed => StatusBadge.info(
          label: status.displayLabel, size: size,
          icon: const Icon(Icons.check_outlined, size: 14)),
      OrderStatus.packed => StatusBadge.info(
          label: status.displayLabel, size: size,
          icon: const Icon(Icons.inventory_2_outlined, size: 14)),
      OrderStatus.shipped => StatusBadge.info(
          label: status.displayLabel, size: size,
          icon: const Icon(Icons.local_shipping_outlined, size: 14)),
      OrderStatus.delivered => StatusBadge.success(
          label: status.displayLabel, size: size),
      OrderStatus.cancelled => StatusBadge.danger(
          label: status.displayLabel, size: size),
    };
  }
}
