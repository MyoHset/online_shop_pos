class OrderPaymentSummary {
  const OrderPaymentSummary({
    required this.orderId,
    required this.totalAmount,
    required this.amountPaid,
    required this.balanceDue,
  });

  final String orderId;
  final double totalAmount;
  final double amountPaid;
  final double balanceDue;
}
