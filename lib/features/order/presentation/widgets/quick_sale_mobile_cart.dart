import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../../customer/presentation/providers/customer_provider.dart';
import '../../../customer/presentation/widgets/customer_form_dialog.dart';
import '../../domain/entities/cart_item.dart';
import '../providers/quick_sale_provider.dart';
import 'discount_input.dart';

/// Triggers a smooth curved flying animation from [startOffset] to [targetOffset].
void runAddToCartFlightAnimation({
  required BuildContext context,
  required Offset startOffset,
  required Offset targetOffset,
  Widget? flyingChild,
  VoidCallback? onArrival,
}) {
  final overlay = Overlay.maybeOf(context);
  if (overlay == null) return;

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (ctx) => _FlyingItemOverlay(
      startOffset: startOffset,
      targetOffset: targetOffset,
      child: flyingChild,
      onComplete: () {
        entry.remove();
        onArrival?.call();
      },
    ),
  );

  overlay.insert(entry);
}

class _FlyingItemOverlay extends StatefulWidget {
  const _FlyingItemOverlay({
    required this.startOffset,
    required this.targetOffset,
    required this.onComplete,
    this.child,
  });

  final Offset startOffset;
  final Offset targetOffset;
  final VoidCallback onComplete;
  final Widget? child;

  @override
  State<_FlyingItemOverlay> createState() => _FlyingItemOverlayState();
}

