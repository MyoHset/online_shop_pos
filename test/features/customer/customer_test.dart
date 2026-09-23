import 'package:flutter_test/flutter_test.dart';
import 'package:online_shop_pos/features/customer/domain/entities/customer.dart';
import 'package:online_shop_pos/features/customer/domain/entities/customer_transaction.dart';
import 'package:online_shop_pos/features/customer/data/models/customer_model.dart';

void main() {
  group('RepaymentCycle', () {
    test('values match database representation', () {
      expect(RepaymentCycle.weekly.value, 'weekly');
      expect(RepaymentCycle.monthly.value, 'monthly');
      expect(RepaymentCycle.net30.value, 'net30');
    });

    test('fromString parses correctly with default fallback', () {
      expect(RepaymentCycle.fromString('weekly'), RepaymentCycle.weekly);
      expect(RepaymentCycle.fromString('monthly'), RepaymentCycle.monthly);
      expect(RepaymentCycle.fromString('net30'), RepaymentCycle.net30);
      expect(RepaymentCycle.fromString(null), RepaymentCycle.monthly);
      expect(RepaymentCycle.fromString('other'), RepaymentCycle.monthly);
    });
  });

  group('Customer entity credit logic', () {
    test('hasDebt is true when currentDebt > 0', () {
      final customerWithDebt = Customer(
        id: '1',
        name: 'Mg Mg',
        phone: '09123456789',
        creditLimit: 500000,
        currentDebt: 100000,
        repaymentCycle: RepaymentCycle.monthly,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final customerWithoutDebt = customerWithDebt.copyWith(currentDebt: 0);

      expect(customerWithDebt.hasDebt, isTrue);
      expect(customerWithoutDebt.hasDebt, isFalse);
    });

    test('remainingCredit and isLimitReached calculation', () {
      final customer = Customer(
        id: '1',
        name: 'Mg Mg',
        phone: '09123456789',
        creditLimit: 500000,
        currentDebt: 400000,
        repaymentCycle: RepaymentCycle.monthly,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(customer.remainingCredit, 100000);
      expect(customer.isLimitReached, isFalse);

      final limitReachedCustomer = customer.copyWith(currentDebt: 500000);
      expect(limitReachedCustomer.remainingCredit, 0);
      expect(limitReachedCustomer.isLimitReached, isTrue);
    });
  });

  group('CustomerModel JSON serialization', () {
    test('fromJson and toEntity maps fields correctly', () {
      final now = DateTime.now();
      final json = {
        'id': 'uuid-123',
        'shop_id': 'shop-456',
        'name': 'Ko Aung',
        'phone': '09987654321',
        'address': 'Yangon',
        'credit_limit': 300000.0,
        'current_debt': 50000.0,
        'repayment_cycle': 'weekly',
        'notes': 'Wholesale',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      };

      final model = CustomerModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.id, 'uuid-123');
      expect(entity.name, 'Ko Aung');
      expect(entity.phone, '09987654321');
      expect(entity.repaymentCycle, RepaymentCycle.weekly);
      expect(entity.creditLimit, 300000.0);
      expect(entity.currentDebt, 50000.0);
      expect(entity.hasDebt, isTrue);
    });
  });

  group('CustomerTransactionType', () {
    test('fromString parses all types', () {
      expect(
        CustomerTransactionType.fromString('debt'),
        CustomerTransactionType.debt,
      );
      expect(
        CustomerTransactionType.fromString('repayment'),
        CustomerTransactionType.repayment,
      );
      expect(
        CustomerTransactionType.fromString('opening_balance'),
        CustomerTransactionType.openingBalance,
      );
    });
  });
}
