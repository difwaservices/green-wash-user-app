import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/review_service.dart';
import '../../../data/services/order_service.dart';
import '../../../core/constants/app_colors.dart';

class ReviewDialog extends ConsumerStatefulWidget {
  final String orderId;
  final List<Map<String, dynamic>> items; // List of { _id, name, image }
  final String retailerId;
  final bool isOrderReview;

  const ReviewDialog({
    super.key,
    required this.orderId,
    required this.items,
    required this.retailerId,
    this.isOrderReview = false,
  });

  @override
  ConsumerState<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends ConsumerState<ReviewDialog>
    with SingleTickerProviderStateMixin {
  // Map of ratings: { productId: rating }
  final Map<String, int> _ratings = {};
  // Map of comments: { productId: controller }
  final Map<String, TextEditingController> _controllers = {};

  bool _isSubmitting = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize ratings and controllers
    for (var item in widget.items) {
      final id = item['_id']?.toString() ?? '';
      if (id.isNotEmpty) {
        _ratings[id] = 5;
        _controllers[id] = TextEditingController();
      }
    }

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Header ---
              Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.stars_rounded,
                      size: 50, color: Color(0xFF0891B2)),
                ),
              ),

              // --- Body ---
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Column(
                    children: [
                      Text(
                        widget.isOrderReview
                            ? 'Rate Your Experience'
                            : 'Rate Product',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Order #${widget.orderId.substring(widget.orderId.length - 6).toUpperCase()}',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // --- Items List ---
                      ...widget.items.map((item) {
                        final id = item['_id']?.toString() ?? '';
                        final name = item['name']?.toString() ?? 'Item';
                        final image = item['image']?.toString() ?? '';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (image.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        image,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.inventory_2_outlined,
                                                size: 20),
                                      ),
                                    ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  final i = index + 1;
                                  final isSelected = i <= (_ratings[id] ?? 0);
                                  return GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      setState(() => _ratings[id] = i);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Icon(
                                        isSelected
                                            ? Icons.star_rounded
                                            : Icons.star_outline_rounded,
                                        color: isSelected
                                            ? const Color(0xFFFFB000)
                                            : Colors.grey.shade300,
                                        size: 36,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _controllers[id],
                                style: const TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: 'Add a comment (optional)',
                                  isDense: true,
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // --- Footer Buttons ---
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => Navigator.pop(context),
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitReviews,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0891B2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white))
                                : const Text('Submit Reviews',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReviews() async {
    setState(() => _isSubmitting = true);

    final reviewService = ref.read(reviewServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final List<Map<String, dynamic>> productReviews = [];
      for (var item in widget.items) {
        final id = item['_id']?.toString() ?? '';
        if (id.isNotEmpty) {
          productReviews.add({
            'productId': id,
            'rating': _ratings[id] ?? 5,
            'comment': _controllers[id]?.text ?? '',
            'tags': [],
          });
        }
      }

      final success = await reviewService.submitOrderReview(
        orderId: widget.orderId,
        productReviews: productReviews,
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        if (success) {
          // Track this ID locally for instant UI update
          ref.read(ratedOrdersProvider.notifier).add(widget.orderId);
          
          // Still invalidate for background correctness
          ref.invalidate(myOrdersProvider);
          navigator.pop();
          messenger.showSnackBar(
            const SnackBar(
                content: Text('Thank you! Reviews submitted.'),
                backgroundColor: Color(0xFF0891B2),
                behavior: SnackBarBehavior.floating),
          );
        } else {
          messenger.showSnackBar(const SnackBar(
              content: Text('Failed to submit. Item(s) may already be rated.')));
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        final errText = e.toString().toLowerCase();
        if (errText.contains('already reviewed') ||
            errText.contains('already rated')) {
          messenger.showSnackBar(const SnackBar(
              content: Text('You have already rated this order/item.')));
          navigator.pop();
        } else {
          messenger.showSnackBar(const SnackBar(
              content: Text('An error occurred while submitting.')));
        }
      }
    }
  }
}
