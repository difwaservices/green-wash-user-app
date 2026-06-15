import 'package:flutter/material.dart';
import '../widgets/ds_button.dart';
import '../theme/ds_spacing.dart';
import '../theme/ds_typography.dart';

class NavigationGuard extends StatelessWidget {
  final Widget child;
  final bool isDirty;
  final String title;
  final String message;

  const NavigationGuard({
    super.key,
    required this.child,
    required this.isDirty,
    this.title = 'Discard unsaved changes?',
    this.message = 'If you go back now, all your unsaved modifications will be lost.',
  });

  Future<bool> _showDiscardDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: DsTypography.headingSmall,
        ),
        content: Text(
          message,
          style: DsTypography.bodyMedium,
        ),
        actionsPadding: DsSpacing.allLarge,
        actions: [
          Row(
            children: [
              Expanded(
                child: DsButton(
                  text: 'Cancel',
                  variant: DsButtonVariant.outline,
                  onPressed: () => Navigator.of(ctx).pop(false),
                ),
              ),
              DsSpacing.gapH12,
              Expanded(
                child: DsButton(
                  text: 'Discard',
                  variant: DsButtonVariant.primary,
                  onPressed: () => Navigator.of(ctx).pop(true),
                ),
              ),
            ],
          )
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isDirty,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        
        final shouldPop = await _showDiscardDialog(context);
        if (shouldPop && context.mounted) {
          // Manually pop the screen since PopScope blocked the automatic pop
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }
}
