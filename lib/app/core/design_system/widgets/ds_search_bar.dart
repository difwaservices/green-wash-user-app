import 'package:flutter/material.dart';
import '../theme/ds_colors.dart';
import '../theme/ds_typography.dart';
import '../ux/debounce.dart';

class DsSearchBar extends StatefulWidget {
  final ValueChanged<String>? onSearch;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;
  final String hintText;
  final int debounceMs;
  final bool autofocus;

  const DsSearchBar({
    super.key,
    this.onSearch,
    this.onClear,
    this.onFilterTap,
    this.controller,
    this.hintText = 'Search...',
    this.debounceMs = 300,
    this.autofocus = false,
  });

  @override
  State<DsSearchBar> createState() => _DsSearchBarState();
}

class _DsSearchBarState extends State<DsSearchBar> {
  late TextEditingController _controller;
  late Debounce _debouncer;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _debouncer = Debounce(delay: Duration(milliseconds: widget.debounceMs));
    _controller.addListener(_onTextChanged);
    _showClear = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _debouncer.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    final showClear = text.isNotEmpty;
    if (showClear != _showClear) {
      setState(() {
        _showClear = showClear;
      });
    }

    if (widget.onSearch != null) {
      _debouncer.run(() {
        widget.onSearch!(text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DsColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DsColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Icon(
              Icons.search,
              color: DsColors.textSecondary,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              style: DsTypography.bodyLarge,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: DsTypography.bodyMedium.copyWith(color: DsColors.textMuted),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 12.0,
                ),
              ),
            ),
          ),
          if (_showClear)
            IconButton(
              icon: const Icon(
                Icons.clear,
                color: DsColors.textSecondary,
                size: 20,
              ),
              onPressed: () {
                _controller.clear();
                if (widget.onClear != null) {
                  widget.onClear!();
                }
              },
            ),
          if (widget.onFilterTap != null) ...[
            Container(
              height: 24,
              width: 1,
              color: DsColors.border,
            ),
            IconButton(
              icon: const Icon(
                Icons.tune,
                color: DsColors.primary,
                size: 20,
              ),
              onPressed: widget.onFilterTap,
            ),
          ],
        ],
      ),
    );
  }
}
