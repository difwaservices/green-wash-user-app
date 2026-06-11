import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/design_system/design_system.dart';
import '../../../data/services/shop_service.dart';
import '../../../data/models/banner_model.dart';
import '../../../widgets/bounce_widget.dart';

class AdminBannersPage extends ConsumerStatefulWidget {
  const AdminBannersPage({super.key});

  @override
  ConsumerState<AdminBannersPage> createState() => _AdminBannersPageState();
}

class _AdminBannersPageState extends ConsumerState<AdminBannersPage> {
  bool _isLoading = false;

  void _setLoading(bool val) {
    if (mounted) {
      setState(() {
        _isLoading = val;
      });
    }
  }

  Future<void> _deleteBanner(String id) async {
    // Show confirmation
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Banner', style: DsTypography.headingSmall),
        content: Text('Are you sure you want to delete this offer banner?', style: DsTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: DsColors.error)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    _setLoading(true);
    try {
      final success = await ref.read(shopServiceProvider).deleteBanner(id);
      if (success) {
        ref.invalidate(bannersProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Banner deleted successfully'),
              backgroundColor: DsColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        throw Exception('Delete failed');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete banner: $e'),
            backgroundColor: DsColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  void _showAddBannerDialog() {
    final titleController = TextEditingController();
    final imageController = TextEditingController();
    final valueController = TextEditingController();
    final priorityController = TextEditingController(text: '1');
    String actionType = 'none';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            return AlertDialog(
              title: Text('Add New Offer Banner', style: DsTypography.headingSmall),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DsTextField(
                        controller: titleController,
                        labelText: 'Banner Title',
                        hintText: 'e.g. 20% Off Mineral Cans',
                        validator: (val) => val == null || val.isEmpty ? 'Title is required' : null,
                      ),
                      DsSpacing.gapV12,
                      DsTextField(
                        controller: imageController,
                        labelText: 'Image URL',
                        hintText: 'https://example.com/banner.jpg',
                        keyboardType: TextInputType.url,
                        validator: (val) => val == null || val.isEmpty ? 'Image URL is required' : null,
                      ),
                      DsSpacing.gapV12,
                      // Action Type selector
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Action Redirect Type', style: DsTypography.captionBold),
                          DsSpacing.gapV8,
                          DropdownButtonFormField<String>(
                            initialValue: actionType,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(color: DsColors.border),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'none', child: Text('No Redirect (None)')),
                              DropdownMenuItem(value: 'url', child: Text('External Link (URL)')),
                              DropdownMenuItem(value: 'shop', child: Text('Shop Details (Shop ID)')),
                              DropdownMenuItem(value: 'product', child: Text('Product Details (Product ID)')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setStateDialog(() {
                                  actionType = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      if (actionType != 'none') ...[
                        DsSpacing.gapV12,
                        DsTextField(
                          controller: valueController,
                          labelText: actionType == 'url' ? 'Link URL' : 'Target Entity ID',
                          hintText: actionType == 'url' ? 'https://...' : 'Enter target database ID',
                          validator: (val) => val == null || val.isEmpty ? 'Redirect value is required' : null,
                        ),
                      ],
                      DsSpacing.gapV12,
                      DsTextField(
                        controller: priorityController,
                        labelText: 'Priority Level (Higher slides first)',
                        hintText: 'e.g. 1, 5, 10',
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || int.tryParse(val) == null ? 'Enter valid priority' : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() != true) return;

                    Navigator.pop(context); // Close dialog
                    _setLoading(true);

                    final payload = {
                      'title': titleController.text.trim(),
                      'image': imageController.text.trim(),
                      'actionType': actionType,
                      'actionValue': actionType == 'none' ? '' : valueController.text.trim(),
                      'priority': int.parse(priorityController.text.trim()),
                    };

                    try {
                      final banner = await ref.read(shopServiceProvider).createBanner(payload);
                      if (banner != null) {
                        ref.invalidate(bannersProvider);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Banner added successfully!'),
                              backgroundColor: DsColors.success,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } else {
                        throw Exception('API returned null');
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to add banner: $e'),
                            backgroundColor: DsColors.error,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    } finally {
                      _setLoading(false);
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bannersAsync = ref.watch(bannersProvider);

    return DsLoadingOverlay(
      isLoading: _isLoading,
      message: 'Processing action...',
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          title: Text(
            'Manage Banners',
            style: DsTypography.headingMedium,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: const Color(0xFF00ACC1).withOpacity(0.1),
              height: 1,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddBannerDialog,
          backgroundColor: DsColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: RefreshIndicator(
          onRefresh: () => ref.refresh(bannersProvider.future),
          child: bannersAsync.when(
            data: (banners) {
              if (banners.isEmpty) {
                return const DsEmptyState(
                  title: 'No Active Offer Banners',
                  description: 'Add sliding banner campaigns to highlight offers or feature updates on the customer dashboard home page.',
                  icon: Icons.campaign_outlined,
                );
              }

              // Sort by priority locally as fallback
              final sortedBanners = List<AppBanner>.from(banners)
                ..sort((a, b) => b.priority.compareTo(a.priority));

              return ListView.separated(
                padding: DsSpacing.allLarge,
                itemCount: sortedBanners.length,
                separatorBuilder: (ctx, idx) => DsSpacing.gapV12,
                itemBuilder: (ctx, idx) {
                  final banner = sortedBanners[idx];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: DsColors.border),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: DsSpacing.allMedium,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 80,
                              height: 50,
                              child: Image.network(
                                banner.imageUrl,
                                fit: BoxFit.fill,
                                errorBuilder: (c, e, s) => Container(
                                  color: DsColors.secondary,
                                  child: const Icon(Icons.image_not_supported, color: DsColors.primary, size: 24),
                                ),
                              ),
                            ),
                          ),
                          DsSpacing.gapH12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner.title,
                                  style: DsTypography.headingSmall.copyWith(fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                DsSpacing.gapV4,
                                Text(
                                  'Action: ${banner.actionType.toUpperCase()} (${banner.actionValue.isNotEmpty ? banner.actionValue : "N/A"})',
                                  style: DsTypography.overline,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                DsSpacing.gapV4,
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: DsColors.secondary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Priority: ${banner.priority}',
                                    style: DsTypography.overline.copyWith(color: DsColors.primary, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: DsColors.error),
                            onPressed: () => _deleteBanner(banner.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => ListView.builder(
              padding: DsSpacing.allLarge,
              itemCount: 4,
              itemBuilder: (c, i) => const DsSkeletonListTile(),
            ),
            error: (e, _) => DsEmptyState(
              title: 'Error loading banners',
              description: e.toString(),
              icon: Icons.error_outline,
            ),
          ),
        ),
      ),
    );
  }
}
