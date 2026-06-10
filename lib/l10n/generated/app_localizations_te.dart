// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appName => 'Difwa Water';

  @override
  String get onboarding1Title => 'స్వచ్ఛమైన తాగునీరు\nమీ ద్వారం వద్దకే';

  @override
  String get onboarding1Subtitle =>
      'తాజా మరియు ఫిల్టర్ చేసిన నీరు\nమీ ఇంటికి లేదా కార్యాలయానికి చేరుస్తాం.';

  @override
  String get onboarding2Title => 'సురక్షితంగా & పరిశుభ్రంగా\nప్రీమియం నాణ్యత';

  @override
  String get onboarding2Subtitle =>
      'మా నీరు కఠినమైన వడపోత ప్రక్రియ గుండా వెళ్తుంది\nమీ ఆరోగ్యం మరియు భద్రత కోసం.';

  @override
  String get onboarding3Title => 'సులభమైన ఆర్డర్\nఒకే ట్యాప్‌లో';

  @override
  String get onboarding3Subtitle =>
      'Difwa Water App ద్వారా\nవేగంగా మరియు సులభంగా బుకింగ్.';

  @override
  String get onboarding4Title => 'త్వరిత డెలివరీ\nహైడ్రేటెడ్‌గా ఉండండి';

  @override
  String get onboarding4Subtitle =>
      'నగరమంతటా సమయానికి డెలివరీ\nమీరు మరియు మీ కుటుంబం ఆరోగ్యంగా ఉండేందుకు.';

  @override
  String get skip => 'దాటవేయండి';

  @override
  String get next => 'తదుపరి';

  @override
  String get getStarted => 'ప్రారంభించండి';

  @override
  String get loginWithMobileNumber => 'మొబైల్ నంబర్‌తో లాగిన్ అవ్వండి';

  @override
  String get enterMobileDescription =>
      'OTP అందుకోవడానికి 10 అంకెల మొబైల్ నంబర్ నమోదు చేయండి.';

  @override
  String get mobileNumber => 'మొబైల్ నంబర్';

  @override
  String get mobileHint => 'ఉదా. 9876543210';

  @override
  String get sendOtp => 'OTP పంపండి';

  @override
  String get secureLoginText => 'OTP తో సురక్షితమైన మరియు వేగవంతమైన లాగిన్';

  @override
  String get pleaseEnterMobileNumber => 'దయచేసి మీ మొబైల్ నంబర్ నమోదు చేయండి.';

  @override
  String get enterValidMobileNumber =>
      'దయచేసి చెల్లుబాటు అయ్యే 10 అంకెల మొబైల్ నంబర్ నమోదు చేయండి.';

  @override
  String get failedToSendOtp => 'OTP పంపడం విఫలమైంది. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get anErrorOccurred => 'లోపం సంభవించింది. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get otpVerification => 'OTP ధృవీకరణ';

  @override
  String get enterOtpSentTo => 'పంపిన OTP నమోదు చేయండి';

  @override
  String get verify => 'ధృవీకరించండి';

  @override
  String get resendOtp => 'OTP మళ్ళీ పంపండి';

  @override
  String resendIn(int seconds) {
    return '${seconds}s లో మళ్ళీ పంపండి';
  }

  @override
  String get invalidOtp => 'చెల్లని OTP. మళ్ళీ ప్రయత్నించండి.';

  @override
  String get otpExpired => 'OTP గడువు తీరింది. కొత్త OTP అభ్యర్థించండి.';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navCart => 'కార్ట్';

  @override
  String get navOrders => 'ఆర్డర్లు';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get searchHint => 'కీవర్డ్‌లు శోధించండి..';

  @override
  String get categories => 'వర్గాలు';

  @override
  String get featuredProducts => 'ప్రత్యేక ఉత్పత్తులు';

  @override
  String get addToCart => 'కార్ట్‌కు జోడించండి';

  @override
  String get goToCart => 'కార్ట్‌కు వెళ్ళండి';

  @override
  String get welcome => 'స్వాగతం';

  @override
  String get viewAll => 'అన్నీ చూడండి';

  @override
  String get noProductsFound => 'ఉత్పత్తులు కనుగొనబడలేదు';

  @override
  String get noShopsAvailable => 'దుకాణాలు అందుబాటులో లేవు';

  @override
  String get shoppingCart => 'షాపింగ్ కార్ట్';

  @override
  String get emptyCart => 'మీ కార్ట్ ఖాళీగా ఉంది';

  @override
  String get addItemsToStart => 'ప్రారంభించడానికి వస్తువులు జోడించండి';

  @override
  String get shopNow => 'ఇప్పుడు కొనండి';

  @override
  String get subtotal => 'ఉప మొత్తం';

  @override
  String get shippingCharges => 'షిప్పింగ్ చార్జీలు';

  @override
  String get total => 'మొత్తం';

  @override
  String get checkout => 'చెక్‌అవుట్';

  @override
  String get remove => 'తొలగించు';

  @override
  String get quantity => 'పరిమాణం';

  @override
  String get shippingAddress => 'షిప్పింగ్ చిరునామా';

  @override
  String get saveThisAddress => 'ఈ చిరునామా సేవ్ చేయండి';

  @override
  String get deliveryAddress => 'డెలివరీ చిరునామా';

  @override
  String get addNewAddress => 'కొత్త చిరునామా జోడించండి';

  @override
  String get selectAddress => 'చిరునామా ఎంచుకోండి';

  @override
  String get enterAddress => 'చిరునామా నమోదు చేయండి';

  @override
  String get pincode => 'పిన్‌కోడ్';

  @override
  String get city => 'నగరం';

  @override
  String get state => 'రాష్ట్రం';

  @override
  String get landmark => 'లాండ్‌మార్క్ (ఐచ్ఛికం)';

  @override
  String get paymentMethod => 'చెల్లింపు పద్ధతి';

  @override
  String get makePayment => 'చెల్లించండి';

  @override
  String get paymentSuccessful => 'చెల్లింపు విజయవంతం';

  @override
  String get paymentFailed => 'చెల్లింపు విఫలమైంది';

  @override
  String get walletBalance => 'వాలెట్ నిల్వ';

  @override
  String get useWallet => 'వాలెట్ ఉపయోగించండి';

  @override
  String get cod => 'క్యాష్ ఆన్ డెలివరీ';

  @override
  String get onlinePayment => 'ఆన్‌లైన్ చెల్లింపు';

  @override
  String get orderSuccess => 'ఆర్డర్ విజయవంతం';

  @override
  String get orderSuccessTitle => 'మీ ఆర్డర్\nవిజయవంతంగా జరిగింది!';

  @override
  String get orderSuccessSubtitle => 'కొన్ని నిమిషాల్లో\nమీకు స్పందన వస్తుంది.';

  @override
  String get trackOrder => 'ఆర్డర్ ట్రాక్ చేయండి';

  @override
  String get myOrders => 'నా ఆర్డర్లు';

  @override
  String get orderHistory => 'ఆర్డర్ చరిత్ర';

  @override
  String get activeOrders => 'క్రియాశీల ఆర్డర్లు';

  @override
  String get orderDetails => 'ఆర్డర్ వివరాలు';

  @override
  String get orderPlaced => 'ఆర్డర్ చేయబడింది';

  @override
  String get orderConfirmed => 'ఆర్డర్ నిర్ధారించబడింది';

  @override
  String get orderPacked => 'ఆర్డర్ ప్యాక్ చేయబడింది';

  @override
  String get orderShipped => 'ఆర్డర్ పంపబడింది';

  @override
  String get orderDelivered => 'ఆర్డర్ డెలివరీ అయింది';

  @override
  String get orderCancelled => 'ఆర్డర్ రద్దయింది';

  @override
  String get noOrdersYet => 'ఇంకా ఆర్డర్లు లేవు';

  @override
  String get startShoppingNow => 'ఇప్పుడే షాపింగ్ ప్రారంభించండి';

  @override
  String get profile => 'ప్రొఫైల్';

  @override
  String get editProfile => 'ప్రొఫైల్ సవరించండి';

  @override
  String get fullName => 'పూర్తి పేరు';

  @override
  String get email => 'ఇమెయిల్';

  @override
  String get phoneNumber => 'ఫోన్ నంబర్';

  @override
  String get saveChanges => 'మార్పులు సేవ్ చేయండి';

  @override
  String get logout => 'లాగ్‌అవుట్';

  @override
  String get logoutConfirm => 'మీరు నిజంగా లాగ్‌అవుట్ చేయాలనుకుంటున్నారా?';

  @override
  String get wallet => 'వాలెట్';

  @override
  String get addMoney => 'డబ్బు జోడించండి';

  @override
  String get walletStatement => 'వాలెట్ స్టేట్‌మెంట్';

  @override
  String get topUp => 'టాప్ అప్';

  @override
  String get balance => 'నిల్వ';

  @override
  String get transactions => 'లావాదేవీలు';

  @override
  String get noTransactions => 'ఇంకా లావాదేవీలు లేవు';

  @override
  String get notifications => 'నోటిఫికేషన్‌లు';

  @override
  String get noNotifications => 'నోటిఫికేషన్‌లు లేవు';

  @override
  String get markAllRead => 'అన్నీ చదివినట్టు గుర్తించండి';

  @override
  String get helpSupport => 'సహాయం & మద్దతు';

  @override
  String get aboutUs => 'మా గురించి';

  @override
  String get contactUs => 'సంప్రదించండి';

  @override
  String get faq => 'తరచుగా అడిగే ప్రశ్నలు';

  @override
  String get privacyPolicy => 'గోప్యతా విధానం';

  @override
  String get termsConditions => 'నిబంధనలు & షరతులు';

  @override
  String get riderDashboard => 'డాష్‌బోర్డ్';

  @override
  String get assignedOrders => 'కేటాయించిన ఆర్డర్లు';

  @override
  String get earnings => 'సంపాదన';

  @override
  String get deliveryHistory => 'డెలివరీ చరిత్ర';

  @override
  String get availableOrders => 'అందుబాటులో ఉన్న ఆర్డర్లు';

  @override
  String get acceptOrder => 'ఆర్డర్ అంగీకరించండి';

  @override
  String get rejectOrder => 'ఆర్డర్ తిరస్కరించండి';

  @override
  String get startDelivery => 'డెలివరీ ప్రారంభించండి';

  @override
  String get markDelivered => 'డెలివరీ అయినట్టు గుర్తించండి';

  @override
  String get totalEarnings => 'మొత్తం సంపాదన';

  @override
  String get todayEarnings => 'నేటి సంపాదన';

  @override
  String get subscription => 'చందా';

  @override
  String get mySubscription => 'నా చందా';

  @override
  String get subscribeNow => 'ఇప్పుడే చందా తీసుకోండి';

  @override
  String get activePlan => 'క్రియాశీల ప్లాన్';

  @override
  String get renewPlan => 'ప్లాన్ పునరుద్ధరించండి';

  @override
  String get cancelSubscription => 'చందా రద్దు చేయండి';

  @override
  String get ok => 'సరే';

  @override
  String get cancel => 'రద్దు చేయండి';

  @override
  String get save => 'సేవ్ చేయండి';

  @override
  String get delete => 'తొలగించండి';

  @override
  String get back => 'వెనక్కి';

  @override
  String get loading => 'లోడ్ అవుతోంది...';

  @override
  String get retry => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get submit => 'సమర్పించండి';

  @override
  String get confirm => 'నిర్ధారించండి';

  @override
  String get yes => 'అవును';

  @override
  String get no => 'కాదు';

  @override
  String get close => 'మూసివేయండి';

  @override
  String get done => 'పూర్తయింది';

  @override
  String get search => 'శోధన';

  @override
  String get filter => 'ఫిల్టర్';

  @override
  String get sort => 'క్రమబద్ధీకరించండి';

  @override
  String get more => 'మరిన్ని';

  @override
  String get reviews => 'సమీక్షలు';

  @override
  String get rating => 'రేటింగ్';

  @override
  String get price => 'ధర';

  @override
  String get free => 'ఉచితం';

  @override
  String get off => 'తగ్గింపు';

  @override
  String get homeLabel => 'ఇల్లు';

  @override
  String get office => 'కార్యాలయం';

  @override
  String get other => 'ఇతర';

  @override
  String get currentLocation => 'ప్రస్తుత స్థానం';

  @override
  String get noInternetConnection => 'ఇంటర్నెట్ కనెక్షన్ లేదు';

  @override
  String get somethingWentWrong => 'ఏదో తప్పు జరిగింది';

  @override
  String get tryAgain => 'మళ్ళీ ప్రయత్నించండి';

  @override
  String get sessionExpired =>
      'సెషన్ గడువు తీరింది. దయచేసి మళ్ళీ లాగిన్ అవ్వండి.';

  @override
  String get locationPermissionDenied => 'లొకేషన్ అనుమతి నిరాకరించబడింది';

  @override
  String get enableLocationServices => 'దయచేసి లొకేషన్ సేవలు సక్రియం చేయండి';

  @override
  String get selectLanguage => 'భాష ఎంచుకోండి';

  @override
  String get chooseLanguage => 'మీకు ఇష్టమైన భాషను ఎంచుకోండి';

  @override
  String get languageChanged => 'భాష విజయవంతంగా మార్చబడింది';

  @override
  String get language => 'భాష';
}
