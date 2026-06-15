// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appName => 'Difwa Water';

  @override
  String get onboarding1Title => 'ശുദ്ധമായ കുടിവെള്ളം\nനിങ്ങളുടെ വാതിൽക്കൽ';

  @override
  String get onboarding1Subtitle =>
      'ശുദ്ധവും ഫിൽട്ടർ ചെയ്തതുമായ വെള്ളം\nനിങ്ങളുടെ വീട്ടിലോ ഓഫീസിലോ ഡെലിവർ ചെയ്യുന്നു.';

  @override
  String get onboarding2Title => 'സുരക്ഷിതവും ശുചിത്വവും\nപ്രീമിയം ഗുണനിലവാരം';

  @override
  String get onboarding2Subtitle =>
      'നിങ്ങളുടെ ആരോഗ്യവും സുരക്ഷിതത്വവും ഉറപ്പാക്കാൻ\nഞങ്ങളുടെ വെള്ളം കർശനമായ ശുദ്ധീകരണ പ്രക്രിയയിലൂടെ കടന്നുപോകുന്നു.';

  @override
  String get onboarding3Title => 'എളുപ്പമുള്ള ഓർഡർ\nഒറ്റ ടാപ്പിൽ';

  @override
  String get onboarding3Subtitle =>
      'Difwa Water App വഴി\nവേഗത്തിലും എളുപ്പത്തിലും ബുക്കിംഗ്.';

  @override
  String get onboarding4Title => 'വേഗമുള്ള ഡെലിവറി\nഹൈഡ്രേറ്റഡ് ആയിരിക്കൂ';

  @override
  String get onboarding4Subtitle =>
      'നഗരമൊട്ടുക്കും സമയബന്ധിതമായ ഡെലിവറി\nനിങ്ങളും കുടുംബവും ആരോഗ്യകരമായിരിക്കാൻ.';

  @override
  String get skip => 'ഒഴിവാക്കുക';

  @override
  String get next => 'അടുത്തത്';

  @override
  String get getStarted => 'ആരംഭിക്കുക';

  @override
  String get loginWithMobileNumber => 'മൊബൈൽ നമ്പർ ഉപയോഗിച്ച് ലോഗിൻ ചെയ്യുക';

  @override
  String get enterMobileDescription =>
      'OTP സ്വീകരിക്കാൻ 10 അക്കമുള്ള മൊബൈൽ നമ്പർ നൽകുക.';

  @override
  String get mobileNumber => 'മൊബൈൽ നമ്പർ';

  @override
  String get mobileHint => 'ഉദാ. 9876543210';

  @override
  String get sendOtp => 'OTP അയക്കുക';

  @override
  String get secureLoginText =>
      'OTP ഉപയോഗിച്ച് സുരക്ഷിതവും വേഗമേറിയതുമായ ലോഗിൻ';

  @override
  String get pleaseEnterMobileNumber => 'ദയവായി നിങ്ങളുടെ മൊബൈൽ നമ്പർ നൽകുക.';

  @override
  String get enterValidMobileNumber =>
      'ദയവായി സാധുവായ 10 അക്ക മൊബൈൽ നമ്പർ നൽകുക.';

  @override
  String get failedToSendOtp => 'OTP അയക്കുന്നതിൽ പരാജയം. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get anErrorOccurred => 'ഒരു പിശക് സംഭവിച്ചു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get otpVerification => 'OTP സ്ഥിരീകരണം';

  @override
  String get enterOtpSentTo => 'അയച്ച OTP നൽകുക';

  @override
  String get verify => 'സ്ഥിരീകരിക്കുക';

  @override
  String get resendOtp => 'OTP വീണ്ടും അയക്കുക';

  @override
  String resendIn(int seconds) {
    return '${seconds}s-ൽ വീണ്ടും അയക്കുക';
  }

  @override
  String get invalidOtp => 'അസാധുവായ OTP. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get otpExpired => 'OTP കാലഹരണപ്പെട്ടു. പുതിയ OTP അഭ്യർത്ഥിക്കുക.';

  @override
  String get navHome => 'ഹോം';

  @override
  String get navCart => 'കാർട്ട്';

  @override
  String get navOrders => 'ഓർഡറുകൾ';

  @override
  String get navProfile => 'പ്രൊഫൈൽ';

  @override
  String get searchHint => 'കീവേഡുകൾ തിരയുക..';

  @override
  String get categories => 'വിഭാഗങ്ങൾ';

  @override
  String get featuredProducts => 'പ്രത്യേക ഉൽപ്പന്നങ്ങൾ';

  @override
  String get addToCart => 'കാർട്ടിൽ ചേർക്കുക';

  @override
  String get goToCart => 'കാർട്ടിലേക്ക് പോകുക';

  @override
  String get welcome => 'സ്വാഗതം';

  @override
  String get viewAll => 'എല്ലാം കാണുക';

  @override
  String get noProductsFound => 'ഉൽപ്പന്നങ്ങൾ കണ്ടെത്തിയില്ല';

  @override
  String get noShopsAvailable => 'കടകൾ ലഭ്യമല്ല';

  @override
  String get shoppingCart => 'ഷോപ്പിംഗ് കാർട്ട്';

  @override
  String get emptyCart => 'നിങ്ങളുടെ കാർട്ട് ശൂന്യമാണ്';

  @override
  String get addItemsToStart => 'ആരംഭിക്കാൻ ഇനങ്ങൾ ചേർക്കുക';

  @override
  String get shopNow => 'ഇപ്പോൾ വാങ്ങുക';

  @override
  String get subtotal => 'ഉപ-ആകെ';

  @override
  String get shippingCharges => 'ഷിപ്പിംഗ് നിരക്ക്';

  @override
  String get total => 'ആകെ';

  @override
  String get checkout => 'ചെക്ക്ഔട്ട്';

  @override
  String get remove => 'നീക്കം ചെയ്യുക';

  @override
  String get quantity => 'അളവ്';

  @override
  String get shippingAddress => 'ഷിപ്പിംഗ് വിലാസം';

  @override
  String get saveThisAddress => 'ഈ വിലാസം സംരക്ഷിക്കുക';

  @override
  String get deliveryAddress => 'ഡെലിവറി വിലാസം';

  @override
  String get addNewAddress => 'പുതിയ വിലാസം ചേർക്കുക';

  @override
  String get selectAddress => 'വിലാസം തിരഞ്ഞെടുക്കുക';

  @override
  String get enterAddress => 'വിലാസം നൽകുക';

  @override
  String get pincode => 'പിൻകോഡ്';

  @override
  String get city => 'നഗരം';

  @override
  String get state => 'സംസ്ഥാനം';

  @override
  String get landmark => 'ലാൻഡ്‌മാർക്ക് (ഐച്ഛികം)';

  @override
  String get paymentMethod => 'പേമെന്റ് രീതി';

  @override
  String get makePayment => 'പേമെന്റ് ചെയ്യുക';

  @override
  String get paymentSuccessful => 'പേമെന്റ് വിജയകരം';

  @override
  String get paymentFailed => 'പേമെന്റ് പരാജയം';

  @override
  String get walletBalance => 'വാലറ്റ് ബാലൻസ്';

  @override
  String get useWallet => 'വാലറ്റ് ഉപയോഗിക്കുക';

  @override
  String get cod => 'ക്യാഷ് ഓൺ ഡെലിവറി';

  @override
  String get onlinePayment => 'ഓൺലൈൻ പേമെന്റ്';

  @override
  String get orderSuccess => 'ഓർഡർ വിജയകരം';

  @override
  String get orderSuccessTitle => 'നിങ്ങളുടെ ഓർഡർ\nവിജയകരമായി';

  @override
  String get orderSuccessSubtitle =>
      'ഏതാനും മിനിറ്റുകൾക്കുള്ളിൽ\nനിങ്ങൾക്ക് പ്രതികരണം ലഭിക്കും.';

  @override
  String get trackOrder => 'ഓർഡർ ട്രാക്ക് ചെയ്യുക';

  @override
  String get myOrders => 'എന്റെ ഓർഡറുകൾ';

  @override
  String get orderHistory => 'ഓർഡർ ചരിത്രം';

  @override
  String get activeOrders => 'സജീവ ഓർഡറുകൾ';

  @override
  String get orderDetails => 'ഓർഡർ വിശദാംശങ്ങൾ';

  @override
  String get orderPlaced => 'ഓർഡർ നൽകി';

  @override
  String get orderConfirmed => 'ഓർഡർ സ്ഥിരീകരിച്ചു';

  @override
  String get orderPacked => 'ഓർഡർ പാക്ക് ചെയ്തു';

  @override
  String get orderShipped => 'ഓർഡർ അയച്ചു';

  @override
  String get orderDelivered => 'ഓർഡർ ഡെലിവർ ചെയ്തു';

  @override
  String get orderCancelled => 'ഓർഡർ റദ്ദ്';

  @override
  String get noOrdersYet => 'ഇനിയും ഓർഡറുകൾ ഇല്ല';

  @override
  String get startShoppingNow => 'ഇപ്പോൾ ഷോപ്പിംഗ് ആരംഭിക്കുക';

  @override
  String get profile => 'പ്രൊഫൈൽ';

  @override
  String get editProfile => 'പ്രൊഫൈൽ എഡിറ്റ് ചെയ്യുക';

  @override
  String get fullName => 'പൂർണ്ണ നാമം';

  @override
  String get email => 'ഇമെയിൽ';

  @override
  String get phoneNumber => 'ഫോൺ നമ്പർ';

  @override
  String get saveChanges => 'മാറ്റങ്ങൾ സംരക്ഷിക്കുക';

  @override
  String get logout => 'ലോഗ്ഔട്ട്';

  @override
  String get logoutConfirm =>
      'നിങ്ങൾ ശരിക്കും ലോഗ്ഔട്ട് ചെയ്യാൻ ആഗ്രഹിക്കുന്നുവോ?';

  @override
  String get wallet => 'വാലറ്റ്';

  @override
  String get addMoney => 'പണം ചേർക്കുക';

  @override
  String get walletStatement => 'വാലറ്റ് സ്റ്റേറ്റ്‌മെന്റ്';

  @override
  String get topUp => 'ടോപ് അപ്';

  @override
  String get balance => 'ബാലൻസ്';

  @override
  String get transactions => 'ഇടപാടുകൾ';

  @override
  String get noTransactions => 'ഇനിയും ഇടപാടുകൾ ഇല്ല';

  @override
  String get notifications => 'അറിയിപ്പുകൾ';

  @override
  String get noNotifications => 'അറിയിപ്പുകൾ ഇല്ല';

  @override
  String get markAllRead => 'എല്ലാം വായിച്ചതായി അടയാളപ്പെടുത്തുക';

  @override
  String get helpSupport => 'സഹായം & പിന്തുണ';

  @override
  String get aboutUs => 'ഞങ്ങളെക്കുറിച്ച്';

  @override
  String get contactUs => 'ബന്ധപ്പെടുക';

  @override
  String get faq => 'പതിവ് ചോദ്യങ്ങൾ';

  @override
  String get privacyPolicy => 'സ്വകാര്യതാ നയം';

  @override
  String get termsConditions => 'നിബന്ധനകളും വ്യവസ്ഥകളും';

  @override
  String get riderDashboard => 'ഡാഷ്ബോർഡ്';

  @override
  String get assignedOrders => 'നിയോഗിച്ച ഓർഡറുകൾ';

  @override
  String get earnings => 'വരുമാനം';

  @override
  String get deliveryHistory => 'ഡെലിവറി ചരിത്രം';

  @override
  String get availableOrders => 'ലഭ്യമായ ഓർഡറുകൾ';

  @override
  String get acceptOrder => 'ഓർഡർ സ്വീകരിക്കുക';

  @override
  String get rejectOrder => 'ഓർഡർ നിരസിക്കുക';

  @override
  String get startDelivery => 'ഡെലിവറി ആരംഭിക്കുക';

  @override
  String get markDelivered => 'ഡെലിവർ ചെയ്തതായി അടയാളപ്പെടുത്തുക';

  @override
  String get totalEarnings => 'ആകെ വരുമാനം';

  @override
  String get todayEarnings => 'ഇന്നത്തെ വരുമാനം';

  @override
  String get subscription => 'സബ്സ്ക്രിപ്ഷൻ';

  @override
  String get mySubscription => 'എന്റെ സബ്സ്ക്രിപ്ഷൻ';

  @override
  String get subscribeNow => 'ഇപ്പോൾ സബ്സ്ക്രൈബ് ചെയ്യുക';

  @override
  String get activePlan => 'സജീവ പ്ലാൻ';

  @override
  String get renewPlan => 'പ്ലാൻ പുതുക്കുക';

  @override
  String get cancelSubscription => 'സബ്സ്ക്രിപ്ഷൻ റദ്ദ് ചെയ്യുക';

  @override
  String get ok => 'ശരി';

  @override
  String get cancel => 'റദ്ദ് ചെയ്യുക';

  @override
  String get save => 'സംരക്ഷിക്കുക';

  @override
  String get delete => 'ഇല്ലാതാക്കുക';

  @override
  String get back => 'പിന്നോട്ട്';

  @override
  String get loading => 'ലോഡ് ചെയ്യുന്നു...';

  @override
  String get retry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get submit => 'സമർപ്പിക്കുക';

  @override
  String get confirm => 'സ്ഥിരീകരിക്കുക';

  @override
  String get yes => 'അതെ';

  @override
  String get no => 'ഇല്ല';

  @override
  String get close => 'അടയ്ക്കുക';

  @override
  String get done => 'പൂർത്തിയായി';

  @override
  String get search => 'തിരയുക';

  @override
  String get filter => 'ഫിൽട്ടർ';

  @override
  String get sort => 'ക്രമീകരിക്കുക';

  @override
  String get more => 'കൂടുതൽ';

  @override
  String get reviews => 'അവലോകനങ്ങൾ';

  @override
  String get rating => 'റേറ്റിംഗ്';

  @override
  String get price => 'വില';

  @override
  String get free => 'സൗജന്യം';

  @override
  String get off => 'ഡിസ്കൗണ്ട്';

  @override
  String get homeLabel => 'വീട്';

  @override
  String get office => 'ഓഫീസ്';

  @override
  String get other => 'മറ്റുള്ളവ';

  @override
  String get currentLocation => 'നിലവിലെ സ്ഥാനം';

  @override
  String get noInternetConnection => 'ഇന്റർനെറ്റ് കണക്ഷൻ ഇല്ല';

  @override
  String get somethingWentWrong => 'എന്തോ തകരാർ സംഭവിച്ചു';

  @override
  String get tryAgain => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get sessionExpired => 'സെഷൻ കാലഹരണപ്പെട്ടു. വീണ്ടും ലോഗിൻ ചെയ്യുക.';

  @override
  String get locationPermissionDenied => 'ലൊക്കേഷൻ അനുമതി നിഷേധിച്ചു';

  @override
  String get enableLocationServices => 'ലൊക്കേഷൻ സേവനങ്ങൾ പ്രാപ്തമാക്കുക';

  @override
  String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get chooseLanguage => 'നിങ്ങളുടെ ഇഷ്ടഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get languageChanged => 'ഭാഷ വിജയകരമായി മാറ്റി';

  @override
  String get language => 'ഭാഷ';
}
