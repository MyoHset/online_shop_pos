import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../product/presentation/providers/product_list_provider.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/complete_instant_sale.dart';
import 'order_list_provider.dart';

part 'quick_sale_provider.g.dart';

@riverpod
CompleteInstantSale completeInstantSaleUseCase(Ref ref) =>
    CompleteInstantSale(ref.watch(orderRepositoryProvider));

class QuickSaleState {
  const QuickSaleState({
    this.cart = const Cart(),
    this.customerName = '',
    this.paymentMethod = 'cod',
    this.isLoading = false,
    this.errorMessage,
    this.completedOrder,
  });

  final Cart cart;
  final String customerName;
  final String paymentMethod;
  final bool isLoading;
  final String? errorMessage;
  final Order? completedOrder;

  QuickSaleState copyWith({
    Cart? cart,
    String? customerName,
    String? paymentMethod,
    bool? isLoading,
    String? errorMessage,
    Order? completedOrder,
    bool clearError = false,
    bool clearOrder = false,
  }) =>
      QuickSaleState(
        cart: cart ?? this.cart,
        customerName: customerName ?? this.customerName,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        completedOrder: clearOrder ? null : (completedOrder ?? this.completedOrder),
      );
}

@riverpod
class QuickSale extends _$QuickSale {
  @override
  QuickSaleState build() => const QuickSaleState();

  void updateCustomerName(String name) {
    state = state.copyWith(customerName: name);
  }

  void updatePaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
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

    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = ref.read(completeInstantSaleUseCaseProvider);
    final shopId = ref.read(authControllerProvider).value?.shopId;
    
    final result = await useCase(
      customerName: state.customerName,
      paymentMethod: state.paymentMethod,
      shopId: shopId,
      items: state.cart.items
          .map((i) => OrderItemInput(
                variantId: i.variantId,
                quantity: i.quantity,
                unitPrice: i.unitPrice,
              ))
          .toList(),
    );

    result.fold(
      (Failure failure) {
        print('Quick sale error: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (Order order) {
        state = state.copyWith(
          isLoading: false,
          completedOrder: order,
        );
        ref.invalidate(orderListProvider);
        ref.invalidate(productListProvider);
      },
    );
  }
}
