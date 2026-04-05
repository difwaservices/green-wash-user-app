import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/food_models.dart';
import 'cart_service.dart';
import 'wallet_service.dart';
import 'address_service.dart';
import 'shop_service.dart';
import 'order_service.dart';
import '../network/api_client.dart';
import '../../core/constants/app_images.dart';

class CartProvider extends ChangeNotifier {
  final CartService? _service;
  final WalletService? _walletService;
  final AddressService? _addressService;
  final ShopService? _shopService;
  final OrderService? _orderService;
  final List<CartItem> _items = [];

  CartProvider({
    CartService? service,
    WalletService? walletService,
    AddressService? addressService,
    ShopService? shopService,
    OrderService? orderService,
  })  : _service = service,
        _walletService = walletService,
        _addressService = addressService,
        _shopService = shopService,
        _orderService = orderService {
    loadCategories();
    loadAddresses();
    syncWallet();
    loadShops();
  }

  // ── Getters ───────────────────────────────────────────────────────────────
  AddressService? get addressService => _addressService;
  List<CartItem> get items => _items;
  UserProfile get userProfile => _userProfile;
  List<FoodCategory> get foodCategories => _foodCategories;
  List<Restaurant> get restaurants => _restaurants;
  List<UserOrder> get orders => _orders;
  List<UserAddress> get addresses => _addresses;

  List<UserPaymentMethod> get payments => _payments;

  UserProfile _userProfile = const UserProfile(
    name: 'Guest User',
    email: '',
    phone: '',
    profileImage: AppImages.defaultAvatar,
  );

  bool get isLoggedIn => _userProfile.email.isNotEmpty;

  List<FoodCategory> _foodCategories = [];
  final List<Restaurant> _restaurants = [];

  List<UserOrder> _orders = [];
  bool _isOrdersLoading = false;

  bool get isOrdersLoading => _isOrdersLoading;

  void setOrders(List<UserOrder> newOrders) {
    _orders = newOrders;
    notifyListeners();
  }

  void setLoadingOrders(bool loading) {
    _isOrdersLoading = loading;
    notifyListeners();
  }

  double _walletBalance = 0.0;
  List<dynamic> _transactions = [];

  double get walletBalance => _walletBalance;
  List<dynamic> get transactions => _transactions;

  Future<void> syncWallet() async {
    if (_walletService == null) return;
    try {
      final result = await _walletService!.getBalance();
      if (result['success']) {
        _walletBalance = (result['balance'] as num).toDouble();
        notifyListeners();
      }
      _transactions = await _walletService!.getTransactionHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('CartProvider: Error syncing wallet: $e');
    }
  }

  List<UserAddress> _addresses = [];
  bool _isAddressesLoading = false;
  int _selectedAddressIndex = 0;

  bool get isAddressesLoading => _isAddressesLoading;
  int get selectedAddressIndex => _selectedAddressIndex;

  void selectAddress(int index) {
    _selectedAddressIndex = index;
    notifyListeners();
  }

  UserAddress? get selectedAddress {
    if (_addresses.isEmpty) return null;
    if (_selectedAddressIndex >= 0 &&
        _selectedAddressIndex < _addresses.length) {
      return _addresses[_selectedAddressIndex];
    }
    return _addresses.firstWhere((a) => a.isDefault,
        orElse: () => _addresses.first);
  }

  final List<UserPaymentMethod> _payments = [];

  void updateUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void clearSession() {
    _userProfile = const UserProfile(
      name: 'Guest User',
      email: '',
      phone: '',
      profileImage: AppImages.defaultAvatar,
    );
    _items.clear();
    _favoriteIds.clear();
    _addresses.clear();
    _orders.clear();
    _transactions.clear();
    _walletBalance = 0.0;
    _selectedAddressIndex = 0;
    notifyListeners();
  }

  // ── API Integration ───────────────────────────────────────────────────────
  Future<void> loadCategories() async {
    if (_shopService == null) return;
    try {
      _foodCategories = await _shopService!.getCategories();
      notifyListeners();
    } catch (e) {
      debugPrint('CartProvider: Error loading categories: $e');
    }
  }

