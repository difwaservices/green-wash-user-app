// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Difwa Water';

  @override
  String get onboarding1Title => 'Pure Drinking Water\nAt Your Doorstep';

  @override
  String get onboarding1Subtitle =>
      'Fresh and filtered water delivered right to\nyour home or office.';

  @override
  String get onboarding2Title => 'Safe and Hygienic\nPremium Quality';

  @override
  String get onboarding2Subtitle =>
      'Our water undergoes strict filtration processes\nto ensure your health and safety.';

  @override
  String get onboarding3Title => 'Effortless Ordering\nIn Just a Tap';

  @override
  String get onboarding3Subtitle =>
      'Quick and easy booking through the\nDifwa Water App.';

  @override
  String get onboarding4Title => 'Fast Delivery\nStay Hydrated';

  @override
  String get onboarding4Subtitle =>
      'On-time delivery across the city\nto keep you and your family healthy.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get loginWithMobileNumber => 'Login with Mobile Number';

  @override
  String get enterMobileDescription =>
      'Enter your 10-digit mobile number to receive an OTP.';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get mobileHint => 'e.g. 9876543210';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get secureLoginText => 'Secure and Fast login with OTP';

  @override
  String get pleaseEnterMobileNumber => 'Please enter your mobile number.';

  @override
  String get enterValidMobileNumber =>
      'Please enter a valid 10-digit mobile number.';

  @override
  String get failedToSendOtp => 'Failed to send OTP. Please try again.';

  @override
  String get anErrorOccurred => 'An error occurred. Please try again.';

  @override
  String get otpVerification => 'OTP Verification';

  @override
  String get enterOtpSentTo => 'Enter the OTP sent to';

  @override
  String get verify => 'Verify';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String resendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get invalidOtp => 'Invalid OTP. Please try again.';

  @override
  String get otpExpired => 'OTP has expired. Please request a new one.';

  @override
  String get navHome => 'Home';

  @override
  String get navCart => 'Cart';

  @override
  String get navOrders => 'Orders';

  @override
  String get navProfile => 'Profile';

  @override
  String get searchHint => 'Search keywords..';

  @override
  String get categories => 'Categories';

  @override
  String get featuredProducts => 'Featured Products';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get goToCart => 'Go to Cart';

  @override
  String get welcome => 'Welcome';

  @override
  String get viewAll => 'View All';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get noShopsAvailable => 'No shops available';

  @override
  String get shoppingCart => 'Shopping Cart';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get addItemsToStart => 'Add items to get started';

  @override
  String get shopNow => 'Shop Now';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shippingCharges => 'Shipping Charges';

  @override
  String get total => 'Total';

  @override
  String get checkout => 'Checkout';

  @override
  String get remove => 'Remove';

  @override
  String get quantity => 'Quantity';

  @override
  String get shippingAddress => 'Shipping Address';

  @override
  String get saveThisAddress => 'Save this address';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get addNewAddress => 'Add New Address';

  @override
  String get selectAddress => 'Select Address';

  @override
  String get enterAddress => 'Enter address';

  @override
  String get pincode => 'Pincode';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get landmark => 'Landmark (Optional)';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get makePayment => 'Make a Payment';

  @override
  String get paymentSuccessful => 'Payment Successful';

  @override
  String get paymentFailed => 'Payment Failed';

  @override
  String get walletBalance => 'Wallet Balance';

  @override
  String get useWallet => 'Use Wallet';

  @override
  String get cod => 'Cash on Delivery';

  @override
  String get onlinePayment => 'Online Payment';

  @override
  String get orderSuccess => 'Order Success';

  @override
  String get orderSuccessTitle => 'Your order was\nsuccessful!';

  @override
  String get orderSuccessSubtitle =>
      'You will get a response within\na few minutes.';

  @override
  String get trackOrder => 'Track Order';

  @override
  String get myOrders => 'My Orders';

  @override
  String get orderHistory => 'Order History';

  @override
  String get activeOrders => 'Active Orders';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get orderPlaced => 'Order Placed';

  @override
  String get orderConfirmed => 'Order Confirmed';

  @override
  String get orderPacked => 'Order Packed';

  @override
  String get orderShipped => 'Order Shipped';

  @override
  String get orderDelivered => 'Order Delivered';

  @override
  String get orderCancelled => 'Order Cancelled';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get startShoppingNow => 'Start shopping now';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get wallet => 'Wallet';

  @override
  String get addMoney => 'Add Money';

  @override
  String get walletStatement => 'Wallet Statement';

  @override
  String get topUp => 'Top Up';

  @override
  String get balance => 'Balance';

  @override
  String get transactions => 'Transactions';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get aboutUs => 'About Us';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get faq => 'FAQ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get riderDashboard => 'Dashboard';

  @override
  String get assignedOrders => 'Assigned Orders';

  @override
  String get earnings => 'Earnings';

  @override
  String get deliveryHistory => 'Delivery History';

  @override
  String get availableOrders => 'Available Orders';

  @override
  String get acceptOrder => 'Accept Order';

  @override
  String get rejectOrder => 'Reject Order';

  @override
  String get startDelivery => 'Start Delivery';

  @override
  String get markDelivered => 'Mark as Delivered';

  @override
  String get totalEarnings => 'Total Earnings';

  @override
  String get todayEarnings => 'Today\'s Earnings';

  @override
  String get subscription => 'Subscription';

  @override
  String get mySubscription => 'My Subscription';

  @override
  String get subscribeNow => 'Subscribe Now';

  @override
  String get activePlan => 'Active Plan';

  @override
  String get renewPlan => 'Renew Plan';

  @override
  String get cancelSubscription => 'Cancel Subscription';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get back => 'Back';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get submit => 'Submit';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get more => 'more';

  @override
  String get reviews => 'reviews';

  @override
  String get rating => 'Rating';

  @override
  String get price => 'Price';

  @override
  String get free => 'Free';

  @override
  String get off => 'off';

  @override
  String get homeLabel => 'Home';

  @override
  String get office => 'Office';

  @override
  String get other => 'Other';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgain => 'Try again';

  @override
  String get sessionExpired => 'Session expired. Please login again.';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get enableLocationServices => 'Please enable location services';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get chooseLanguage => 'Choose your preferred language';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get language => 'Language';
}
