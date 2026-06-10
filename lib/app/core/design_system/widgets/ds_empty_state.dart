import 'package:flutter/material.dart';
import '../theme/ds_colors.dart';
import '../theme/ds_spacing.dart';
import '../theme/ds_typography.dart';
import 'ds_button.dart';

class DsEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool isLoading;

  const DsEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.info_outline,
    this.actionText,
    this.onActionPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: DsSpacing.allXXLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Floating background circle for icon
            Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                color: DsColors.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 38,
                color: DsColors.primary,
              ),
            ),
            DsSpacing.gapV24,
            Text(
              title,
              style: DsTypography.headingMedium,
              textAlign: TextAlign.center,
            ),
            DsSpacing.gapV8,
            Text(
              description,
              style: DsTypography.bodyMedium.copyWith(color: DsColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onActionPressed != null) ...[
              DsSpacing.gapV24,
              DsButton(
                text: actionText!,
                onPressed: onActionPressed!,
                isLoading: isLoading,
                width: 200,
                height: 44,
                variant: DsButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
