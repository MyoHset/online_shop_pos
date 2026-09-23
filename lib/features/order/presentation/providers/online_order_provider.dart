import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/discount.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/update_order_discount.dart';
import '../../domain/entities/order.dart';
import 'order_list_provider.dart';
import 'order_item_picker_filter_provider.dart';
import '../../../product/presentation/providers/product_list_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../product/domain/entities/product.dart';

part 'online_order_provider.g.dart';

@riverpod
CreateOrder createOrderUseCase(Ref ref) =>
    CreateOrder(ref.watch(orderRepositoryProvider));

@riverpod
UpdateOrderDiscount updateOrderDiscountUseCase(Ref ref) =>
    UpdateOrderDiscount(ref.watch(orderRepositoryProvider));

@riverpod
Future<List<Product>> onlineOrderProductList(Ref ref) async {
  final filter = ref.watch(orderItemPickerFilterProvider);
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

/// Holds a pending line item the user is building before confirming.
class PendingOrderItem {
  const PendingOrderItem({
    required this.variantId,
    required this.productName,
    required this.variantDisplayName,
    required this.quantity,
    required this.unitPrice,
  });

  final String variantId;
  final String productName;
  final String variantDisplayName;
  final int quantity;
  final double unitPrice;

  double get subtotal => unitPrice * quantity;

  PendingOrderItem copyWith({int? quantity, double? unitPrice}) =>
      PendingOrderItem(
        variantId: variantId,
        productName: productName,
        variantDisplayName: variantDisplayName,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
      );
}

/// State for the online order creation flow.
class OnlineOrderState {
  const OnlineOrderState({
    this.customerName = '',
    this.customerPhone,
    this.customerAddress,
    this.items = const [],
    this.discountType = DiscountType.none,
    this.discountValue = 0.0,
    this.discountReason,
    this.isLoading = false,
    this.errorMessage,
  });

  final String customerName;
  final String? customerPhone;
  final String? customerAddress;
  final List<PendingOrderItem> items;
  final DiscountType discountType;
  final double discountValue;
  final String? discountReason;
  final bool isLoading;
  final String? errorMessage;

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.subtotal);

  Discount get discount => Discount(
        type: discountType,
        value: discountValue,
        reason: discountReason,
      );

  double get discountAmount => discount.calculateAmount(subtotal);

  double get totalAmount =>
      (subtotal - discountAmount).clamp(0.0, double.infinity);

  OnlineOrderState copyWith({
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    List<PendingOrderItem>? items,
    DiscountType? discountType,
    double? discountValue,
    String? discountReason,
    bool clearDiscountReason = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) =>
      OnlineOrderState(
        customerName: customerName ?? this.customerName,
        customerPhone: customerPhone ?? this.customerPhone,
        customerAddress: customerAddress ?? this.customerAddress,
        items: items ?? this.items,
        discountType: discountType ?? this.discountType,
        discountValue: discountValue ?? this.discountValue,
        discountReason: clearDiscountReason
            ? null
            : (discountReason ?? this.discountReason),
        isLoading: isLoading ?? this.isLoading,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );
}

/// Manages the online order creation flow state.
@riverpod
class OnlineOrder extends _$OnlineOrder {
  @override
  OnlineOrderState build() => const OnlineOrderState();

  void updateCustomerName(String v) => state = state.copyWith(customerName: v);
  void updateCustomerPhone(String? v) =>
      state = state.copyWith(customerPhone: v);
  void updateCustomerAddress(String? v) =>
      state = state.copyWith(customerAddress: v);

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

  void addItem(PendingOrderItem item) {
    final existing =
        state.items.where((i) => i.variantId == item.variantId).firstOrNull;
    if (existing != null) {
      final updated = existing.copyWith(quantity: existing.quantity + item.quantity);
      state = state.copyWith(
        items: state.items
            .map((i) => i.variantId == item.variantId ? updated : i)
            .toList(),
      );
    } else {
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void removeItem(String variantId) {
    state = state.copyWith(
      items: state.items.where((i) => i.variantId != variantId).toList(),
    );
  }

  void updateItemQuantity(String variantId, int quantity) {
    if (quantity <= 0) {
      removeItem(variantId);
      return;
    }
    state = state.copyWith(
      items: state.items
          .map((i) => i.variantId == variantId ? i.copyWith(quantity: quantity) : i)
          .toList(),
    );
  }

  Future<Order?> submit() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = ref.read(createOrderUseCaseProvider);
    final shopId = ref.read(authControllerProvider).value?.shopId;
    
    final result = await useCase(
      customerName: state.customerName,
      customerPhone: state.customerPhone,
      customerAddress: state.customerAddress,
      discountType: state.discountType,
      discountValue: state.discountValue,
      discountReason: state.discountReason,
      shopId: shopId,
      items: state.items
          .map((i) => OrderItemInput(
                variantId: i.variantId,
                quantity: i.quantity,
                unitPrice: i.unitPrice,
              ))
          .toList(),
    );
    return result.fold(
      (f) {
        state = state.copyWith(isLoading: false, errorMessage: f.message);
        return null;
      },
      (order) {
        state = state.copyWith(isLoading: false);
        ref.invalidate(orderListProvider);
        ref.invalidate(productListProvider);
        return order;
      },
    );
  }
}