  Future<void> loadShops() async {
    if (_shopService == null) return;
    try {
      final shops = await _shopService!.getShops();
      _restaurants.clear();
      // Map ShopModel to Restaurant model used in Home UI
      for (var s in shops) {
        _restaurants.add(Restaurant(
          id: s.id,
          name: s.name,
          image: s.image,
          rating: s.rating,
          deliveryTime: s.deliveryTime,
          discount: 'Free Delivery',
          minOrder: '₹0 min',
        ));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('CartProvider: Error loading shops: $e');
    }
  }

  Future<void> loadCartFromApi() async {
    if (_service == null) return;
    try {
      final remoteItems = await _service!.getCart();
      _items.clear();
      _items.addAll(remoteItems);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cart from API: $e');
    }
  }

  final List<String> _favoriteIds = [];

  List<Restaurant> get favRestaurants {
    if (_restaurants.isEmpty) return [];
    return _favoriteIds
        .map((id) => _restaurants.firstWhere((r) => r.id == id,
            orElse: () => _restaurants.first))
        .toList();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  void reorderFavorites(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final String item = _favoriteIds.removeAt(oldIndex);
    _favoriteIds.insert(newIndex, item);
    notifyListeners();
  }

  void addAddress(UserAddress address) async {
    if (_addressService != null) {
      final addressParts = address.details.split(',');
      final cityName =
          addressParts.isNotEmpty ? addressParts.first.trim() : 'City';
      try {
        final result = await _addressService!.saveAddress(
          fullName: address.fullName,
          email: address.email,
          label: address.title,
          fullAddress: address.street,
          city: cityName,
          state: address.details.contains(',')
              ? address.details.split(',')[1].trim()
              : '',
          pincode: address.details.split(' ').last,
          isDefault: address.isDefault,
        );
        if (result['success']) {
          loadAddresses();
        }
      } catch (e) {
        debugPrint('CartProvider: Error adding address: $e');
        // Prevent unhandled exception from crashing the app
      }
    } else {
      if (address.isDefault) {
        for (int i = 0; i < _addresses.length; i++) {
          _addresses[i] = UserAddress(
            id: _addresses[i].id,
            title: _addresses[i].title,
            street: _addresses[i].street,
            details: _addresses[i].details,
            isDefault: false,
          );
        }
      }
      _addresses.add(address);
      notifyListeners();
    }
  }

  Future<void> loadAddresses() async {
    if (_addressService == null) return;
    _isAddressesLoading = true;
    notifyListeners();

    try {
      final token = await ApiClient.getToken();
      if (token == null || token.isEmpty) {
        _isAddressesLoading = false;
        notifyListeners();
        return;
      }

      final result = await _addressService!.getAddresses();
      if (result['success']) {
        final List<dynamic> data = result['data'] ?? [];
        _addresses = data
            .map((json) => UserAddress(
                  id: json['_id'] ?? '',
                  title: json['label'] ?? 'Address',
                  street: json['fullAddress'] ?? '',
                  details:
                      '${json['city'] ?? ''}, ${json['state'] ?? ''} ${json['pincode'] ?? ''}',
                  fullName: json['fullName'] ?? '',
                  email: json['email'] ?? '',
                  isDefault: json['isDefault'] ?? false,
                ))
            .toList();

        final defaultIdx = _addresses.indexWhere((a) => a.isDefault);
        if (defaultIdx != -1) {
          _selectedAddressIndex = defaultIdx;
        } else if (_addresses.isNotEmpty) {
          _selectedAddressIndex = 0;
        }
      }
    } catch (e) {
      debugPrint('Error loading addresses: $e');
    } finally {
      _isAddressesLoading = false;
      notifyListeners();
    }
  }

  void updateAddress(UserAddress address) {
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      if (address.isDefault) {
        for (int i = 0; i < _addresses.length; i++) {
          _addresses[i] = UserAddress(
            id: _addresses[i].id,
            title: _addresses[i].title,
            street: _addresses[i].street,
            details: _addresses[i].details,
            isDefault: false,
          );
        }
      }
      _addresses[index] = address;
      notifyListeners();
    }
  }

  void removeAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get shippingCharges => _items.isEmpty ? 0.0 : 1.6;
  double get total => subtotal + shippingCharges;

  bool isInCart(String title) {
    return _items.any((item) => item.title == title);
  }

  String? get cartShopId => _items.isEmpty ? null : _items.first.shopId;
  String? get cartShopName => _items.isEmpty ? null : _items.first.shopName;

  bool isSameShop(String? shopId) {
    if (_items.isEmpty) return true;
    if (shopId == null) return true;
    return cartShopId == shopId;
  }

  void addToCart(CartItem cartItem) {
    final idx = _items.indexWhere((item) => item.title == cartItem.title);
    if (idx >= 0) {
      _items[idx].quantity += cartItem.quantity;
      if (_service != null) {
        _service!.updateQuantity(_items[idx].id, _items[idx].quantity);
      }
    } else {
      _items.add(cartItem);
      if (_service != null) {
        _service!.addToCart(cartItem.id, cartItem.quantity);
      }
    }
    notifyListeners();
  }

  void increment(String title) {
    final idx = _items.indexWhere((item) => item.title == title);
    if (idx >= 0) {
      _items[idx].quantity++;
      if (_service != null) {
        _service!.updateQuantity(_items[idx].id, _items[idx].quantity);
      }
      notifyListeners();
    }
  }

  void decrement(String title) {
    final idx = _items.indexWhere((item) => item.title == title);
    if (idx >= 0) {
      final itemId = _items[idx].id;
      if (_items[idx].quantity > 1) {
        _items[idx].quantity--;
        if (_service != null) {
          _service!.updateQuantity(itemId, _items[idx].quantity);
        }
      } else {
        _items.removeAt(idx);
        if (_service != null) {
          _service!.removeFromCart(itemId);
        }
      }
      notifyListeners();
    }
  }

  void removeItem(String title) {
    _items.removeWhere((item) => item.title == title);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    if (_service != null) {
      _service!.clearCart();
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> checkout(
      {String paymentMethod = 'Wallet'}) async {
    if (_orderService == null)
      return {'success': false, 'message': 'Order service not available'};
    if (selectedAddress == null)
      return {'success': false, 'message': 'Please select a delivery address'};

    final addr = selectedAddress!;
    // Parse address details back to parts for the API
    final detailsParts = addr.details.split(',');
    final city = detailsParts.isNotEmpty ? detailsParts[0].trim() : '';
    final statePin = detailsParts.length > 1 ? detailsParts[1].trim() : '';
    final pin = statePin.contains(' ') ? statePin.split(' ').last : '';
    final state = statePin.contains(' ')
        ? statePin.substring(0, statePin.lastIndexOf(' ')).trim()
        : statePin;

    final deliveryAddress = {
      'address': addr.street,
      'city': city,
      'state': state,
      'pincode': pin,
    };

    final result = await _orderService!.placeOrder(
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
    );

    if (result['success']) {
      _items.clear();
      notifyListeners();
      // Update wallet balance after purchase
      syncWallet();
    }
    return result;
  }
}

class CartProviderScope extends InheritedNotifier<CartProvider> {
  const CartProviderScope({
    super.key,
    required CartProvider provider,
    required super.child,
  }) : super(notifier: provider);

  static CartProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CartProviderScope>()!
        .notifier!;
  }
}
