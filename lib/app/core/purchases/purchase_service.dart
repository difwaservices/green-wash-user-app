import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Manages in-app subscription purchases.
/// Product IDs must match what you create in Google Play Console / App Store Connect.
class PurchaseService {
  PurchaseService._();
  static final PurchaseService instance = PurchaseService._();

  // â”€â”€â”€ PRODUCT IDs â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  /// Replace these with your actual product IDs from the app store(s).
  static const String monthlyPlanId = 'wash_club_monthly';
  static const String yearlyPlanId = 'wash_club_yearly';
  static const Set<String> _productIds = {monthlyPlanId, yearlyPlanId};

  // â”€â”€â”€ STATE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isAvailable = false;
  bool _isPremium = false;
  List<ProductDetails> _products = [];

  bool get isAvailable => _isAvailable;
  bool get isPremium => _isPremium;
  List<ProductDetails> get products => _products;

  // â”€â”€â”€ CALLBACKS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  VoidCallback? onPurchaseSuccess;
  VoidCallback? onPurchaseError;

  // â”€â”€â”€ INIT â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) {
      debugPrint('[PurchaseService] Store not available.');
      return;
    }

    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdate,
      onError: (error) {
        debugPrint('[PurchaseService] Purchase stream error: $error');
      },
    );

    await _loadProducts();
    debugPrint('[PurchaseService] Initialized. Products: ${_products.length}');
  }

  Future<void> _loadProducts() async {
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_productIds);

    if (response.error != null) {
      debugPrint('[PurchaseService] Product query error: ${response.error}');
      return;
    }

    _products = response.productDetails;
    debugPrint('[PurchaseService] Loaded ${_products.length} product(s).');
  }

  // â”€â”€â”€ PURCHASE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  /// Call this when user taps "Subscribe". Pass the [ProductDetails] object.
  void buySubscription(ProductDetails product) {
    if (!_isAvailable) {
      debugPrint('[PurchaseService] Store not available, cannot purchase.');
      return;
    }
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Convenience method: buy by product ID string.
  void buyById(String productId) {
    final product = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product $productId not found'),
    );
    buySubscription(product);
  }

  // â”€â”€â”€ RESTORE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  // â”€â”€â”€ HANDLE UPDATES â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _verifyAndGrant(purchase);
          break;
        case PurchaseStatus.error:
          debugPrint(
              '[PurchaseService] Error: ${purchase.error?.message}');
          onPurchaseError?.call();
          break;
        case PurchaseStatus.canceled:
          debugPrint('[PurchaseService] Purchase canceled.');
          break;
        case PurchaseStatus.pending:
          debugPrint('[PurchaseService] Purchase pending...');
          break;
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  void _verifyAndGrant(PurchaseDetails purchase) {
    // In production: verify the receipt with your backend server.
    // For now, we trust the platform and grant access immediately.
    _isPremium = true;
    debugPrint('[PurchaseService] Purchase verified! Premium granted.');
    onPurchaseSuccess?.call();
  }

  // â”€â”€â”€ DISPOSE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void dispose() {
    _subscription?.cancel();
  }
}
