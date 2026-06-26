import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/search_model.dart';
import '../../../data/models/shop_product_model.dart';
import '../../../core/constants/app_colors.dart';
import '../provider/search_provider.dart';
import 'restaurant_menu_page.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/product_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as String?;
      if (args != null && args.isNotEmpty) {
        _searchController.text = args;
        _onSearch(args);
      } else {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    if (value.isNotEmpty) {
      ref.read(searchProvider.notifier).search(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onSubmitted: _onSearch,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search laundry services, packages...',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              prefixIcon:
                  Icon(Icons.search, color: AppColors.primary, size: 20),
              suffixIcon: _searchController.text.isNotEmpty || searchState.priceRange != null || searchState.selectedCategoryIds.isNotEmpty || searchState.selectedDeliverySlots.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchProvider.notifier).clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (val) {
              setState(() {});
              if (val.trim().length >= 2) {
                ref.read(searchProvider.notifier).search(val.trim());
              } else if (val.isEmpty) {
                ref.read(searchProvider.notifier).clear();
              }
            },
          ),
        ),
      ),
      body: Column(
        children: [
          if (searchState.hasSearched && !searchState.isLoading)
            _buildFilters(searchState),
          Expanded(
            child: _buildBody(searchState),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(SearchState state) {
    final bool isFiltering = state.priceRange != null ||
        state.selectedCategoryIds.isNotEmpty ||
        state.selectedDeliverySlots.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isFiltering ? 'Product Results' : 'Services & Partners',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isFiltering
                      ? '${state.paginatedResult?.products.length ?? 0}'
                      : '${state.result?.shops.length ?? 0}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              final initialResult = isFiltering
                  ? FilterResult(
                      priceRange: state.priceRange ?? const RangeValues(10, 2000),
                      selectedCategoryIds: state.selectedCategoryIds,
                      selectedDeliverySlots: state.selectedDeliverySlots,
                    )
                  : null;

              final result = await FilterBottomSheet.show(context,
                  initialResult: initialResult);
              if (result != null && mounted) {
                ref.read(searchProvider.notifier).applyAdvancedFilters(
                      priceRange: result.priceRange,
                      selectedCategoryIds: result.selectedCategoryIds,
                      selectedDeliverySlots: result.selectedDeliverySlots,
                    );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isFiltering ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isFiltering ? AppColors.primary : const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.tune_rounded,
                      size: 18,
                      color: isFiltering ? Colors.white : const Color(0xFF334155)),
                  const SizedBox(width: 6),
                  Text(
                    isFiltering ? 'Applied' : 'Filter',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isFiltering ? Colors.white : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SearchState state) {
    if (state.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _onSearch(_searchController.text),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!state.hasSearched) {
      return _buildInitialState();
    }

    final bool isFiltering = state.priceRange != null ||
        state.selectedCategoryIds.isNotEmpty ||
        state.selectedDeliverySlots.isNotEmpty;

    // SCENARIO 1: Filter is Active -> Show Product Grid
    if (isFiltering) {
      final filteredProducts = state.paginatedResult?.products ?? [];
      if (filteredProducts.isEmpty && !state.isLoading) {
        return _buildEmptyState(
            'No products match these filters', Icons.filter_list_off);
      }
      final double screenWidth = MediaQuery.of(context).size.width;
      final int crossAxisCount = screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2);
      final double itemWidth = (screenWidth - 32 - (crossAxisCount - 1) * 16) / crossAxisCount;
      final double targetHeight = (itemWidth * 1.5).clamp(230.0, 265.0);
      final double childAspectRatio = itemWidth / targetHeight;

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) => ProductCard(product: filteredProducts[index].toProduct()),
      );
    }

    // SCENARIO 2: Search is Active -> Show Plant List
    final shops = state.result?.shops ?? [];
    if (shops.isEmpty) {
      return _buildEmptyState(
          'No services found for "${state.query}"', Icons.sentiment_dissatisfied);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: shops.length,
      itemBuilder: (context, index) {
        return _buildShopCard(shops[index]);
      },
    );
  }

  Widget _buildShopCard(SearchShop shop) {
    return GestureDetector(
      onTap: () {
        final shopModel = ShopModel(id: shop.id, name: shop.name);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantMenuPage(shop: shopModel),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                   Image.network(
                    shop.image,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade100,
                      child: const Icon(Icons.business_rounded, color: Colors.grey),
                    ),
                  ),
                  if (!shop.isShopActive)
                    Container(
                      width: 70,
                      height: 70,
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(
                        child: Text('CLOSED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 10, color: Colors.green),
                            const SizedBox(width: 2),
                            Text(shop.rating.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shop.location,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Delivers in ${shop.deliveryTime}',
                    style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    final categories = [
      {'icon': Icons.local_laundry_service_rounded, 'name': 'Wash & Fold'},
      {'icon': Icons.dry_cleaning_rounded, 'name': 'Dry Cleaning'},
      {'icon': Icons.iron_rounded, 'name': 'Ironing Only'},
      {'icon': Icons.king_bed_rounded, 'name': 'Blankets'},
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_rounded, size: 64, color: Color(0xFF2E7D32)),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'What are you looking for?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0A4429)),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Search for specific services, packages,\nor partner laundromats near you.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Popular Services',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0A4429)),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = categories[index]['name'] as String;
                  _onSearch(categories[index]['name'] as String);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE8F5E9), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0A4429).withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(categories[index]['icon'] as IconData, color: const Color(0xFF2E7D32), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        categories[index]['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1B5E20), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final int count;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

