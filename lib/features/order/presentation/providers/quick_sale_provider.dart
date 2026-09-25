import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/presentation/providers/customer_provider.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/presentation/providers/product_list_provider.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/discount.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/complete_instant_sale.dart';
import 'order_list_provider.dart';
import 'quick_sale_filter_provider.dart';

part 'quick_sale_provider.g.dart';

@riverpod
CompleteInstantSale completeInstantSaleUseCase(Ref ref) =>
    CompleteInstantSale(ref.watch(orderRepositoryProvider));

@riverpod
Future<List<Product>> quickSaleProductList(Ref ref) async {
  final filter = ref.watch(quickSaleFilterProvider);
  final useCase = ref.read(getProductsUseCaseProvider);
  final shopId = ref.watch(authControllerProvider).value?.shopId;
  
  final result = await useCase(
    searchQuery: filter.search,
    category: filter.category,
    brand: filter.brand,
    shopId: shopId,
  );
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (products) => products,
  );
}

class QuickSaleState {
  const QuickSaleState({
    this.cart = const Cart(),
    this.customerName = '',
    this.selectedCustomer,
    this.paidAmount = 0.0,
    this.paymentMethod = 'cod',
    this.discountType = DiscountType.none,
    this.discountValue = 0.0,
    this.discountReason,
    this.isLoading = false,
    this.errorMessage,
    this.completedOrder,
  });

  final Cart cart;
  final String customerName;
  final Customer? selectedCustomer;
  final double paidAmount;
  final String paymentMethod;
  final DiscountType discountType;
  final double discountValue;
  final String? discountReason;
  final bool isLoading;
  final String? errorMessage;
  final Order? completedOrder;

  bool get isCredit => paymentMethod == 'credit';

  Discount get discount => Discount(
        type: discountType,
        value: discountValue,
        reason: discountReason,
      );

  double get discountAmount => discount.calculateAmount(cart.total);

  double get totalAmount =>
      (cart.total - discountAmount).clamp(0.0, double.infinity);

  double get creditDebtAmount =>
      (totalAmount - paidAmount).clamp(0.0, totalAmount).toDouble();

  QuickSaleState copyWith({
    Cart? cart,
    String? customerName,
    Customer? selectedCustomer,
    bool clearCustomer = false,
    double? paidAmount,
    String? paymentMethod,
    DiscountType? discountType,
    double? discountValue,
    String? discountReason,
    bool clearDiscountReason = false,
    bool? isLoading,
    String? errorMessage,
    Order? completedOrder,
    bool clearError = false,
    bool clearOrder = false,
  }) =>
      QuickSaleState(
        cart: cart ?? this.cart,
        customerName: customerName ?? this.customerName,
        selectedCustomer: clearCustomer ? null : (selectedCustomer ?? this.selectedCustomer),
        paidAmount: paidAmount ?? this.paidAmount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        discountType: discountType ?? this.discountType,
        discountValue: discountValue ?? this.discountValue,
        discountReason: clearDiscountReason
            ? null
            : (discountReason ?? this.discountReason),
        isLoading: isLoading ?? this.isLoading,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        completedOrder:
            clearOrder ? null : (completedOrder ?? this.completedOrder),
      );
}

@riverpod
class QuickSale extends _$QuickSale {
  @override
  QuickSaleState build() => const QuickSaleState();

  void selectCustomer(Customer? customer) {
    if (customer == null) {
      state = state.copyWith(clearCustomer: true, customerName: '');
    } else {
      state = state.copyWith(
        selectedCustomer: customer,
        customerName: customer.name,
      );
    }
  }

  void updatePaidAmount(double amount) {
    state = state.copyWith(paidAmount: amount);
  }

  void updateCustomerName(String name) {
    state = state.copyWith(customerName: name, clearCustomer: true);
  }

  void updatePaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void updateDiscount(Discount discount) {
    state = state.copyWith(
      discountType: discount.type,
      discountValue: discount.value,
      discountReason: discount.reason,
    );
  }

  void removeDiscount() {
    state = state.copyWith(
      discountType: DiscountType.none,
      discountValue: 0.0,
      clearDiscountReason: true,
    );
  }

  void addToCart(CartItem item) {
    final items = List<CartItem>.from(state.cart.items);
    final index = items.indexWhere((i) => i.variantId == item.variantId);
    
    if (index >= 0) {
      final existing = items[index];
      items[index] = existing.copyWith(quantity: existing.quantity + item.quantity);
    } else {
      items.add(item);
    }
    
    state = state.copyWith(cart: Cart(items: items));
  }

  void updateQuantity(String variantId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(variantId);
      return;
    }
    
    final items = state.cart.items.map((i) {
      if (i.variantId == variantId) {
        return i.copyWith(quantity: quantity);
      }
      return i;
    }).toList();
    
    state = state.copyWith(cart: Cart(items: items));
  }

  void removeFromCart(String variantId) {
    final items = state.cart.items.where((i) => i.variantId != variantId).toList();
    state = state.copyWith(cart: Cart(items: items));
  }

  void resetSale() {
    state = const QuickSaleState();
  }

  Future<void> submitSale() async {
    if (state.cart.isEmpty) return;
    
    if (state.cart.hasInsufficientStock) {
      final badItems = state.cart.insufficientStockItems;
      final names = badItems.map((e) => e.variantDisplayName).join(', ');
      state = state.copyWith(
        errorMessage: 'Insufficient stock for: $names',
      );
      return;
    }

    if (state.isCredit) {
      if (state.selectedCustomer == null) {
        state = state.copyWith(
          errorMessage: 'Please select a registered customer for Credit sales.',
        );
        return;
      }
      if (state.selectedCustomer!.isSuspended) {
        state = state.copyWith(
          errorMessage: 'Credit sale blocked: Customer account is suspended.',
        );
        return;
      }
    }

    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = ref.read(completeInstantSaleUseCaseProvider);
    final shopId = ref.read(authControllerProvider).value?.shopId;
    final customer = state.selectedCustomer;
    final dueDate = state.isCredit && customer != null
        ? customer.calculateDueDate(DateTime.now())
        : null;

    final result = await useCase(
      customerName: state.customerName,
      customerId: customer?.id,
      paymentMethod: state.paymentMethod,
      isCredit: state.isCredit,
      paidAmount: state.isCredit ? state.paidAmount : 0.0,
      dueDate: dueDate,
      discountType: state.discountType,
      discountValue: state.discountValue,
      discountReason: state.discountReason,
      shopId: shopId,
      items: state.cart.items
          .map((i) => OrderItemInput(
                variantId: i.variantId,
                quantity: i.quantity,
                unitPrice: i.unitPrice,
              ),)
          .toList(),
    );

    result.fold(
      (Failure failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (Order order) {
        final custId = customer?.id;
        state = state.copyWith(
          isLoading: false,
          completedOrder: order,
        );
        ref.invalidate(orderListProvider);
        ref.invalidate(productListProvider);
        ref.invalidate(customerListProvider);
        if (custId != null) {
          ref.invalidate(customerDetailProvider(custId));
          ref.invalidate(customerTransactionsProvider(custId));
        }
      },
    );
  }
}
