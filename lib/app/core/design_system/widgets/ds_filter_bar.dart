import 'package:flutter/material.dart';
import '../../../widgets/bounce_widget.dart';
import '../theme/ds_colors.dart';
import '../theme/ds_spacing.dart';
import '../theme/ds_typography.dart';

class DsFilterBar extends StatelessWidget {
  final List<String> options;
  final Set<String> selectedOptions;
  final ValueChanged<String> onSelected;
  final double horizontalPadding;

  const DsFilterBar({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onSelected,
    this.horizontalPadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      child: Row(
        children: options.map((option) {
          final isSelected = selectedOptions.contains(option);
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: BounceWidget(
              scaleFactor: 0.95,
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? DsColors.primaryLight : DsColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? DsColors.primary : DsColors.border,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      const Icon(
                        Icons.check,
                        size: 14,
                        color: DsColors.primary,
                      ),
                      DsSpacing.gapH4,
                    ],
                    Text(
                      option,
                      style: DsTypography.captionBold.copyWith(
                        color: isSelected ? DsColors.primary : DsColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
