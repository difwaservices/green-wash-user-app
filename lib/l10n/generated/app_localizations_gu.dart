// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appName => 'Difwa Water';

  @override
  String get onboarding1Title => 'શુદ્ધ પીવાનું પાણી\nતમારા દ્વારે';

  @override
  String get onboarding1Subtitle =>
      'તાજું અને ફિલ્ટર કરેલ પાણી સીધું\nતમારા ઘર અથવા ઓફિસ પર ડિલિવર.';

  @override
  String get onboarding2Title => 'સુરક્ષિત અને સ્વચ્છ\nઉત્તમ ગુણવત્તા';

  @override
  String get onboarding2Subtitle =>
      'તમારું સ્વાસ્થ્ય અને સુરક્ષા સુનિશ્ચિત કરવા\nઅમારું પાણી સખત ફિલ્ટ્રેશન પ્રક્રિયામાંથી પસાર થાય છે.';

  @override
  String get onboarding3Title => 'સરળ ઓર્ડર\nફક્ત એક ટૅપમાં';

  @override
  String get onboarding3Subtitle =>
      'Difwa Water App દ્વારા\nઝડપી અને સરળ બુકિંગ.';

  @override
  String get onboarding4Title => 'ઝડપી ડિલિવરી\nહાઇડ્રેટ રહો';

  @override
  String get onboarding4Subtitle =>
      'શહેરભરમાં સમયસર ડિલિવરી\nતમને અને તમારા પરિવારને સ્વસ્થ રાખવા.';

  @override
  String get skip => 'છોડો';

  @override
  String get next => 'આગળ';

  @override
  String get getStarted => 'શરૂ કરો';

  @override
  String get loginWithMobileNumber => 'મોબાઇલ નંબર વડે લૉગિન કરો';

  @override
  String get enterMobileDescription =>
      'OTP મેળવવા માટે 10 અંકનો મોબાઇલ નંબર દાખલ કરો.';

  @override
  String get mobileNumber => 'મોબાઇલ નંબર';

  @override
  String get mobileHint => 'દા.ત. 9876543210';

  @override
  String get sendOtp => 'OTP મોકલો';

  @override
  String get secureLoginText => 'OTP સાથે સુરક્ષિત અને ઝડપી લૉગિન';

  @override
  String get pleaseEnterMobileNumber => 'કૃપા કરી તમારો મોબાઇલ નંબર દાખલ કરો.';

  @override
  String get enterValidMobileNumber =>
      'કૃપા કરી માન્ય 10 અંકનો મોબાઇલ નંબર દાખલ કરો.';

  @override
  String get failedToSendOtp => 'OTP મોકલવામાં નિષ્ફળ. ફરી પ્રયાસ કરો.';

  @override
  String get anErrorOccurred => 'ભૂલ આવી. કૃપા કરી ફરી પ્રયાસ કરો.';

  @override
  String get otpVerification => 'OTP ચકાસણી';

  @override
  String get enterOtpSentTo => 'મોકલેલ OTP દાખલ કરો';

  @override
  String get verify => 'ચકાસો';

  @override
  String get resendOtp => 'OTP ફરી મોકલો';

  @override
  String resendIn(int seconds) {
    return '${seconds}s માં ફરી મોકલો';
  }

  @override
  String get invalidOtp => 'અમાન્ય OTP. ફરી પ્રયાસ કરો.';

  @override
  String get otpExpired => 'OTP ની સમય-સીમા પૂરી. નવો OTP મેળવો.';

  @override
  String get navHome => 'હોમ';

  @override
  String get navCart => 'કાર્ટ';

  @override
  String get navOrders => 'ઓર્ડર';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String get searchHint => 'કીવર્ડ શોધો..';

  @override
  String get categories => 'શ્રેણીઓ';

  @override
  String get featuredProducts => 'વિશેષ ઉત્પાદનો';

  @override
  String get addToCart => 'કાર્ટમાં ઉમેરો';

  @override
  String get goToCart => 'કાર્ટ પર જાઓ';

  @override
  String get welcome => 'સ્વાગત છે';

  @override
  String get viewAll => 'બધા જુઓ';

  @override
  String get noProductsFound => 'કોઈ ઉત્પાદન મળ્યું નહીં';

  @override
  String get noShopsAvailable => 'કોઈ દુકાન ઉપલબ્ધ નથી';

  @override
  String get shoppingCart => 'શૉપિંગ કાર્ટ';

  @override
  String get emptyCart => 'તમારી કાર્ટ ખાલી છે';

  @override
  String get addItemsToStart => 'શરૂ કરવા માટે આઇટમ ઉમેરો';

  @override
  String get shopNow => 'હવે ખરીદો';

  @override
  String get subtotal => 'ઉપ-કુલ';

  @override
  String get shippingCharges => 'શિપિંગ ચાર્જ';

  @override
  String get total => 'કુલ';

  @override
  String get checkout => 'ચેકઆઉટ';

  @override
  String get remove => 'દૂર કરો';

  @override
  String get quantity => 'જથ્થો';

  @override
  String get shippingAddress => 'શિપિંગ સરનામું';

  @override
  String get saveThisAddress => 'આ સરનામું સાચવો';

  @override
  String get deliveryAddress => 'ડિલિવરી સરનામું';

  @override
  String get addNewAddress => 'નવું સરનામું ઉમેરો';

  @override
  String get selectAddress => 'સરનામું પસંદ કરો';

  @override
  String get enterAddress => 'સરનામું દાખલ કરો';

  @override
  String get pincode => 'પિનકોડ';

  @override
  String get city => 'શહેર';

  @override
  String get state => 'રાજ્ય';

  @override
  String get landmark => 'લૅન્ડમાર્ક (વૈકલ્પિક)';

  @override
  String get paymentMethod => 'ચૂકવણી પદ્ધતિ';

  @override
  String get makePayment => 'ચૂકવણી કરો';

  @override
  String get paymentSuccessful => 'ચૂકવણી સફળ';

  @override
  String get paymentFailed => 'ચૂકવણી નિષ્ફળ';

  @override
  String get walletBalance => 'વૉલેટ બૅલેન્સ';

  @override
  String get useWallet => 'વૉલેટ વાપરો';

  @override
  String get cod => 'કૅશ ઑન ડિલિવરી';

  @override
  String get onlinePayment => 'ઑનલાઇન ચૂકવણી';

  @override
  String get orderSuccess => 'ઓર્ડર સફળ';

  @override
  String get orderSuccessTitle => 'તમારો ઓર્ડર\nસફળ રહ્યો!';

  @override
  String get orderSuccessSubtitle => 'થોડી મિનિટોમાં\nતમને જવાબ મળશે.';

  @override
  String get trackOrder => 'ઓર્ડર ટ્રૅક કરો';

  @override
  String get myOrders => 'મારા ઓર્ડર';

  @override
  String get orderHistory => 'ઓર્ડર ઇતિહાસ';

  @override
  String get activeOrders => 'સક્રિય ઓર્ડર';

  @override
  String get orderDetails => 'ઓર્ડર વિગત';

  @override
  String get orderPlaced => 'ઓર્ડર આપ્યો';

  @override
  String get orderConfirmed => 'ઓર્ડર કન્ફર્મ';

  @override
  String get orderPacked => 'ઓર્ડર પૅક';

  @override
  String get orderShipped => 'ઓર્ડર મોકલ્યો';

  @override
  String get orderDelivered => 'ઓર્ડર ડિલિવર';

  @override
  String get orderCancelled => 'ઓર્ડર રદ';

  @override
  String get noOrdersYet => 'હજી કોઈ ઓર્ડર નહીં';

  @override
  String get startShoppingNow => 'હવે ખરીદી શરૂ કરો';

  @override
  String get profile => 'પ્રોફાઇલ';

  @override
  String get editProfile => 'પ્રોફાઇલ સંપાદિત કરો';

  @override
  String get fullName => 'પૂરું નામ';

  @override
  String get email => 'ઈ-મેઇલ';

  @override
  String get phoneNumber => 'ફોન નંબર';

  @override
  String get saveChanges => 'ફેરફાર સાચવો';

  @override
  String get logout => 'લૉગઆઉટ';

  @override
  String get logoutConfirm => 'શું તમે ખરેખર લૉગઆઉટ કરવા માગો છો?';

  @override
  String get wallet => 'વૉલેટ';

  @override
  String get addMoney => 'પૈસા ઉમેરો';

  @override
  String get walletStatement => 'વૉલેટ સ્ટેટમૅન્ટ';

  @override
  String get topUp => 'ટૉપ અપ';

  @override
  String get balance => 'બૅલેન્સ';

  @override
  String get transactions => 'વ્યવહારો';

  @override
  String get noTransactions => 'હજી કોઈ વ્યવહાર નહીં';

  @override
  String get notifications => 'સૂચનાઓ';

  @override
  String get noNotifications => 'કોઈ સૂચના નહીં';

  @override
  String get markAllRead => 'બધાને વાંચ્યા તરીકે ચિહ્નિત કરો';

  @override
  String get helpSupport => 'સહાય અને સમર્થન';

  @override
  String get aboutUs => 'અમારા વિશે';

  @override
  String get contactUs => 'સંપર્ક કરો';

  @override
  String get faq => 'વારંવાર પૂછાતા પ્રશ્નો';

  @override
  String get privacyPolicy => 'ગોપનીયતા નીતિ';

  @override
  String get termsConditions => 'નિયમો અને શરતો';

  @override
  String get riderDashboard => 'ડૅશબોર્ડ';

  @override
  String get assignedOrders => 'સોંપાયેલ ઓર્ડર';

  @override
  String get earnings => 'કમાણી';

  @override
  String get deliveryHistory => 'ડિલિવરી ઇતિહાસ';

  @override
  String get availableOrders => 'ઉપલબ્ધ ઓર્ડર';

  @override
  String get acceptOrder => 'ઓર્ડર સ્વીકારો';

  @override
  String get rejectOrder => 'ઓર્ડર અસ્વીકાર';

  @override
  String get startDelivery => 'ડિલિવરી શરૂ કરો';

  @override
  String get markDelivered => 'ડિલિવર તરીકે ચિહ્નિત કરો';

  @override
  String get totalEarnings => 'કુલ કમાણી';

  @override
  String get todayEarnings => 'આજની કમાણી';

  @override
  String get subscription => 'સભ્યપદ';

  @override
  String get mySubscription => 'મારું સભ્યપદ';

  @override
  String get subscribeNow => 'હવે સભ્ય બનો';

  @override
  String get activePlan => 'સક્રિય યોજના';

  @override
  String get renewPlan => 'યોજના નવીનીકૃત કરો';

  @override
  String get cancelSubscription => 'સભ્યપદ રદ કરો';

  @override
  String get ok => 'ઠીક છે';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get save => 'સાચવો';

  @override
  String get delete => 'ભૂંસો';

  @override
  String get back => 'પાછળ';

  @override
  String get loading => 'લોડ થઈ રહ્યું છે...';

  @override
  String get retry => 'ફરી પ્રયાસ';

  @override
  String get submit => 'સબમિટ';

  @override
  String get confirm => 'કન્ફર્મ';

  @override
  String get yes => 'હા';

  @override
  String get no => 'ના';

  @override
  String get close => 'બંધ';

  @override
  String get done => 'થઈ ગયું';

  @override
  String get search => 'શોધો';

  @override
  String get filter => 'ફિલ્ટર';

  @override
  String get sort => 'ક્રમ';

  @override
  String get more => 'વધુ';

  @override
  String get reviews => 'સમીક્ષાઓ';

  @override
  String get rating => 'રેટિંગ';

  @override
  String get price => 'કિંમત';

  @override
  String get free => 'મફત';

  @override
  String get off => 'છૂટ';

  @override
  String get homeLabel => 'ઘર';

  @override
  String get office => 'ઓફિસ';

  @override
  String get other => 'અન્ય';

  @override
  String get currentLocation => 'વર્તમાન સ્થાન';

  @override
  String get noInternetConnection => 'ઇન્ટરનેટ કનેક્શન નથી';

  @override
  String get somethingWentWrong => 'કંઈક ખોટું ગયું';

  @override
  String get tryAgain => 'ફરી પ્રયાસ કરો';

  @override
  String get sessionExpired => 'સત્ર સમાપ્ત. ફરી લૉગિન કરો.';

  @override
  String get locationPermissionDenied => 'સ્થાન પરવાનગી નકારી';

  @override
  String get enableLocationServices => 'કૃપા કરી સ્થાન સેવાઓ સક્ષમ કરો';

  @override
  String get selectLanguage => 'ભાષા પસંદ કરો';

  @override
  String get chooseLanguage => 'તમારી પસંદીદા ભાષા પસંદ કરો';

  @override
  String get languageChanged => 'ભાષા સફળતાપૂર્વક બદલાઈ';

  @override
  String get language => 'ભાષા';
}
