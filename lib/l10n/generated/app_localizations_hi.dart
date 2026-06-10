// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Difwa Water';

  @override
  String get onboarding1Title => 'शुद्ध पेयजल\nआपके दरवाज़े पर';

  @override
  String get onboarding1Subtitle =>
      'ताज़ा और फ़िल्टर किया पानी सीधे\nआपके घर या ऑफ़िस पहुँचाया जाता है।';

  @override
  String get onboarding2Title => 'सुरक्षित और स्वच्छ\nप्रीमियम गुणवत्ता';

  @override
  String get onboarding2Subtitle =>
      'हमारा पानी कड़ी निस्पंदन प्रक्रिया से गुज़रता है\nताकि आपका स्वास्थ्य सुरक्षित रहे।';

  @override
  String get onboarding3Title => 'आसान ऑर्डर\nबस एक टैप में';

  @override
  String get onboarding3Subtitle =>
      'Difwa Water ऐप के माध्यम से\nतेज़ और सरल बुकिंग।';

  @override
  String get onboarding4Title => 'तेज़ डिलीवरी\nहाइड्रेटेड रहें';

  @override
  String get onboarding4Subtitle =>
      'पूरे शहर में समय पर डिलीवरी\nताकि आप और आपका परिवार स्वस्थ रहे।';

  @override
  String get skip => 'छोड़ें';

  @override
  String get next => 'आगे';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get loginWithMobileNumber => 'मोबाइल नंबर से लॉगिन करें';

  @override
  String get enterMobileDescription =>
      'OTP प्राप्त करने के लिए 10 अंकों का मोबाइल नंबर दर्ज करें।';

  @override
  String get mobileNumber => 'मोबाइल नंबर';

  @override
  String get mobileHint => 'जैसे 9876543210';

  @override
  String get sendOtp => 'OTP भेजें';

  @override
  String get secureLoginText => 'OTP से सुरक्षित और तेज़ लॉगिन';

  @override
  String get pleaseEnterMobileNumber => 'कृपया अपना मोबाइल नंबर दर्ज करें।';

  @override
  String get enterValidMobileNumber =>
      'कृपया 10 अंकों का वैध मोबाइल नंबर दर्ज करें।';

  @override
  String get failedToSendOtp => 'OTP भेजने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get anErrorOccurred => 'कोई त्रुटि हुई। कृपया पुनः प्रयास करें।';

  @override
  String get otpVerification => 'OTP सत्यापन';

  @override
  String get enterOtpSentTo => 'OTP दर्ज करें जो भेजा गया है';

  @override
  String get verify => 'सत्यापित करें';

  @override
  String get resendOtp => 'OTP फिर से भेजें';

  @override
  String resendIn(int seconds) {
    return '${seconds}s में पुनः भेजें';
  }

  @override
  String get invalidOtp => 'अमान्य OTP। कृपया पुनः प्रयास करें।';

  @override
  String get otpExpired => 'OTP समाप्त हो गया। नया OTP मँगाएं।';

  @override
  String get navHome => 'होम';

  @override
  String get navCart => 'कार्ट';

  @override
  String get navOrders => 'ऑर्डर';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get searchHint => 'कीवर्ड खोजें..';

  @override
  String get categories => 'श्रेणियाँ';

  @override
  String get featuredProducts => 'विशेष उत्पाद';

  @override
  String get addToCart => 'कार्ट में जोड़ें';

  @override
  String get goToCart => 'कार्ट पर जाएं';

  @override
  String get welcome => 'स्वागत है';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get noProductsFound => 'कोई उत्पाद नहीं मिला';

  @override
  String get noShopsAvailable => 'कोई दुकान उपलब्ध नहीं';

  @override
  String get shoppingCart => 'शॉपिंग कार्ट';

  @override
  String get emptyCart => 'आपकी कार्ट खाली है';

  @override
  String get addItemsToStart => 'शुरू करने के लिए आइटम जोड़ें';

  @override
  String get shopNow => 'अभी खरीदें';

  @override
  String get subtotal => 'उप-कुल';

  @override
  String get shippingCharges => 'शिपिंग शुल्क';

  @override
  String get total => 'कुल';

  @override
  String get checkout => 'चेकआउट';

  @override
  String get remove => 'हटाएं';

  @override
  String get quantity => 'मात्रा';

  @override
  String get shippingAddress => 'शिपिंग पता';

  @override
  String get saveThisAddress => 'यह पता सहेजें';

  @override
  String get deliveryAddress => 'डिलीवरी पता';

  @override
  String get addNewAddress => 'नया पता जोड़ें';

  @override
  String get selectAddress => 'पता चुनें';

  @override
  String get enterAddress => 'पता दर्ज करें';

  @override
  String get pincode => 'पिनकोड';

  @override
  String get city => 'शहर';

  @override
  String get state => 'राज्य';

  @override
  String get landmark => 'लैंडमार्क (वैकल्पिक)';

  @override
  String get paymentMethod => 'भुगतान विधि';

  @override
  String get makePayment => 'भुगतान करें';

  @override
  String get paymentSuccessful => 'भुगतान सफल';

  @override
  String get paymentFailed => 'भुगतान विफल';

  @override
  String get walletBalance => 'वॉलेट बैलेंस';

  @override
  String get useWallet => 'वॉलेट उपयोग करें';

  @override
  String get cod => 'कैश ऑन डिलीवरी';

  @override
  String get onlinePayment => 'ऑनलाइन भुगतान';

  @override
  String get orderSuccess => 'ऑर्डर सफल';

  @override
  String get orderSuccessTitle => 'आपका ऑर्डर\nसफलतापूर्वक हो गया!';

  @override
  String get orderSuccessSubtitle => 'कुछ ही मिनटों में\nआपको जवाब मिलेगा।';

  @override
  String get trackOrder => 'ऑर्डर ट्रैक करें';

  @override
  String get myOrders => 'मेरे ऑर्डर';

  @override
  String get orderHistory => 'ऑर्डर इतिहास';

  @override
  String get activeOrders => 'सक्रिय ऑर्डर';

  @override
  String get orderDetails => 'ऑर्डर विवरण';

  @override
  String get orderPlaced => 'ऑर्डर दिया गया';

  @override
  String get orderConfirmed => 'ऑर्डर पुष्टि हुई';

  @override
  String get orderPacked => 'ऑर्डर पैक हुआ';

  @override
  String get orderShipped => 'ऑर्डर भेजा गया';

  @override
  String get orderDelivered => 'ऑर्डर पहुँचा';

  @override
  String get orderCancelled => 'ऑर्डर रद्द';

  @override
  String get noOrdersYet => 'अभी कोई ऑर्डर नहीं';

  @override
  String get startShoppingNow => 'अभी खरीदारी शुरू करें';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get email => 'ईमेल';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get saveChanges => 'बदलाव सहेजें';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get logoutConfirm => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

  @override
  String get wallet => 'वॉलेट';

  @override
  String get addMoney => 'पैसे जोड़ें';

  @override
  String get walletStatement => 'वॉलेट स्टेटमेंट';

  @override
  String get topUp => 'टॉप अप';

  @override
  String get balance => 'बैलेंस';

  @override
  String get transactions => 'लेन-देन';

  @override
  String get noTransactions => 'अभी कोई लेन-देन नहीं';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get noNotifications => 'कोई सूचना नहीं';

  @override
  String get markAllRead => 'सभी पढ़े के रूप में चिह्नित करें';

  @override
  String get helpSupport => 'सहायता और समर्थन';

  @override
  String get aboutUs => 'हमारे बारे में';

  @override
  String get contactUs => 'संपर्क करें';

  @override
  String get faq => 'सामान्य प्रश्न';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get termsConditions => 'नियम और शर्तें';

  @override
  String get riderDashboard => 'डैशबोर्ड';

  @override
  String get assignedOrders => 'असाइन ऑर्डर';

  @override
  String get earnings => 'आय';

  @override
  String get deliveryHistory => 'डिलीवरी इतिहास';

  @override
  String get availableOrders => 'उपलब्ध ऑर्डर';

  @override
  String get acceptOrder => 'ऑर्डर स्वीकार करें';

  @override
  String get rejectOrder => 'ऑर्डर अस्वीकार करें';

  @override
  String get startDelivery => 'डिलीवरी शुरू करें';

  @override
  String get markDelivered => 'डिलीवर के रूप में चिह्नित करें';

  @override
  String get totalEarnings => 'कुल आय';

  @override
  String get todayEarnings => 'आज की आय';

  @override
  String get subscription => 'सदस्यता';

  @override
  String get mySubscription => 'मेरी सदस्यता';

  @override
  String get subscribeNow => 'अभी सदस्य बनें';

  @override
  String get activePlan => 'सक्रिय योजना';

  @override
  String get renewPlan => 'योजना नवीनीकृत करें';

  @override
  String get cancelSubscription => 'सदस्यता रद्द करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get delete => 'हटाएं';

  @override
  String get back => 'वापस';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get submit => 'सबमिट करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get close => 'बंद करें';

  @override
  String get done => 'हो गया';

  @override
  String get search => 'खोजें';

  @override
  String get filter => 'फ़िल्टर';

  @override
  String get sort => 'क्रमबद्ध करें';

  @override
  String get more => 'और';

  @override
  String get reviews => 'समीक्षाएं';

  @override
  String get rating => 'रेटिंग';

  @override
  String get price => 'कीमत';

  @override
  String get free => 'मुफ़्त';

  @override
  String get off => 'छूट';

  @override
  String get homeLabel => 'घर';

  @override
  String get office => 'ऑफ़िस';

  @override
  String get other => 'अन्य';

  @override
  String get currentLocation => 'वर्तमान स्थान';

  @override
  String get noInternetConnection => 'इंटरनेट कनेक्शन नहीं है';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get sessionExpired => 'सत्र समाप्त हो गया। कृपया फिर से लॉगिन करें।';

  @override
  String get locationPermissionDenied => 'लोकेशन अनुमति अस्वीकार';

  @override
  String get enableLocationServices => 'कृपया लोकेशन सेवाएं सक्षम करें';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get chooseLanguage => 'अपनी पसंदीदा भाषा चुनें';

  @override
  String get languageChanged => 'भाषा सफलतापूर्वक बदली गई';

  @override
  String get language => 'भाषा';
}
