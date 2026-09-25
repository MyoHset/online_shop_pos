import 'package:flutter_test/flutter_test.dart';
import 'package:online_shop_pos/features/payment/domain/entities/payment.dart';

void main() {
  group('PaymentMethod', () {
    test('values match backend database enum', () {
      expect(PaymentMethod.cod.value, 'cod');
      expect(PaymentMethod.kbzPay.value, 'kbz_pay');
      expect(PaymentMethod.wavePay.value, 'wave_pay');
      expect(PaymentMethod.bankTransfer.value, 'bank_transfer');
      expect(PaymentMethod.credit.value, 'credit');
    });

    test('displayLabel matches Quick Sale chips', () {
      expect(PaymentMethod.cod.displayLabel, 'Cash / COD');
      expect(PaymentMethod.kbzPay.displayLabel, 'KBZPay');
      expect(PaymentMethod.wavePay.displayLabel, 'WavePay');
      expect(PaymentMethod.bankTransfer.displayLabel, 'Bank Transfer');
      expect(PaymentMethod.credit.displayLabel, 'Credit');
    });

    test('fromString parses snake_case, camelCase, and uppercase correctly', () {
      expect(PaymentMethod.fromString('cod'), PaymentMethod.cod);
      expect(PaymentMethod.fromString('COD'), PaymentMethod.cod);
      expect(PaymentMethod.fromString('kbz_pay'), PaymentMethod.kbzPay);
      expect(PaymentMethod.fromString('kbzPay'), PaymentMethod.kbzPay);
      expect(PaymentMethod.fromString('KBZ_PAY'), PaymentMethod.kbzPay);
      expect(PaymentMethod.fromString('wave_pay'), PaymentMethod.wavePay);
      expect(PaymentMethod.fromString('wavePay'), PaymentMethod.wavePay);
      expect(PaymentMethod.fromString('bank_transfer'), PaymentMethod.bankTransfer);
      expect(PaymentMethod.fromString('bankTransfer'), PaymentMethod.bankTransfer);
      expect(PaymentMethod.fromString('credit'), PaymentMethod.credit);
      expect(PaymentMethod.fromString('CREDIT'), PaymentMethod.credit);
      expect(PaymentMethod.fromString('unknown'), PaymentMethod.cod);
    });
  });
}
