import 'package:flutter_test/flutter_test.dart';
import 'package:online_shop_pos/features/order/domain/entities/discount.dart';

void main() {
  group('DiscountType enum', () {
    test('fromString parses correctly', () {
      expect(DiscountType.fromString('none'), DiscountType.none);
      expect(DiscountType.fromString('percentage'), DiscountType.percentage);
      expect(DiscountType.fromString('fixed'), DiscountType.fixed);
      expect(DiscountType.fromString('unknown'), DiscountType.none);
      expect(DiscountType.fromString(null), DiscountType.none);
    });

    test('value matches expected database strings', () {
      expect(DiscountType.none.value, 'none');
      expect(DiscountType.percentage.value, 'percentage');
      expect(DiscountType.fixed.value, 'fixed');
    });
  });

  group('Discount calculateAmount', () {
    test('returns 0 when type is none', () {
      const discount = Discount(type: DiscountType.none, value: 500);
      expect(discount.calculateAmount(10000), 0.0);
    });

    test('calculates fixed discount correctly', () {
      const discount = Discount(type: DiscountType.fixed, value: 1000);
      expect(discount.calculateAmount(45000), 1000.0);
    });

    test('clamps fixed discount to subtotal if value exceeds subtotal', () {
      const discount = Discount(type: DiscountType.fixed, value: 50000);
      expect(discount.calculateAmount(45000), 45000.0);
    });

    test('calculates percentage discount with rounding', () {
      const discount = Discount(type: DiscountType.percentage, value: 10);
      expect(discount.calculateAmount(45000), 4500.0);

      const discountFrac = Discount(type: DiscountType.percentage, value: 15.5);
      // 10000 * 15.5 / 100 = 1550.0
      expect(discountFrac.calculateAmount(10000), 1550.0);
    });

    test('clamps percentage discount to subtotal if 100% or above', () {
      const discount = Discount(type: DiscountType.percentage, value: 100);
      expect(discount.calculateAmount(45000), 45000.0);

      const discountOver = Discount(type: DiscountType.percentage, value: 120);
      expect(discountOver.calculateAmount(45000), 45000.0);
    });

    test('handles zero or negative subtotal gracefully', () {
      const discount = Discount(type: DiscountType.fixed, value: 1000);
      expect(discount.calculateAmount(0), 0.0);
      expect(discount.calculateAmount(-500), 0.0);
    });

    test('handles zero value', () {
      const discount = Discount(type: DiscountType.fixed, value: 0);
      expect(discount.calculateAmount(10000), 0.0);
    });

    test('Discount.none() helper is clean', () {
      const discount = Discount.none();
      expect(discount.hasDiscount, isFalse);
      expect(discount.calculateAmount(50000), 0.0);
    });
  });
}
