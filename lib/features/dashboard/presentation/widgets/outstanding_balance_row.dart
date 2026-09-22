import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/outstanding_balance.dart';

class OutstandingBalanceRow extends StatelessWidget {
  const OutstandingBalanceRow({
    required this.balance,
    super.key,
  });

  final OutstandingBalance balance;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed('orderDetail', pathParameters: {'id': balance.orderId});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    balance.orderNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    balance.customerName ?? 'Walk-in Customer',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              CurrencyFormatter.format(balance.balanceDue),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
