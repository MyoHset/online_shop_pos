import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_provider.dart';
import 'customer_form_dialog.dart';

/// Autocomplete customer search picker that matches across BOTH Name and Phone.
class CustomerSearchPicker extends ConsumerStatefulWidget {
  const CustomerSearchPicker({
    super.key,
    this.selectedCustomer,
    required this.onCustomerSelected,
    this.hintText = 'Search by name or phone...',
  });

  final Customer? selectedCustomer;
  final ValueChanged<Customer?> onCustomerSelected;
  final String hintText;

  @override
  ConsumerState<CustomerSearchPicker> createState() => _CustomerSearchPickerState();
}

class _CustomerSearchPickerState extends ConsumerState<CustomerSearchPicker> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final _tapRegionGroupId = Object();

  @override
  void initState() {
    super.initState();
    if (widget.selectedCustomer != null) {
      _searchController.text =
          '${widget.selectedCustomer!.name} (${widget.selectedCustomer!.phone})';
    }
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomerSearchPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCustomer != oldWidget.selectedCustomer) {
      if (widget.selectedCustomer != null) {
        _searchController.text =
            '${widget.selectedCustomer!.name} (${widget.selectedCustomer!.phone})';
      } else {
        _searchController.clear();
      }
    }
  }

  @override
  void dispose() {
    _hideOverlay();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showOverlay() {
    if (!mounted || _overlayEntry != null) return;
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 6.0),
            child: TapRegion(
              groupId: _tapRegionGroupId,
              child: Material(
                elevation: 6,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                child: Consumer(
                  builder: (context, ref, _) {
                    final customersAsync = ref.watch(customerListProvider);

                    return customersAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      error: (err, _) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Error loading customers: $err',
                          style: const TextStyle(color: AppColors.danger, fontSize: 13),
                        ),
                      ),
                      data: (customers) {
                        final query = _searchController.text.toLowerCase().trim();

                        final filtered = customers.where((c) {
                          if (query.isEmpty) return true;
                          final matchName = c.name.toLowerCase().contains(query);
                          final matchPhone = c.phone.contains(query);
                          return matchName || matchPhone;
                        }).toList();

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (filtered.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 20.0,
                                ),
                                child: Text(
                                  'No customer found for "$query"',
                                  style: const TextStyle(
                                    color: AppColors.slate500,
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            else
                              Flexible(
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  shrinkWrap: true,
                                  itemCount: filtered.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1, color: AppColors.slate100),
                                  itemBuilder: (context, index) {
                                    final customer = filtered[index];
                                    return ListTile(
                                      dense: true,
                                      leading: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.slate100,
                                        child: Text(
                                          customer.name.isNotEmpty
                                              ? customer.name.characters.first.toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: AppColors.slate800,
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(
                                            customer.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            customer.phone,
                                            style: const TextStyle(
                                              color: AppColors.slate500,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: customer.hasDebt
                                          ? Text(
                                              'Outstanding Debt: ${CurrencyFormatter.format(customer.currentDebt)}',
                                              style: const TextStyle(
                                                color: AppColors.danger,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : const Text(
                                              'No debt',
                                              style: TextStyle(
                                                color: AppColors.success,
                                                fontSize: 11,
                                              ),
                                            ),
                                      trailing: customer.isLimitReached
                                          ? const Tooltip(
                                              message: 'Credit limit reached',
                                              child: Icon(
                                                Icons.warning_amber_rounded,
                                                color: AppColors.warning,
                                                size: 20,
                                              ),
                                            )
                                          : null,
                                      onTap: () {
                                        _selectCustomer(customer);
                                      },
                                    );
                                  },
                                ),
                              ),

                            // Quick Add Button at the bottom
                            const Divider(height: 1, color: AppColors.slate200),
                            InkWell(
                              onTap: () async {
                                _hideOverlay();
                                final isPhone = RegExp(r'^[0-9+]+$').hasMatch(query);
                                final newCustomer = await CustomerFormDialog.show(
                                  context,
                                  initialName: isPhone ? null : query,
                                  initialPhone: isPhone ? query : null,
                                );
                                if (newCustomer != null) {
                                  _selectCustomer(newCustomer);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.person_add_alt_1_outlined,
                                      size: 18,
                                      color: AppColors.info,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      query.isEmpty
                                          ? '+ Add New Customer'
                                          : '+ Add New Customer ($query)',
                                      style: const TextStyle(
                                        color: AppColors.info,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectCustomer(Customer customer) {
    _hideOverlay();
    _searchController.text = '${customer.name} (${customer.phone})';
    _focusNode.unfocus();
    widget.onCustomerSelected(customer);
  }

  void _clearSelection() {
    _hideOverlay();
    _searchController.clear();
    ref.read(customerSearchQueryProvider.notifier).clear();
    widget.onCustomerSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selectedCustomer != null;

    return TapRegion(
      groupId: _tapRegionGroupId,
      onTapOutside: (_) => _hideOverlay(),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            Icons.search,
            color: isSelected ? AppColors.success : AppColors.slate500,
          ),
          suffixIcon: isSelected || _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: _clearSelection,
                )
              : null,
          filled: true,
          fillColor: isSelected ? AppColors.slate50 : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.slate200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isSelected ? AppColors.success.withValues(alpha: 0.5) : AppColors.slate200,
            ),
          ),
        ),
        onChanged: (val) {
          if (_overlayEntry == null && _focusNode.hasFocus) {
            _showOverlay();
          }
          ref.read(customerSearchQueryProvider.notifier).updateQuery(val);
          _overlayEntry?.markNeedsBuild();
        },
      ),
    ),
  );
  }
}
