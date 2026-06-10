import 'package:flutter/material.dart';
import '../../../widgets/bounce_widget.dart';
import '../theme/ds_colors.dart';
import '../theme/ds_spacing.dart';
import '../theme/ds_typography.dart';

enum DsButtonVariant { primary, secondary, outline, text }

class DsButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final DsButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;

  const DsButton({
    super.key,
    this.text,
    this.child,
    required this.onPressed,
    this.variant = DsButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 50.0,
    this.borderRadius = 8.0,
  }) : assert(text != null || child != null, 'Either text or child must be provided');

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    // Resolve color configuration based on variant and disabled state
    Color resolvedBgColor;
    Color resolvedTextColor;
    BorderSide resolvedBorderSide = BorderSide.none;

    switch (variant) {
      case DsButtonVariant.primary:
        resolvedBgColor = isDisabled ? DsColors.border : DsColors.primary;
        resolvedTextColor = isDisabled ? DsColors.textMuted : DsColors.textOnPrimary;
        break;
      case DsButtonVariant.secondary:
        resolvedBgColor = isDisabled ? DsColors.background : DsColors.secondary;
        resolvedTextColor = isDisabled ? DsColors.textMuted : DsColors.primary;
        break;
      case DsButtonVariant.outline:
        resolvedBgColor = Colors.transparent;
        resolvedTextColor = isDisabled ? DsColors.textMuted : DsColors.primary;
        resolvedBorderSide = BorderSide(
          color: isDisabled ? DsColors.border : DsColors.primary,
          width: 1.5,
        );
        break;
      case DsButtonVariant.text:
        resolvedBgColor = Colors.transparent;
        resolvedTextColor = isDisabled ? DsColors.textMuted : DsColors.primary;
        break;
    }

    final Widget buttonContent = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: resolvedTextColor,
              strokeWidth: 2.5,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: resolvedTextColor),
                DsSpacing.gapH8,
              ],
              child ??
                  Text(
                    text!,
                    style: DsTypography.buttonText.copyWith(
                      color: resolvedTextColor,
                    ),
                  ),
            ],
          );

    final buttonWidget = Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: resolvedBgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: resolvedBorderSide != BorderSide.none
            ? Border.fromBorderSide(resolvedBorderSide)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: Padding(
              padding: DsSpacing.symmetricH16,
              child: buttonContent,
            ),
          ),
        ),
      ),
    );

    // Provide immediate visual/tactile feedback on taps if enabled
    if (isDisabled) {
      return buttonWidget;
    } else {
      return BounceWidget(
        scaleFactor: 0.96,
        onTap: onPressed ?? () {},
        child: IgnorePointer(child: buttonWidget),
      );
    }
  }
}
