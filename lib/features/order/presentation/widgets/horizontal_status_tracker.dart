import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/order.dart';

class HorizontalStatusTracker extends StatelessWidget {
  const HorizontalStatusTracker({
    super.key,
    required this.status,
  });

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: const Text(
          'Order Cancelled',
          style: TextStyle(
            color: AppColors.danger,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      );
    }

    final steps = [
      _StatusStep(
        status: OrderStatus.confirmed,
        icon: Icons.receipt_long_outlined,
        isActive: _isAtLeast(OrderStatus.confirmed),
      ),
      _StatusStep(
        status: OrderStatus.packed,
        icon: Icons.inventory_2_outlined,
        isActive: _isAtLeast(OrderStatus.packed),
      ),
      _StatusStep(
        status: OrderStatus.shipped,
        icon: Icons.local_shipping_outlined,
        isActive: _isAtLeast(OrderStatus.shipped),
      ),
      _StatusStep(
        status: OrderStatus.delivered,
        icon: Icons.check_circle_outline,
        isActive: _isAtLeast(OrderStatus.delivered),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background line
          Positioned(
            left: 32,
            right: 32,
            top: 20,
            child: Container(
              height: 2,
              color: AppColors.slate200,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps.map((s) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: s.isActive ? AppColors.slate900 : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: s.isActive ? AppColors.slate900 : AppColors.slate200,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      s.icon,
                      size: 20,
                      color: s.isActive ? Colors.white : AppColors.slate400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.status.displayLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: s.isActive ? FontWeight.w700 : FontWeight.w500,
                      color: s.isActive ? AppColors.slate900 : AppColors.slate400,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  bool _isAtLeast(OrderStatus stepStatus) {
    if (status == OrderStatus.delivered) return true;
    if (status == OrderStatus.shipped) {
      return stepStatus != OrderStatus.delivered;
    }
    if (status == OrderStatus.packed) {
      return stepStatus == OrderStatus.pending ||
          stepStatus == OrderStatus.confirmed ||
          stepStatus == OrderStatus.packed;
    }
    if (status == OrderStatus.confirmed) {
      return stepStatus == OrderStatus.pending ||
          stepStatus == OrderStatus.confirmed;
    }
    if (status == OrderStatus.pending) {
      return stepStatus == OrderStatus.pending;
    }
    return false;
  }
}

class _StatusStep {
  const _StatusStep({
    required this.status,
    required this.icon,
    required this.isActive,
  });

  final OrderStatus status;
  final IconData icon;
  final bool isActive;
}
