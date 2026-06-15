// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appName => 'Difwa Water';

  @override
  String get onboarding1Title => 'ಶುದ್ಧ ಕುಡಿಯುವ ನೀರು\nನಿಮ್ಮ ಬಾಗಿಲಿಗೆ';

  @override
  String get onboarding1Subtitle =>
      'ತಾಜಾ ಮತ್ತು ಫಿಲ್ಟರ್ ಮಾಡಿದ ನೀರನ್ನು ನೇರವಾಗಿ\nನಿಮ್ಮ ಮನೆ ಅಥವಾ ಕಚೇರಿಗೆ ತಲುಪಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get onboarding2Title => 'ಸುರಕ್ಷಿತ & ನೈರ್ಮಲ್ಯ\nಪ್ರೀಮಿಯಂ ಗುಣಮಟ್ಟ';

  @override
  String get onboarding2Subtitle =>
      'ನಿಮ್ಮ ಆರೋಗ್ಯ ಮತ್ತು ಸುರಕ್ಷತೆಯನ್ನು ಖಚಿತಪಡಿಸಲು\nನಮ್ಮ ನೀರು ಕಠಿಣ ಶೋಧನಾ ಪ್ರಕ್ರಿಯೆಯ ಮೂಲಕ ಹಾದು ಹೋಗುತ್ತದೆ.';

  @override
  String get onboarding3Title => 'ಸುಲಭ ಆರ್ಡರ್\nಒಂದೇ ಟ್ಯಾಪ್‌ನಲ್ಲಿ';

  @override
  String get onboarding3Subtitle =>
      'Difwa Water App ಮೂಲಕ\nತ್ವರಿತ ಮತ್ತು ಸುಲಭ ಬುಕಿಂಗ್.';

  @override
  String get onboarding4Title => 'ವೇಗದ ಡೆಲಿವರಿ\nಹೈಡ್ರೇಟೆಡ್ ಆಗಿರಿ';

  @override
  String get onboarding4Subtitle =>
      'ನಗರದಾದ್ಯಂತ ಸಮಯಕ್ಕೆ ಡೆಲಿವರಿ\nನೀವು ಮತ್ತು ನಿಮ್ಮ ಕುಟುಂಬ ಆರೋಗ್ಯಕರವಾಗಿರಲು.';

  @override
  String get skip => 'ಬಿಟ್ಟುಬಿಡಿ';

  @override
  String get next => 'ಮುಂದೆ';

  @override
  String get getStarted => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get loginWithMobileNumber => 'ಮೊಬೈಲ್ ನಂಬರ್‌ನಲ್ಲಿ ಲಾಗಿನ್ ಮಾಡಿ';

  @override
  String get enterMobileDescription =>
      'OTP ಸ್ವೀಕರಿಸಲು 10 ಅಂಕಿಯ ಮೊಬೈಲ್ ನಂಬರ್ ನಮೂದಿಸಿ.';

  @override
  String get mobileNumber => 'ಮೊಬೈಲ್ ನಂಬರ್';

  @override
  String get mobileHint => 'ಉದಾ. 9876543210';

  @override
  String get sendOtp => 'OTP ಕಳುಹಿಸಿ';

  @override
  String get secureLoginText => 'OTP ಮೂಲಕ ಸುರಕ್ಷಿತ ಮತ್ತು ತ್ವರಿತ ಲಾಗಿನ್';

  @override
  String get pleaseEnterMobileNumber => 'ದಯವಿಟ್ಟು ನಿಮ್ಮ ಮೊಬೈಲ್ ನಂಬರ್ ನಮೂದಿಸಿ.';

  @override
  String get enterValidMobileNumber =>
      'ದಯವಿಟ್ಟು ಮಾನ್ಯವಾದ 10 ಅಂಕಿಯ ಮೊಬೈಲ್ ನಂಬರ್ ನಮೂದಿಸಿ.';

  @override
  String get failedToSendOtp => 'OTP ಕಳುಹಿಸಲು ವಿಫಲವಾಯಿತು. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get anErrorOccurred => 'ದೋಷ ಸಂಭವಿಸಿದೆ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get otpVerification => 'OTP ಪರಿಶೀಲನೆ';

  @override
  String get enterOtpSentTo => 'ಕಳುಹಿಸಿದ OTP ನಮೂದಿಸಿ';

  @override
  String get verify => 'ಪರಿಶೀಲಿಸಿ';

  @override
  String get resendOtp => 'OTP ಮತ್ತೆ ಕಳುಹಿಸಿ';

  @override
  String resendIn(int seconds) {
    return '${seconds}s ನಲ್ಲಿ ಮತ್ತೆ ಕಳುಹಿಸಿ';
  }

  @override
  String get invalidOtp => 'ಅಮಾನ್ಯ OTP. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get otpExpired => 'OTP ಮುಕ್ತಾಯವಾಗಿದೆ. ಹೊಸ OTP ವಿನಂತಿಸಿ.';

  @override
  String get navHome => 'ಮುಖಪುಟ';

  @override
  String get navCart => 'ಕಾರ್ಟ್';

  @override
  String get navOrders => 'ಆರ್ಡರ್‌ಗಳು';

  @override
  String get navProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get searchHint => 'ಕೀವರ್ಡ್‌ಗಳನ್ನು ಹುಡುಕಿ..';

  @override
  String get categories => 'ವರ್ಗಗಳು';

  @override
  String get featuredProducts => 'ವಿಶೇಷ ಉತ್ಪನ್ನಗಳು';

  @override
  String get addToCart => 'ಕಾರ್ಟ್‌ಗೆ ಸೇರಿಸಿ';

  @override
  String get goToCart => 'ಕಾರ್ಟ್‌ಗೆ ಹೋಗಿ';

  @override
  String get welcome => 'ಸ್ವಾಗತ';

  @override
  String get viewAll => 'ಎಲ್ಲಾ ನೋಡಿ';

  @override
  String get noProductsFound => 'ಉತ್ಪನ್ನಗಳು ಕಂಡುಬಂದಿಲ್ಲ';

  @override
  String get noShopsAvailable => 'ಅಂಗಡಿಗಳು ಲಭ್ಯವಿಲ್ಲ';

  @override
  String get shoppingCart => 'ಶಾಪಿಂಗ್ ಕಾರ್ಟ್';

  @override
  String get emptyCart => 'ನಿಮ್ಮ ಕಾರ್ಟ್ ಖಾಲಿಯಾಗಿದೆ';

  @override
  String get addItemsToStart => 'ಪ್ರಾರಂಭಿಸಲು ವಸ್ತುಗಳನ್ನು ಸೇರಿಸಿ';

  @override
  String get shopNow => 'ಈಗ ಖರೀದಿಸಿ';

  @override
  String get subtotal => 'ಉಪ ಮೊತ್ತ';

  @override
  String get shippingCharges => 'ಶಿಪ್ಪಿಂಗ್ ಶುಲ್ಕ';

  @override
  String get total => 'ಒಟ್ಟು';

  @override
  String get checkout => 'ಚೆಕ್‌ಔಟ್';

  @override
  String get remove => 'ತೆಗೆದುಹಾಕಿ';

  @override
  String get quantity => 'ಪ್ರಮಾಣ';

  @override
  String get shippingAddress => 'ಶಿಪ್ಪಿಂಗ್ ವಿಳಾಸ';

  @override
  String get saveThisAddress => 'ಈ ವಿಳಾಸ ಉಳಿಸಿ';

  @override
  String get deliveryAddress => 'ಡೆಲಿವರಿ ವಿಳಾಸ';

  @override
  String get addNewAddress => 'ಹೊಸ ವಿಳಾಸ ಸೇರಿಸಿ';

  @override
  String get selectAddress => 'ವಿಳಾಸ ಆಯ್ಕೆ ಮಾಡಿ';

  @override
  String get enterAddress => 'ವಿಳಾಸ ನಮೂದಿಸಿ';

  @override
  String get pincode => 'ಪಿನ್‌ಕೋಡ್';

  @override
  String get city => 'ನಗರ';

  @override
  String get state => 'ರಾಜ್ಯ';

  @override
  String get landmark => 'ಗುರುತಿನ ಸ್ಥಳ (ಐಚ್ಛಿಕ)';

  @override
  String get paymentMethod => 'ಪಾವತಿ ವಿಧಾನ';

  @override
  String get makePayment => 'ಪಾವತಿ ಮಾಡಿ';

  @override
  String get paymentSuccessful => 'ಪಾವತಿ ಯಶಸ್ವಿ';

  @override
  String get paymentFailed => 'ಪಾವತಿ ವಿಫಲ';

  @override
  String get walletBalance => 'ವಾಲೆಟ್ ಬ್ಯಾಲೆನ್ಸ್';

  @override
  String get useWallet => 'ವಾಲೆಟ್ ಬಳಸಿ';

  @override
  String get cod => 'ಕ್ಯಾಶ್ ಆನ್ ಡೆಲಿವರಿ';

  @override
  String get onlinePayment => 'ಆನ್‌ಲೈನ್ ಪಾವತಿ';

  @override
  String get orderSuccess => 'ಆರ್ಡರ್ ಯಶಸ್ವಿ';

  @override
  String get orderSuccessTitle => 'ನಿಮ್ಮ ಆರ್ಡರ್\nಯಶಸ್ವಿಯಾಗಿ ಆಯಿತು!';

  @override
  String get orderSuccessSubtitle =>
      'ಕೆಲವು ನಿಮಿಷಗಳಲ್ಲಿ\nನೀವು ಪ್ರತಿಕ್ರಿಯೆ ಪಡೆಯುವಿರಿ.';

  @override
  String get trackOrder => 'ಆರ್ಡರ್ ಟ್ರ್ಯಾಕ್ ಮಾಡಿ';

  @override
  String get myOrders => 'ನನ್ನ ಆರ್ಡರ್‌ಗಳು';

  @override
  String get orderHistory => 'ಆರ್ಡರ್ ಇತಿಹಾಸ';

  @override
  String get activeOrders => 'ಸಕ್ರಿಯ ಆರ್ಡರ್‌ಗಳು';

  @override
  String get orderDetails => 'ಆರ್ಡರ್ ವಿವರ';

  @override
  String get orderPlaced => 'ಆರ್ಡರ್ ಮಾಡಲಾಗಿದೆ';

  @override
  String get orderConfirmed => 'ಆರ್ಡರ್ ದೃಢಪಡಿಸಲಾಗಿದೆ';

  @override
  String get orderPacked => 'ಆರ್ಡರ್ ಪ್ಯಾಕ್ ಮಾಡಲಾಗಿದೆ';

  @override
  String get orderShipped => 'ಆರ್ಡರ್ ಕಳುಹಿಸಲಾಗಿದೆ';

  @override
  String get orderDelivered => 'ಆರ್ಡರ್ ತಲುಪಿದೆ';

  @override
  String get orderCancelled => 'ಆರ್ಡರ್ ರದ್ದು';

  @override
  String get noOrdersYet => 'ಇನ್ನೂ ಆರ್ಡರ್‌ಗಳಿಲ್ಲ';

  @override
  String get startShoppingNow => 'ಈಗ ಶಾಪಿಂಗ್ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get profile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get editProfile => 'ಪ್ರೊಫೈಲ್ ಸಂಪಾದಿಸಿ';

  @override
  String get fullName => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get email => 'ಇಮೇಲ್';

  @override
  String get phoneNumber => 'ಫೋನ್ ನಂಬರ್';

  @override
  String get saveChanges => 'ಬದಲಾವಣೆಗಳನ್ನು ಉಳಿಸಿ';

  @override
  String get logout => 'ಲಾಗ್‌ಔಟ್';

  @override
  String get logoutConfirm => 'ನೀವು ನಿಜವಾಗಿಯೂ ಲಾಗ್‌ಔಟ್ ಮಾಡಲು ಬಯಸುತ್ತೀರಾ?';

  @override
  String get wallet => 'ವಾಲೆಟ್';

  @override
  String get addMoney => 'ಹಣ ಸೇರಿಸಿ';

  @override
  String get walletStatement => 'ವಾಲೆಟ್ ಸ್ಟೇಟ್‌ಮೆಂಟ್';

  @override
  String get topUp => 'ಟಾಪ್ ಅಪ್';

  @override
  String get balance => 'ಬ್ಯಾಲೆನ್ಸ್';

  @override
  String get transactions => 'ವ್ಯವಹಾರಗಳು';

  @override
  String get noTransactions => 'ಇನ್ನೂ ವ್ಯವಹಾರಗಳಿಲ್ಲ';

  @override
  String get notifications => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get noNotifications => 'ಅಧಿಸೂಚನೆಗಳಿಲ್ಲ';

  @override
  String get markAllRead => 'ಎಲ್ಲವನ್ನೂ ಓದಿದ್ದಾಗಿ ಗುರುತಿಸಿ';

  @override
  String get helpSupport => 'ಸಹಾಯ & ಬೆಂಬಲ';

  @override
  String get aboutUs => 'ನಮ್ಮ ಬಗ್ಗೆ';

  @override
  String get contactUs => 'ಸಂಪರ್ಕಿಸಿ';

  @override
  String get faq => 'ಪದೇ ಪದೇ ಕೇಳಲಾಗುವ ಪ್ರಶ್ನೆಗಳು';

  @override
  String get privacyPolicy => 'ಗೌಪ್ಯತಾ ನೀತಿ';

  @override
  String get termsConditions => 'ನಿಯಮಗಳು & ಷರತ್ತುಗಳು';

  @override
  String get riderDashboard => 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್';

  @override
  String get assignedOrders => 'ನಿಯೋಜಿತ ಆರ್ಡರ್‌ಗಳು';

  @override
  String get earnings => 'ಗಳಿಕೆ';

  @override
  String get deliveryHistory => 'ಡೆಲಿವರಿ ಇತಿಹಾಸ';

  @override
  String get availableOrders => 'ಲಭ್ಯ ಆರ್ಡರ್‌ಗಳು';

  @override
  String get acceptOrder => 'ಆರ್ಡರ್ ಸ್ವೀಕರಿಸಿ';

  @override
  String get rejectOrder => 'ಆರ್ಡರ್ ತಿರಸ್ಕರಿಸಿ';

  @override
  String get startDelivery => 'ಡೆಲಿವರಿ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get markDelivered => 'ತಲುಪಿಸಿದ್ದಾಗಿ ಗುರುತಿಸಿ';

  @override
  String get totalEarnings => 'ಒಟ್ಟು ಗಳಿಕೆ';

  @override
  String get todayEarnings => 'ಇಂದಿನ ಗಳಿಕೆ';

  @override
  String get subscription => 'ಚಂದಾದಾರಿಕೆ';

  @override
  String get mySubscription => 'ನನ್ನ ಚಂದಾದಾರಿಕೆ';

  @override
  String get subscribeNow => 'ಈಗ ಚಂದಾದಾರರಾಗಿ';

  @override
  String get activePlan => 'ಸಕ್ರಿಯ ಯೋಜನೆ';

  @override
  String get renewPlan => 'ಯೋಜನೆ ನವೀಕರಿಸಿ';

  @override
  String get cancelSubscription => 'ಚಂದಾದಾರಿಕೆ ರದ್ದು ಮಾಡಿ';

  @override
  String get ok => 'ಸರಿ';

  @override
  String get cancel => 'ರದ್ದು ಮಾಡಿ';

  @override
  String get save => 'ಉಳಿಸಿ';

  @override
  String get delete => 'ಅಳಿಸಿ';

  @override
  String get back => 'ಹಿಂದೆ';

  @override
  String get loading => 'ಲೋಡ್ ಆಗುತ್ತಿದೆ...';

  @override
  String get retry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get submit => 'ಸಲ್ಲಿಸಿ';

  @override
  String get confirm => 'ದೃಢಪಡಿಸಿ';

  @override
  String get yes => 'ಹೌದು';

  @override
  String get no => 'ಇಲ್ಲ';

  @override
  String get close => 'ಮುಚ್ಚಿ';

  @override
  String get done => 'ಮುಗಿದಿದೆ';

  @override
  String get search => 'ಹುಡುಕಿ';

  @override
  String get filter => 'ಫಿಲ್ಟರ್';

  @override
  String get sort => 'ವರ್ಗೀಕರಿಸಿ';

  @override
  String get more => 'ಇನ್ನಷ್ಟು';

  @override
  String get reviews => 'ವಿಮರ್ಶೆಗಳು';

  @override
  String get rating => 'ರೇಟಿಂಗ್';

  @override
  String get price => 'ಬೆಲೆ';

  @override
  String get free => 'ಉಚಿತ';

  @override
  String get off => 'ರಿಯಾಯಿತಿ';

  @override
  String get homeLabel => 'ಮನೆ';

  @override
  String get office => 'ಕಚೇರಿ';

  @override
  String get other => 'ಇತರೆ';

  @override
  String get currentLocation => 'ಪ್ರಸ್ತುತ ಸ್ಥಳ';

  @override
  String get noInternetConnection => 'ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕ ಇಲ್ಲ';

  @override
  String get somethingWentWrong => 'ಏನೋ ತಪ್ಪಾಗಿದೆ';

  @override
  String get tryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get sessionExpired => 'ಸೆಶನ್ ಅವಧಿ ಮುಗಿದಿದೆ. ಮತ್ತೆ ಲಾಗಿನ್ ಮಾಡಿ.';

  @override
  String get locationPermissionDenied => 'ಸ್ಥಳ ಅನುಮತಿ ನಿರಾಕರಿಸಲಾಗಿದೆ';

  @override
  String get enableLocationServices => 'ಸ್ಥಳ ಸೇವೆಗಳನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಿ';

  @override
  String get selectLanguage => 'ಭಾಷೆ ಆಯ್ಕೆ ಮಾಡಿ';

  @override
  String get chooseLanguage => 'ನಿಮ್ಮ ಆದ್ಯತೆಯ ಭಾಷೆ ಆಯ್ಕೆ ಮಾಡಿ';

  @override
  String get languageChanged => 'ಭಾಷೆ ಯಶಸ್ವಿಯಾಗಿ ಬದಲಾಗಿದೆ';

  @override
  String get language => 'ಭಾಷೆ';
}
