import 'package:flutter/material.dart';
import '../theme/ds_colors.dart';
import '../theme/ds_spacing.dart';
import '../theme/ds_typography.dart';

class DsTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showClearButton;
  final int maxLines;
  final FocusNode? focusNode;

  const DsTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.showClearButton = true,
    this.maxLines = 1,
    this.focusNode,
  });

  @override
  State<DsTextField> createState() => _DsTextFieldState();
}

class _DsTextFieldState extends State<DsTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _obscureText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    // Only dispose if created locally
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onFocusChanged() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Suffix controls
    Widget? resolvedSuffixIcon;

    if (widget.obscureText) {
      resolvedSuffixIcon = IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: DsColors.textSecondary,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.showClearButton && _controller.text.isNotEmpty && widget.enabled) {
      resolvedSuffixIcon = IconButton(
        icon: const Icon(
          Icons.cancel_outlined,
          color: DsColors.textMuted,
          size: 20,
        ),
        onPressed: () {
          _controller.clear();
          if (widget.onChanged != null) {
            widget.onChanged!('');
          }
        },
      );
    } else {
      resolvedSuffixIcon = widget.suffixIcon;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: DsTypography.captionBold.copyWith(
              color: _isFocused ? DsColors.inputFocused : DsColors.textPrimary,
            ),
          ),
          DsSpacing.gapV8,
        ],
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          style: DsTypography.bodyLarge.copyWith(
            color: widget.enabled ? DsColors.textPrimary : DsColors.textMuted,
          ),
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: DsTypography.bodyMedium.copyWith(color: DsColors.textMuted),
            helperText: widget.helperText,
            helperStyle: DsTypography.caption,
            errorText: widget.errorText,
            errorStyle: DsTypography.caption.copyWith(color: DsColors.error),
            prefixIcon: widget.prefixIcon,
            suffixIcon: resolvedSuffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            filled: true,
            fillColor: widget.enabled ? DsColors.surface : DsColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: DsColors.border, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: DsColors.border, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: DsColors.inputFocused, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: DsColors.error, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: DsColors.error, width: 2.0),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: DsColors.border, width: 1.0),
            ),
          ),
        ),
      ],
    );
  }
}
