import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable search text field providing a modern, consistent aesthetic
/// across all screens (Orders, Customers, Products, Quick Sale, etc.).
class SearchTextField extends StatefulWidget {
  const SearchTextField({
    required this.value,
    required this.onChanged,
    this.hintText = 'Search…',
    this.prefixIcon,
    this.width,
    this.height = 40,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.onClear,
    this.focusNode,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String hintText;
  final Widget? prefixIcon;
  final double? width;
  final double height;
  final Duration debounceDuration;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late final TextEditingController _ctrl;
  late final FocusNode _focusNode;
  bool _internalFocus = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _internalFocus = true;
    }
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(SearchTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _ctrl.text != widget.value) {
      _ctrl.text = widget.value;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    _focusNode.removeListener(_onFocusChange);
    if (_internalFocus) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleChanged(String text) {
    setState(() {});
    if (widget.debounceDuration == Duration.zero) {
      widget.onChanged(text);
      return;
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(text);
    });
  }

  void _handleClear() {
    _ctrl.clear();
    setState(() {});
    widget.onChanged('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final hasFocus = _focusNode.hasFocus;
    final hasText = _ctrl.text.isNotEmpty;

    final field = SizedBox(
      height: widget.height,
      child: TextField(
        controller: _ctrl,
        focusNode: _focusNode,
        onChanged: _handleChanged,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.slate900,
        ),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            fontSize: 13,
            color: AppColors.slate400,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: widget.prefixIcon != null
              ? IconTheme(
                  data: IconThemeData(
                    size: 18,
                    color: hasFocus || hasText
                        ? AppColors.slate900
                        : AppColors.slate400,
                  ),
                  child: widget.prefixIcon!,
                )
              : Icon(
                  Icons.search,
                  size: 18,
                  color: hasFocus || hasText
                      ? AppColors.slate900
                      : AppColors.slate400,
                ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          suffixIcon: hasText
              ? IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  color: AppColors.slate400,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: _handleClear,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 40,
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 40,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.slate200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: hasText ? AppColors.slate700 : AppColors.slate200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.slate900,
              width: 1.5,
            ),
          ),
        ),
      ),
    );

    if (widget.width != null) {
      return SizedBox(width: widget.width, child: field);
    }
    return field;
  }
}
