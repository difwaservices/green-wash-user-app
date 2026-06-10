// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'Difwa Water';

  @override
  String get onboarding1Title => 'தூய குடிநீர்\nஉங்கள் வாசலில்';

  @override
  String get onboarding1Subtitle =>
      'புதிய மற்றும் வடிகட்டிய நீர் நேரடியாக\nஉங்கள் வீடு அல்லது அலுவலகத்திற்கு டெலிவரி செய்யப்படுகிறது.';

  @override
  String get onboarding2Title => 'பாதுகாப்பான & சுகாதாரமான\nதரமான தண்ணீர்';

  @override
  String get onboarding2Subtitle =>
      'உங்கள் ஆரோக்கியம் மற்றும் பாதுகாப்பை உறுதி செய்ய\nகடுமையான வடிகட்டல் செயல்முறையில் நீர் சுத்திகரிக்கப்படுகிறது.';

  @override
  String get onboarding3Title => 'எளிதான ஆர்டர்\nஒரே டேப்பில்';

  @override
  String get onboarding3Subtitle =>
      'Difwa Water App மூலம்\nவேகமான மற்றும் எளிதான புக்கிங்.';

  @override
  String get onboarding4Title => 'விரைவான டெலிவரி\nஆரோக்கியமாக இருங்கள்';

  @override
  String get onboarding4Subtitle =>
      'நகரம் முழுவதும் சரியான நேரத்தில் டெலிவரி\nநீங்களும் உங்கள் குடும்பமும் ஆரோக்கியமாக இருக்க.';

  @override
  String get skip => 'தவிர்';

  @override
  String get next => 'அடுத்து';

  @override
  String get getStarted => 'தொடங்கு';

  @override
  String get loginWithMobileNumber => 'மொபைல் எண்ணில் உள்நுழைக';

  @override
  String get enterMobileDescription =>
      'OTP பெற 10 இலக்க மொபைல் எண்ணை உள்ளிடவும்.';

  @override
  String get mobileNumber => 'மொபைல் எண்';

  @override
  String get mobileHint => 'எ.கா. 9876543210';

  @override
  String get sendOtp => 'OTP அனுப்பு';

  @override
  String get secureLoginText =>
      'OTP மூலம் பாதுகாப்பான மற்றும் வேகமான உள்நுழைவு';

  @override
  String get pleaseEnterMobileNumber => 'உங்கள் மொபைல் எண்ணை உள்ளிடவும்.';

  @override
  String get enterValidMobileNumber =>
      'சரியான 10 இலக்க மொபைல் எண்ணை உள்ளிடவும்.';

  @override
  String get failedToSendOtp =>
      'OTP அனுப்புவதில் தோல்வி. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get anErrorOccurred => 'பிழை ஏற்பட்டது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get otpVerification => 'OTP சரிபார்ப்பு';

  @override
  String get enterOtpSentTo => 'அனுப்பப்பட்ட OTP ஐ உள்ளிடவும்';

  @override
  String get verify => 'சரிபார்க்கவும்';

  @override
  String get resendOtp => 'OTP மீண்டும் அனுப்பு';

  @override
  String resendIn(int seconds) {
    return '${seconds}s இல் மீண்டும் அனுப்பு';
  }

  @override
  String get invalidOtp => 'தவறான OTP. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get otpExpired => 'OTP காலாவதியானது. புதிய OTP கோரவும்.';

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navCart => 'கார்ட்';

  @override
  String get navOrders => 'ஆர்டர்கள்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get searchHint => 'முக்கிய வார்த்தைகளை தேடுங்கள்..';

  @override
  String get categories => 'வகைகள்';

  @override
  String get featuredProducts => 'சிறப்பு பொருட்கள்';

  @override
  String get addToCart => 'கார்ட்டில் சேர்';

  @override
  String get goToCart => 'கார்ட்டிற்கு செல்';

  @override
  String get welcome => 'வரவேற்கிறோம்';

  @override
  String get viewAll => 'அனைத்தையும் பார்';

  @override
  String get noProductsFound => 'பொருட்கள் கிடைக்கவில்லை';

  @override
  String get noShopsAvailable => 'கடைகள் கிடைக்கவில்லை';

  @override
  String get shoppingCart => 'ஷாப்பிங் கார்ட்';

  @override
  String get emptyCart => 'உங்கள் கார்ட் காலியாக உள்ளது';

  @override
  String get addItemsToStart => 'தொடங்க பொருட்களை சேர்க்கவும்';

  @override
  String get shopNow => 'இப்போதே வாங்கு';

  @override
  String get subtotal => 'துணை மொத்தம்';

  @override
  String get shippingCharges => 'ஷிப்பிங் கட்டணம்';

  @override
  String get total => 'மொத்தம்';

  @override
  String get checkout => 'செக்அவுட்';

  @override
  String get remove => 'அகற்று';

  @override
  String get quantity => 'அளவு';

  @override
  String get shippingAddress => 'ஷிப்பிங் முகவரி';

  @override
  String get saveThisAddress => 'இந்த முகவரியை சேமி';

  @override
  String get deliveryAddress => 'டெலிவரி முகவரி';

  @override
  String get addNewAddress => 'புதிய முகவரி சேர்க்கவும்';

  @override
  String get selectAddress => 'முகவரியை தேர்ந்தெடுக்கவும்';

  @override
  String get enterAddress => 'முகவரியை உள்ளிடவும்';

  @override
  String get pincode => 'பின்கோட்';

  @override
  String get city => 'நகரம்';

  @override
  String get state => 'மாநிலம்';

  @override
  String get landmark => 'அடையாளம் (விருப்பமானது)';

  @override
  String get paymentMethod => 'கட்டண முறை';

  @override
  String get makePayment => 'கட்டணம் செலுத்தவும்';

  @override
  String get paymentSuccessful => 'கட்டணம் வெற்றிகரமாக';

  @override
  String get paymentFailed => 'கட்டணம் தோல்வி';

  @override
  String get walletBalance => 'வாலட் இருப்பு';

  @override
  String get useWallet => 'வாலட் பயன்படுத்து';

  @override
  String get cod => 'நேரடி பண வழங்கல்';

  @override
  String get onlinePayment => 'ஆன்லைன் கட்டணம்';

  @override
  String get orderSuccess => 'ஆர்டர் வெற்றி';

  @override
  String get orderSuccessTitle => 'உங்கள் ஆர்டர்\nவெற்றிகரமாக நிறைவேறியது!';

  @override
  String get orderSuccessSubtitle =>
      'சில நிமிடங்களில்\nநீங்கள் பதில் பெறுவீர்கள்.';

  @override
  String get trackOrder => 'ஆர்டரை கண்காணி';

  @override
  String get myOrders => 'என் ஆர்டர்கள்';

  @override
  String get orderHistory => 'ஆர்டர் வரலாறு';

  @override
  String get activeOrders => 'செயலில் உள்ள ஆர்டர்கள்';

  @override
  String get orderDetails => 'ஆர்டர் விவரங்கள்';

  @override
  String get orderPlaced => 'ஆர்டர் செய்யப்பட்டது';

  @override
  String get orderConfirmed => 'ஆர்டர் உறுதிப்படுத்தப்பட்டது';

  @override
  String get orderPacked => 'ஆர்டர் பேக் செய்யப்பட்டது';

  @override
  String get orderShipped => 'ஆர்டர் அனுப்பப்பட்டது';

  @override
  String get orderDelivered => 'ஆர்டர் வழங்கப்பட்டது';

  @override
  String get orderCancelled => 'ஆர்டர் ரத்து';

  @override
  String get noOrdersYet => 'இன்னும் ஆர்டர்கள் இல்லை';

  @override
  String get startShoppingNow => 'இப்போதே ஷாப்பிங் தொடங்கு';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get editProfile => 'சுயவிவரத்தை திருத்து';

  @override
  String get fullName => 'முழு பெயர்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get phoneNumber => 'தொலைபேசி எண்';

  @override
  String get saveChanges => 'மாற்றங்களை சேமி';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get logoutConfirm => 'நீங்கள் உண்மையில் வெளியேற விரும்புகிறீர்களா?';

  @override
  String get wallet => 'வாலட்';

  @override
  String get addMoney => 'பணம் சேர்';

  @override
  String get walletStatement => 'வாலட் அறிக்கை';

  @override
  String get topUp => 'டாப் அப்';

  @override
  String get balance => 'இருப்பு';

  @override
  String get transactions => 'பரிவர்த்தனைகள்';

  @override
  String get noTransactions => 'இன்னும் பரிவர்த்தனைகள் இல்லை';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get noNotifications => 'அறிவிப்புகள் இல்லை';

  @override
  String get markAllRead => 'அனைத்தையும் படித்ததாக குறி';

  @override
  String get helpSupport => 'உதவி & ஆதரவு';

  @override
  String get aboutUs => 'எங்களை பற்றி';

  @override
  String get contactUs => 'தொடர்பு கொள்ளுங்கள்';

  @override
  String get faq => 'அடிக்கடி கேட்கப்படும் கேள்விகள்';

  @override
  String get privacyPolicy => 'தனியுரிமை கொள்கை';

  @override
  String get termsConditions => 'விதிமுறைகள் & நிபந்தனைகள்';

  @override
  String get riderDashboard => 'டாஷ்போர்டு';

  @override
  String get assignedOrders => 'ஒதுக்கப்பட்ட ஆர்டர்கள்';

  @override
  String get earnings => 'வருவாய்';

  @override
  String get deliveryHistory => 'டெலிவரி வரலாறு';

  @override
  String get availableOrders => 'கிடைக்கும் ஆர்டர்கள்';

  @override
  String get acceptOrder => 'ஆர்டரை ஏற்கவும்';

  @override
  String get rejectOrder => 'ஆர்டரை நிராகரி';

  @override
  String get startDelivery => 'டெலிவரி தொடங்கு';

  @override
  String get markDelivered => 'வழங்கியதாக குறி';

  @override
  String get totalEarnings => 'மொத்த வருவாய்';

  @override
  String get todayEarnings => 'இன்றைய வருவாய்';

  @override
  String get subscription => 'சந்தா';

  @override
  String get mySubscription => 'என் சந்தா';

  @override
  String get subscribeNow => 'இப்போதே சந்தா செய்';

  @override
  String get activePlan => 'செயலில் உள்ள திட்டம்';

  @override
  String get renewPlan => 'திட்டத்தை புதுப்பி';

  @override
  String get cancelSubscription => 'சந்தாவை ரத்து செய்';

  @override
  String get ok => 'சரி';

  @override
  String get cancel => 'ரத்து';

  @override
  String get save => 'சேமி';

  @override
  String get delete => 'நீக்கு';

  @override
  String get back => 'பின்';

  @override
  String get loading => 'ஏற்றுகிறது...';

  @override
  String get retry => 'மீண்டும் முயற்சி';

  @override
  String get submit => 'சமர்ப்பி';

  @override
  String get confirm => 'உறுதிப்படுத்து';

  @override
  String get yes => 'ஆம்';

  @override
  String get no => 'இல்லை';

  @override
  String get close => 'மூடு';

  @override
  String get done => 'முடிந்தது';

  @override
  String get search => 'தேடு';

  @override
  String get filter => 'வடிகட்டு';

  @override
  String get sort => 'வரிசைப்படுத்து';

  @override
  String get more => 'மேலும்';

  @override
  String get reviews => 'மதிப்புரைகள்';

  @override
  String get rating => 'மதிப்பீடு';

  @override
  String get price => 'விலை';

  @override
  String get free => 'இலவசம்';

  @override
  String get off => 'தள்ளுபடி';

  @override
  String get homeLabel => 'வீடு';

  @override
  String get office => 'அலுவலகம்';

  @override
  String get other => 'மற்றவை';

  @override
  String get currentLocation => 'தற்போதைய இடம்';

  @override
  String get noInternetConnection => 'இணைய இணைப்பு இல்லை';

  @override
  String get somethingWentWrong => 'ஏதோ தவறு நடந்தது';

  @override
  String get tryAgain => 'மீண்டும் முயற்சி';

  @override
  String get sessionExpired => 'அமர்வு காலாவதியானது. மீண்டும் உள்நுழைக.';

  @override
  String get locationPermissionDenied => 'இட அனுமதி மறுக்கப்பட்டது';

  @override
  String get enableLocationServices => 'இட சேவைகளை இயக்கவும்';

  @override
  String get selectLanguage => 'மொழியை தேர்ந்தெடுக்கவும்';

  @override
  String get chooseLanguage => 'உங்கள் விருப்பமான மொழியை தேர்ந்தெடுக்கவும்';

  @override
  String get languageChanged => 'மொழி வெற்றிகரமாக மாற்றப்பட்டது';

  @override
  String get language => 'மொழி';
}