class _FlyingItemOverlayState extends State<_FlyingItemOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.forward().then((_) {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final t = _animation.value;

        // Linear interpolation for X, curved arc for Y
        final currentX = widget.startOffset.dx +
            (widget.targetOffset.dx - widget.startOffset.dx) * t;

        // Parabolic arc peak in middle
        final arcHeight = 35.0 * (1 - (2 * t - 1) * (2 * t - 1));
        final currentY = widget.startOffset.dy +
            (widget.targetOffset.dy - widget.startOffset.dy) * t -
            arcHeight;

        final scale = 1.0 - (t * 0.5);
        final opacity = (1.0 - (t * 0.2)).clamp(0.0, 1.0);

        return Positioned(
          left: currentX - 16,
          top: currentY - 16,
          child: IgnorePointer(
            child: Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: widget.child ??
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.greenNude,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.greenNude.withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Floating persistent mobile cart bar with bounce pulse animation.
class QuickSaleFloatingCartBar extends ConsumerStatefulWidget {
  const QuickSaleFloatingCartBar({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  ConsumerState<QuickSaleFloatingCartBar> createState() =>
      QuickSaleFloatingCartBarState();
}

class QuickSaleFloatingCartBarState
    extends ConsumerState<QuickSaleFloatingCartBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;
  int _lastItemCount = 0;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_bounceController);
  }

  /// Triggers a bounce pulse animation on the cart bar.
  void bounce() {
    if (mounted) {
      _bounceController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickSaleProvider);
    final totalItems = state.cart.items.fold(0, (sum, i) => sum + i.quantity);

    if (totalItems > _lastItemCount) {
      bounce();
    }
    _lastItemCount = totalItems;

    if (state.cart.isEmpty) {
      return const SizedBox.shrink();
    }

    return ScaleTransition(
      scale: _bounceAnimation,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.greenNude, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.slate900.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Cart Icon with count badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.greenNude.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shopping_bag_rounded,
                          color: AppColors.greenNude,
                          size: 22,
                        ),
                      ),
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.greenNude,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '$totalItems',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // Total Amount info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$totalItems ${totalItems == 1 ? 'item' : 'items'} in cart',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate500,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(state.totalAmount),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action capsule
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greenNude,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Redesigned sleek mobile bottom sheet for Quick Sale.
void showQuickSaleMobileCart(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _QuickSaleCartSheet(),
  );
}

class _QuickSaleCartSheet extends ConsumerStatefulWidget {
  const _QuickSaleCartSheet();

  @override
  ConsumerState<_QuickSaleCartSheet> createState() =>
      _QuickSaleCartSheetState();
}

class _QuickSaleCartSheetState extends ConsumerState<_QuickSaleCartSheet> {
  bool _showCustomerField = false;
  late final TextEditingController _customerController;
  Customer? _matchedCustomer;

  @override
  void initState() {
    super.initState();
    final currentName = ref.read(quickSaleProvider).customerName;
    _customerController = TextEditingController(text: currentName);
    _showCustomerField = currentName.isNotEmpty;
  }

  @override
  void dispose() {
    _customerController.dispose();
    super.dispose();
  }

  void _onCustomerSelected(Customer c, QuickSale notifier) {
    _customerController.text = c.name;
    notifier.updateCustomer(name: c.name, id: c.id);
    setState(() {
      _matchedCustomer = c;
      _showCustomerField = true;
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _addNewCustomer(QuickSale notifier) async {
    final newCustomer = await CustomerFormDialog.show(context);
    if (newCustomer != null && mounted) {
      _onCustomerSelected(newCustomer, notifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickSaleProvider);
    final notifier = ref.read(quickSaleProvider.notifier);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final totalItems = state.cart.items.fold(0, (sum, i) => sum + i.quantity);
    final screenHeight = MediaQuery.of(context).size.height;
    final customers = ref.watch(customerListProvider).value ?? [];

    if (_matchedCustomer == null && state.customerName.isNotEmpty) {
      final nameLower = state.customerName.trim().toLowerCase();
      _matchedCustomer = customers.where((c) =>
          c.name.toLowerCase() == nameLower || c.phone == nameLower).firstOrNull;
    }

    final query = _customerController.text.trim().toLowerCase();
    final suggestions = query.isNotEmpty && _matchedCustomer == null
        ? customers.where((c) {
            return c.name.toLowerCase().contains(query) || c.phone.contains(query);
          }).take(4).toList()
        : <Customer>[];

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.75,
      ),
      margin: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.slate300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 12, 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.greenNude.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      color: AppColors.greenNude,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Sale Cart',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.slate100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$totalItems',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (state.cart.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        _customerController.clear();
                        notifier.resetSale();
                        setState(() {
                          _matchedCustomer = null;
                          _showCustomerField = false;
                        });
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.slate500,
                      size: 20,
                    ),
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.slate200),
            // Cart Items List
            Expanded(
              child: state.cart.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: AppColors.slate100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.remove_shopping_cart_outlined,
                              size: 26,
                              color: AppColors.slate400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Tap any product to add to cart',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.slate400,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      itemCount: state.cart.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = state.cart.items[index];
                        return _CartItemMobileTile(
                          item: item,
                          onIncrement: () => notifier.updateQuantity(
                            item.variantId,
                            item.quantity + 1,
                          ),
                          onDecrement: () => notifier.updateQuantity(
                            item.variantId,
                            item.quantity - 1,
                          ),
                          onRemove: () =>
                              notifier.removeFromCart(item.variantId),
                        );
                      },
                    ),
            ),
            // Bottom Checkout Summary
            if (state.cart.isNotEmpty)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: AppColors.slate200, width: 1),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Error Message Banner
                    if (state.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 14, color: AppColors.danger),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  state.errorMessage!,
                                  style: const TextStyle(
                                      color: AppColors.danger, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Customer / Credit Section
                    () {
                      final isCredit = state.paymentMethod == 'credit';
                      final showCustomer =
                          isCredit || _showCustomerField || state.customerName.isNotEmpty;

                      if (!showCustomer) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () =>
                                  setState(() => _showCustomerField = true),
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.person_add_alt_1_outlined,
                                      size: 16,
                                      color: AppColors.greenNude,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Add Customer (Optional)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.greenNude,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Customer Header with Required badge and + New Customer
                            Row(
                              children: [
                                Text(
                                  isCredit ? 'Customer *' : 'Customer (Optional)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isCredit &&
                                            state.customerName.trim().isEmpty
                                        ? AppColors.danger
                                        : AppColors.slate700,
                                  ),
                                ),
                                if (isCredit) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.danger
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Required for Credit',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.danger,
                                      ),
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                InkWell(
                                  onTap: () => _addNewCustomer(notifier),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.add,
                                            size: 14,
                                            color: AppColors.greenNude),
                                        SizedBox(width: 3),
                                        Text(
                                          'New Customer',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.greenNude,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.slate50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isCredit &&
                                          state.customerName.trim().isEmpty
                                      ? AppColors.danger.withValues(alpha: 0.6)
                                      : AppColors.slate200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 16,
                                    color: isCredit &&
                                            state.customerName.trim().isEmpty
                                        ? AppColors.danger
                                        : AppColors.slate600,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _customerController,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.slate900,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 7),
                                        hintText: isCredit
                                            ? 'Search customer or enter name *'
                                            : 'Customer Name / Phone (Optional)',
                                        hintStyle: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.slate400,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (val) {
                                        final valLower =
                                            val.trim().toLowerCase();
                                        final matched = customers
                                            .where((c) =>
                                                c.name.toLowerCase() ==
                                                    valLower ||
                                                c.phone == valLower)
                                            .firstOrNull;
                                        notifier.updateCustomer(
                                            name: val, id: matched?.id);
                                        setState(() {
                                          _matchedCustomer = matched;
                                        });
                                      },
                                    ),
                                  ),
                                  if (state.customerName.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          size: 16, color: AppColors.slate400),
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        _customerController.clear();
                                        notifier.updateCustomer(
                                            name: '', id: null);
                                        setState(() {
                                          _matchedCustomer = null;
                                          if (!isCredit) {
                                            _showCustomerField = false;
                                          }
                                        });
                                      },
                                    )
                                  else if (!isCredit)
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          size: 16, color: AppColors.slate400),
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        setState(() {
                                          _showCustomerField = false;
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                            if (isCredit && state.customerName.trim().isEmpty)
                              const Padding(
                                padding: EdgeInsets.only(top: 4, left: 2),
                                child: Text(
                                  'Customer selection or creation is required for credit.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.danger,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            // Matched Customer Credit Info
                            if (_matchedCustomer != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, left: 2),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _matchedCustomer!.isLimitReached
                                        ? AppColors.danger
                                            .withValues(alpha: 0.12)
                                        : AppColors.success
                                            .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _matchedCustomer!.isLimitReached
                                            ? Icons.warning_amber_rounded
                                            : Icons
                                                .account_balance_wallet_outlined,
                                        size: 13,
                                        color: _matchedCustomer!.isLimitReached
                                            ? AppColors.danger
                                            : AppColors.success,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        _matchedCustomer!.hasDebt
                                            ? 'Debt: ${CurrencyFormatter.format(_matchedCustomer!.currentDebt)}'
                                            : 'No Debt',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: _matchedCustomer!
                                                  .isLimitReached
                                              ? AppColors.danger
                                              : AppColors.success,
                                        ),
                                      ),
                                      if (_matchedCustomer!.creditLimit > 0) ...[
                                        const SizedBox(width: 6),
                                        Text(
                                          '| Limit: ${CurrencyFormatter.format(_matchedCustomer!.creditLimit)}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.slate600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            // Quick suggestion chips when typing
                            if (suggestions.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: SizedBox(
                                  height: 26,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: suggestions.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 6),
                                    itemBuilder: (ctx, i) {
                                      final c = suggestions[i];
                                      return InkWell(
                                        onTap: () => _onCustomerSelected(
                                            c, notifier),
                                        borderRadius:
                                            BorderRadius.circular(13),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.slate100,
                                            borderRadius:
                                                BorderRadius.circular(13),
                                            border: Border.all(
                                                color: AppColors.slate200),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                c.name,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.slate800,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '(${c.phone})',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.slate500,
                                                ),
                                              ),
                                              if (c.hasDebt) ...[
                                                const SizedBox(width: 4),
                                                Container(
                                                  width: 5,
                                                  height: 5,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColors.danger,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }(),

                    // Payment Method selector (single horizontal row)
                    Row(
                      children: [
                        const Text(
                          'Payment:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _PaymentMethodChip(
                                  label: 'Cash / COD',
                                  value: 'cod',
                                  selectedValue: state.paymentMethod,
                                  onSelected: notifier.updatePaymentMethod,
                                ),
                                const SizedBox(width: 6),
                                _PaymentMethodChip(
                                  label: 'Credit (အကြွေး)',
                                  value: 'credit',
                                  selectedValue: state.paymentMethod,
                                  onSelected: (val) {
                                    notifier.updatePaymentMethod(val);
                                    setState(() => _showCustomerField = true);
                                  },
                                ),
                                const SizedBox(width: 6),
                                _PaymentMethodChip(
                                  label: 'KBZPay',
                                  value: 'kbz_pay',
                                  selectedValue: state.paymentMethod,
                                  onSelected: notifier.updatePaymentMethod,
                                ),
                                const SizedBox(width: 6),
                                _PaymentMethodChip(
                                  label: 'WavePay',
                                  value: 'wave_pay',
                                  selectedValue: state.paymentMethod,
                                  onSelected: notifier.updatePaymentMethod,
                                ),
                                const SizedBox(width: 6),
                                _PaymentMethodChip(
                                  label: 'Bank Transfer',
                                  value: 'bank_transfer',
                                  selectedValue: state.paymentMethod,
                                  onSelected: notifier.updatePaymentMethod,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Discount Section
                    DiscountInput(
                      subtotal: state.cart.total,
                      discount: state.discount,
                      onApply: (d) async => notifier.updateDiscount(d),
                      onRemove: () async => notifier.removeDiscount(),
                    ),
                    const SizedBox(height: 8),

                    // Charge Button with Total
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greenNude,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: state.isLoading
                            ? null
                            : () async {
                                await notifier.submitSale();
                                if (context.mounted &&
                                    ref
                                            .read(quickSaleProvider)
                                            .completedOrder !=
                                        null) {
                                  Navigator.of(context).pop();
                                }
                              },
                        child: state.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Complete Sale',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.format(state.totalAmount),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodChip extends StatelessWidget {
  const _PaymentMethodChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  final String label;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    return InkWell(
      onTap: () => onSelected(value),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.greenNude.withValues(alpha: 0.15)
              : AppColors.slate100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.greenNude : AppColors.slate200,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.greenNude : AppColors.slate700,
          ),
        ),
      ),
    );
  }
}

class _CartItemMobileTile extends StatelessWidget {
  const _CartItemMobileTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.slate200, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.slate100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 20,
              color: AppColors.slate600,
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.variantDisplayName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(item.subtotal),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Stepper
          Container(
            decoration: BoxDecoration(
              color: AppColors.slate100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.slate200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onDecrement,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Icon(
                      Icons.remove,
                      size: 14,
                      color: AppColors.slate700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                    ),
                  ),
                ),
                InkWell(
                  onTap:
                      item.quantity < item.availableStock ? onIncrement : null,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(10),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Icon(
                      Icons.add,
                      size: 14,
                      color: item.quantity < item.availableStock
                          ? AppColors.slate700
                          : AppColors.slate300,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(
              Icons.close_rounded,
              size: 16,
              color: AppColors.slate400,
            ),
            tooltip: 'Remove',
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
        ],
      ),
    );
  }
}
