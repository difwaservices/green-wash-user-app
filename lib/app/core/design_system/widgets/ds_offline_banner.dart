import 'package:flutter/material.dart';
import '../theme/ds_colors.dart';
import '../theme/ds_spacing.dart';
import '../theme/ds_typography.dart';

class DsOfflineBanner extends StatelessWidget {
  final bool isBackOnline;

  const DsOfflineBanner({
    super.key,
    this.isBackOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isBackOnline ? DsColors.success : DsColors.error;
    final icon = isBackOnline ? Icons.wifi : Icons.wifi_off;
    final text = isBackOnline 
        ? 'Back online!' 
        : 'You are offline. Reconnecting...';

    return Material(
      color: backgroundColor,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              DsSpacing.gapH8,
              Text(
                text,
                style: DsTypography.captionBold.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
