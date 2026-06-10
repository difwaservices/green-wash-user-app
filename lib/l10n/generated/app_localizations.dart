import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('mr'),
    Locale('pa'),
    Locale('ta'),
    Locale('te')
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Difwa Water'**
  String get appName;

  /// Onboarding screen 1 title
  ///
  /// In en, this message translates to:
  /// **'Pure Drinking Water\nAt Your Doorstep'**
  String get onboarding1Title;

  /// Onboarding screen 1 subtitle
  ///
  /// In en, this message translates to:
  /// **'Fresh and filtered water delivered right to\nyour home or office.'**
  String get onboarding1Subtitle;

  /// Onboarding screen 2 title
  ///
  /// In en, this message translates to:
  /// **'Safe and Hygienic\nPremium Quality'**
  String get onboarding2Title;

  /// Onboarding screen 2 subtitle
  ///
  /// In en, this message translates to:
  /// **'Our water undergoes strict filtration processes\nto ensure your health and safety.'**
  String get onboarding2Subtitle;

  /// Onboarding screen 3 title
  ///
  /// In en, this message translates to:
  /// **'Effortless Ordering\nIn Just a Tap'**
  String get onboarding3Title;

  /// Onboarding screen 3 subtitle
  ///
  /// In en, this message translates to:
  /// **'Quick and easy booking through the\nDifwa Water App.'**
  String get onboarding3Subtitle;

  /// Onboarding screen 4 title
  ///
  /// In en, this message translates to:
  /// **'Fast Delivery\nStay Hydrated'**
  String get onboarding4Title;

  /// Onboarding screen 4 subtitle
  ///
  /// In en, this message translates to:
  /// **'On-time delivery across the city\nto keep you and your family healthy.'**
  String get onboarding4Subtitle;

  /// Skip button label
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next button label
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Get started button label
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Login screen heading
  ///
  /// In en, this message translates to:
  /// **'Login with Mobile Number'**
  String get loginWithMobileNumber;

  /// Login screen subheading
  ///
  /// In en, this message translates to:
  /// **'Enter your 10-digit mobile number to receive an OTP.'**
  String get enterMobileDescription;

  /// Mobile number field label
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// Mobile number hint text
  ///
  /// In en, this message translates to:
  /// **'e.g. 9876543210'**
  String get mobileHint;

  /// Send OTP button label
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// Security reassurance text on login screen
  ///
  /// In en, this message translates to:
  /// **'Secure and Fast login with OTP'**
  String get secureLoginText;

  /// Validation error for empty mobile number
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile number.'**
  String get pleaseEnterMobileNumber;

  /// Validation error for invalid mobile number
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit mobile number.'**
  String get enterValidMobileNumber;

  /// Error when OTP sending fails
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP. Please try again.'**
  String get failedToSendOtp;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get anErrorOccurred;

  /// OTP verification screen title
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// OTP instruction prefix, followed by phone number
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP sent to'**
  String get enterOtpSentTo;

  /// Verify button label
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Resend OTP button label
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// Countdown timer for OTP resend
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(int seconds);

  /// Error for wrong OTP
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtp;

  /// Error for expired OTP
  ///
  /// In en, this message translates to:
  /// **'OTP has expired. Please request a new one.'**
  String get otpExpired;

  /// Bottom nav: Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav: Cart tab label
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// Bottom nav: Orders tab label
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// Bottom nav: Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Search bar placeholder
  ///
  /// In en, this message translates to:
  /// **'Search keywords..'**
  String get searchHint;

  /// Section heading: Categories
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Section heading: Featured Products
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get featuredProducts;

  /// Add to cart button label
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// Go to cart button label
  ///
  /// In en, this message translates to:
  /// **'Go to Cart'**
  String get goToCart;

  /// Welcome greeting
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// View all link label
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Empty state: no products
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// Empty state: no shops
  ///
  /// In en, this message translates to:
  /// **'No shops available'**
  String get noShopsAvailable;

  /// Cart screen title
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCart;

  /// Empty cart message
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// Empty cart sub-message
  ///
  /// In en, this message translates to:
  /// **'Add items to get started'**
  String get addItemsToStart;

  /// Shop now button
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shopNow;

  /// Order subtotal label
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Shipping charges label
  ///
  /// In en, this message translates to:
  /// **'Shipping Charges'**
  String get shippingCharges;

  /// Total amount label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Checkout button label
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// Remove item button
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Quantity label
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Shipping address screen title
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get shippingAddress;

  /// Save address checkbox label
  ///
  /// In en, this message translates to:
  /// **'Save this address'**
  String get saveThisAddress;

  /// Delivery address label
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// Add new address button
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// Select address prompt
  ///
  /// In en, this message translates to:
  /// **'Select Address'**
  String get selectAddress;

  /// Address input hint
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enterAddress;

  /// Pincode field label
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// City field label
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// State field label
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// Landmark field label
  ///
  /// In en, this message translates to:
  /// **'Landmark (Optional)'**
  String get landmark;

  /// Payment method screen title
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Make payment button
  ///
  /// In en, this message translates to:
  /// **'Make a Payment'**
  String get makePayment;

  /// Payment success message
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccessful;

  /// Payment failure message
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// Wallet balance label
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletBalance;

  /// Use wallet option label
  ///
  /// In en, this message translates to:
  /// **'Use Wallet'**
  String get useWallet;

  /// Cash on delivery payment option
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cod;

  /// Online payment option label
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get onlinePayment;

  /// Order success screen title
  ///
  /// In en, this message translates to:
  /// **'Order Success'**
  String get orderSuccess;

  /// Order success heading
  ///
  /// In en, this message translates to:
  /// **'Your order was\nsuccessful!'**
  String get orderSuccessTitle;

  /// Order success sub-message
  ///
  /// In en, this message translates to:
  /// **'You will get a response within\na few minutes.'**
  String get orderSuccessSubtitle;

  /// Track order button
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// My orders screen title
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// Order history screen title
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// Active orders screen title
  ///
  /// In en, this message translates to:
  /// **'Active Orders'**
  String get activeOrders;

  /// Order details screen title
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// Order status: placed
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get orderPlaced;

  /// Order status: confirmed
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed'**
  String get orderConfirmed;

  /// Order status: packed
  ///
  /// In en, this message translates to:
  /// **'Order Packed'**
  String get orderPacked;

  /// Order status: shipped
  ///
  /// In en, this message translates to:
  /// **'Order Shipped'**
  String get orderShipped;

  /// Order status: delivered
  ///
  /// In en, this message translates to:
  /// **'Order Delivered'**
  String get orderDelivered;

  /// Order status: cancelled
  ///
  /// In en, this message translates to:
  /// **'Order Cancelled'**
  String get orderCancelled;

  /// Empty orders state
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// CTA when no orders exist
  ///
  /// In en, this message translates to:
  /// **'Start shopping now'**
  String get startShoppingNow;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Edit profile screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Save changes button
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Logout button label
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Logout confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// Wallet screen title
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// Add money button
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get addMoney;

  /// Wallet statement screen title
  ///
  /// In en, this message translates to:
  /// **'Wallet Statement'**
  String get walletStatement;

  /// Top up button label
  ///
  /// In en, this message translates to:
  /// **'Top Up'**
  String get topUp;

  /// Balance label
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Transactions section title
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// Empty transactions state
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactions;

  /// Notifications screen title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Empty notifications state
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// Mark all notifications as read
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// Help and support screen title
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// About us screen title
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// Contact us screen title
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// FAQ screen title
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// Privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Terms and conditions link
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// Rider dashboard title
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get riderDashboard;

  /// Rider assigned orders section
  ///
  /// In en, this message translates to:
  /// **'Assigned Orders'**
  String get assignedOrders;

  /// Rider earnings section
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// Rider delivery history
  ///
  /// In en, this message translates to:
  /// **'Delivery History'**
  String get deliveryHistory;

  /// Rider available orders
  ///
  /// In en, this message translates to:
  /// **'Available Orders'**
  String get availableOrders;

  /// Accept order button
  ///
  /// In en, this message translates to:
  /// **'Accept Order'**
  String get acceptOrder;

  /// Reject order button
  ///
  /// In en, this message translates to:
  /// **'Reject Order'**
  String get rejectOrder;

  /// Start delivery button
  ///
  /// In en, this message translates to:
  /// **'Start Delivery'**
  String get startDelivery;

  /// Mark delivered button
  ///
  /// In en, this message translates to:
  /// **'Mark as Delivered'**
  String get markDelivered;

  /// Total earnings label
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// Today's earnings label
  ///
  /// In en, this message translates to:
  /// **'Today\'s Earnings'**
  String get todayEarnings;

  /// Subscription screen title
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// My subscription section title
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get mySubscription;

  /// Subscribe now button
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// Active plan label
  ///
  /// In en, this message translates to:
  /// **'Active Plan'**
  String get activePlan;

  /// Renew plan button
  ///
  /// In en, this message translates to:
  /// **'Renew Plan'**
  String get renewPlan;

  /// Cancel subscription button
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get cancelSubscription;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Submit button
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Yes option
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No option
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Search label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Filter button
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Sort button
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// More label (e.g. 'see more')
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get more;

  /// Reviews label
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// Rating label
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Price label
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Free label
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// Discount off label
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get off;

  /// Address type: Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeLabel;

  /// Address type: Office
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get office;

  /// Address type: Other
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Use current location button
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No internet error
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Generic error
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Try again button
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Session expired error
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again.'**
  String get sessionExpired;

  /// Location permission error
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// Enable location prompt
  ///
  /// In en, this message translates to:
  /// **'Please enable location services'**
  String get enableLocationServices;

  /// Language selection screen title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Language selection subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get chooseLanguage;

  /// Language change success toast
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// Language settings label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'bn',
        'en',
        'gu',
        'hi',
        'kn',
        'ml',
        'mr',
        'pa',
        'ta',
        'te'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
