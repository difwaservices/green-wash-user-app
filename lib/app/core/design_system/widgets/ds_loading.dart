import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/ds_colors.dart';
import '../theme/ds_spacing.dart';
import '../theme/ds_typography.dart';

/// A standard pulsing placeholder block to build custom skeleton loaders.
class DsSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const DsSkeleton({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fade(begin: 0.4, end: 0.8, duration: 800.ms, curve: Curves.easeInOut);
  }
}

/// A standard skeleton card for content structures.
class DsSkeletonCard extends StatelessWidget {
  final double height;

  const DsSkeletonCard({
    super.key,
    this.height = 160.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: DsSpacing.allLarge,
      decoration: BoxDecoration(
        color: DsColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DsColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DsSkeleton(width: 80, height: 16),
          DsSpacing.gapV12,
          const DsSkeleton(height: 24),
          DsSpacing.gapV8,
          const DsSkeleton(width: 140, height: 16),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              DsSkeleton(width: 60, height: 20),
              DsSkeleton(width: 100, height: 36, borderRadius: 18),
            ],
          ),
        ],
      ),
    );
  }
}

/// A standard skeleton list-item structure.
class DsSkeletonListTile extends StatelessWidget {
  const DsSkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          const DsSkeleton(width: 48, height: 48, borderRadius: 24),
          DsSpacing.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DsSkeleton(width: 120, height: 16),
                DsSpacing.gapV8,
                const DsSkeleton(height: 12),
              ],
            ),
          ),
          DsSpacing.gapH12,
          const DsSkeleton(width: 40, height: 16),
        ],
      ),
    );
  }
}

/// A blocking loader overlay wrapper to restrict clicks during active background mutations.
class DsLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const DsLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          ModalBarrier(
            color: Colors.black.withOpacity(0.35),
            dismissible: false,
          ),
        if (isLoading)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: DsColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: DsColors.primary,
                    strokeWidth: 3,
                  ),
                  if (message != null) ...[
                    DsSpacing.gapV12,
                    Text(
                      message!,
                      style: DsTypography.bodyMediumSemiBold,
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
