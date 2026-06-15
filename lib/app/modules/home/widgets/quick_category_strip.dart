import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/food_models.dart';
import '../../categories/controller/categories_controller.dart';
import '../provider/search_provider.dart';
import '../../../routes/app_routes.dart';

class QuickCategoryStrip extends ConsumerWidget {
  const QuickCategoryStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catsAsync = ref.watch(categoriesProvider);

    return catsAsync.when(
      loading: () => const _Shimmer(),
      error: (_, __) => const SizedBox.shrink(),
      data: (all) {
        final items = all
            .where((c) => !c.name.toLowerCase().contains('flavou'))
            .take(8)
            .toList();
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Categories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.search),
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0891B2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: items.length,
                itemBuilder: (_, i) => _CategoryChip(
                  category: items[i],
                  index: i,
                  onTap: () {
                    ref.read(searchProvider.notifier).applyAdvancedFilters(
                          selectedCategoryIds: [items[i].id],
                        );
                    Navigator.pushNamed(context, AppRoutes.search);
                  },
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms);
      },
    );
  }
}

// ── Category Chip ─────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final FoodCategory category;
  final int index;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.index,
    required this.onTap,
  });

  static const _bgColors = [
    Color(0xFFCFFAFE),
    Color(0xFFE0F2FE),
    Color(0xFFDBEAFE),
    Color(0xFFEDE9FE),
    Color(0xFFF0FDF4),
    Color(0xFFFFF7ED),
    Color(0xFFF0FDF4),
    Color(0xFFFDF4FF),
  ];

  static const _iconColors = [
    Color(0xFF06B6D4),
    Color(0xFF0EA5E9),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFF22C55E),
    Color(0xFFF97316),
    Color(0xFF22C55E),
    Color(0xFFD946EF),
  ];

  Color get _bg => _bgColors[index % _bgColors.length];
  Color get _fg => _iconColors[index % _iconColors.length];

  IconData get _fallbackIcon {
    final n = category.name.toLowerCase();
    if (n.contains('20') || n.contains('can') || n.contains('jar')) {
      return Icons.water_drop_rounded;
    }
    if (n.contains('10') || n.contains('bulk')) return Icons.water_drop;
    if (n.contains('bottle') || n.contains('1l') || n.contains('1 l')) {
      return Icons.local_drink_rounded;
    }
    if (n.contains('500') || n.contains('mini')) return Icons.opacity;
    if (n.contains('mineral') || n.contains('pure') || n.contains('ro')) {
      return Icons.water;
    }
    return Icons.water_drop_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _fg.withValues(alpha: 0.25)),
              ),
              child: category.image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        category.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(_fallbackIcon, color: _fg, size: 26),
                      ),
                    )
                  : Icon(_fallbackIcon, color: _fg, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    )
        .animate(delay: (40 * index).ms)
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.15, end: 0, curve: Curves.easeOut);
  }
}

// ── Loading Shimmer ───────────────────────────────────────────────────────────

class _Shimmer extends StatelessWidget {
  const _Shimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          width: 72,
          margin: const EdgeInsets.only(right: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 9,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1500.ms);
  }
}
