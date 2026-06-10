// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Difwa Water';

  @override
  String get onboarding1Title => 'বিশুদ্ধ পানীয় জল\nআপনার দরজায়';

  @override
  String get onboarding1Subtitle =>
      'তাজা ও ফিল্টার করা জল সরাসরি\nআপনার বাড়ি বা অফিসে পৌঁছে দেওয়া হয়।';

  @override
  String get onboarding2Title => 'নিরাপদ ও স্বাস্থ্যকর\nপ্রিমিয়াম মান';

  @override
  String get onboarding2Subtitle =>
      'আমাদের জল কঠোর পরিশোধন প্রক্রিয়ার মধ্য দিয়ে যায়\nযাতে আপনার স্বাস্থ্য ও সুরক্ষা নিশ্চিত হয়।';

  @override
  String get onboarding3Title => 'সহজ অর্ডার\nমাত্র একটি ট্যাপে';

  @override
  String get onboarding3Subtitle =>
      'Difwa Water অ্যাপের মাধ্যমে\nদ্রুত ও সহজ বুকিং।';

  @override
  String get onboarding4Title => 'দ্রুত ডেলিভারি\nহাইড্রেটেড থাকুন';

  @override
  String get onboarding4Subtitle =>
      'সারা শহরে সময়মতো ডেলিভারি\nআপনার ও আপনার পরিবারের সুস্বাস্থ্যের জন্য।';

  @override
  String get skip => 'এড়িয়ে যান';

  @override
  String get next => 'পরবর্তী';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get loginWithMobileNumber => 'মোবাইল নম্বর দিয়ে লগইন করুন';

  @override
  String get enterMobileDescription =>
      'OTP পেতে ১০ সংখ্যার মোবাইল নম্বর লিখুন।';

  @override
  String get mobileNumber => 'মোবাইল নম্বর';

  @override
  String get mobileHint => 'যেমন 9876543210';

  @override
  String get sendOtp => 'OTP পাঠান';

  @override
  String get secureLoginText => 'OTP দিয়ে নিরাপদ ও দ্রুত লগইন';

  @override
  String get pleaseEnterMobileNumber => 'অনুগ্রহ করে আপনার মোবাইল নম্বর লিখুন।';

  @override
  String get enterValidMobileNumber =>
      'অনুগ্রহ করে একটি বৈধ ১০ সংখ্যার মোবাইল নম্বর লিখুন।';

  @override
  String get failedToSendOtp => 'OTP পাঠাতে ব্যর্থ। আবার চেষ্টা করুন।';

  @override
  String get anErrorOccurred => 'একটি ত্রুটি ঘটেছে। আবার চেষ্টা করুন।';

  @override
  String get otpVerification => 'OTP যাচাইকরণ';

  @override
  String get enterOtpSentTo => 'যে নম্বরে OTP পাঠানো হয়েছে সেটি লিখুন';

  @override
  String get verify => 'যাচাই করুন';

  @override
  String get resendOtp => 'OTP পুনরায় পাঠান';

  @override
  String resendIn(int seconds) {
    return '${seconds}s এ পুনরায় পাঠান';
  }

  @override
  String get invalidOtp => 'অবৈধ OTP। আবার চেষ্টা করুন।';

  @override
  String get otpExpired => 'OTP মেয়াদ শেষ। নতুন OTP চান।';

  @override
  String get navHome => 'হোম';

  @override
  String get navCart => 'কার্ট';

  @override
  String get navOrders => 'অর্ডার';

  @override
  String get navProfile => 'প্রোফাইল';

  @override
  String get searchHint => 'কীওয়ার্ড খুঁজুন..';

  @override
  String get categories => 'বিভাগ';

  @override
  String get featuredProducts => 'বিশেষ পণ্য';

  @override
  String get addToCart => 'কার্টে যোগ করুন';

  @override
  String get goToCart => 'কার্টে যান';

  @override
  String get welcome => 'স্বাগতম';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String get noProductsFound => 'কোনো পণ্য পাওয়া যায়নি';

  @override
  String get noShopsAvailable => 'কোনো দোকান উপলব্ধ নেই';

  @override
  String get shoppingCart => 'শপিং কার্ট';

  @override
  String get emptyCart => 'আপনার কার্ট খালি';

  @override
  String get addItemsToStart => 'শুরু করতে আইটেম যোগ করুন';

  @override
  String get shopNow => 'এখনই কিনুন';

  @override
  String get subtotal => 'উপমোট';

  @override
  String get shippingCharges => 'শিপিং চার্জ';

  @override
  String get total => 'মোট';

  @override
  String get checkout => 'চেকআউট';

  @override
  String get remove => 'সরান';

  @override
  String get quantity => 'পরিমাণ';

  @override
  String get shippingAddress => 'শিপিং ঠিকানা';

  @override
  String get saveThisAddress => 'এই ঠিকানা সংরক্ষণ করুন';

  @override
  String get deliveryAddress => 'ডেলিভারি ঠিকানা';

  @override
  String get addNewAddress => 'নতুন ঠিকানা যোগ করুন';

  @override
  String get selectAddress => 'ঠিকানা নির্বাচন করুন';

  @override
  String get enterAddress => 'ঠিকানা লিখুন';

  @override
  String get pincode => 'পিনকোড';

  @override
  String get city => 'শহর';

  @override
  String get state => 'রাজ্য';

  @override
  String get landmark => 'ল্যান্ডমার্ক (ঐচ্ছিক)';

  @override
  String get paymentMethod => 'পেমেন্ট পদ্ধতি';

  @override
  String get makePayment => 'পেমেন্ট করুন';

  @override
  String get paymentSuccessful => 'পেমেন্ট সফল';

  @override
  String get paymentFailed => 'পেমেন্ট ব্যর্থ';

  @override
  String get walletBalance => 'ওয়ালেট ব্যালেন্স';

  @override
  String get useWallet => 'ওয়ালেট ব্যবহার করুন';

  @override
  String get cod => 'ক্যাশ অন ডেলিভারি';

  @override
  String get onlinePayment => 'অনলাইন পেমেন্ট';

  @override
  String get orderSuccess => 'অর্ডার সফল';

  @override
  String get orderSuccessTitle => 'আপনার অর্ডার\nসফল হয়েছে!';

  @override
  String get orderSuccessSubtitle => 'কয়েক মিনিটের মধ্যে\nআপনি সাড়া পাবেন।';

  @override
  String get trackOrder => 'অর্ডার ট্র্যাক করুন';

  @override
  String get myOrders => 'আমার অর্ডার';

  @override
  String get orderHistory => 'অর্ডার ইতিহাস';

  @override
  String get activeOrders => 'সক্রিয় অর্ডার';

  @override
  String get orderDetails => 'অর্ডার বিবরণ';

  @override
  String get orderPlaced => 'অর্ডার দেওয়া হয়েছে';

  @override
  String get orderConfirmed => 'অর্ডার নিশ্চিত';

  @override
  String get orderPacked => 'অর্ডার প্যাক হয়েছে';

  @override
  String get orderShipped => 'অর্ডার পাঠানো হয়েছে';

  @override
  String get orderDelivered => 'অর্ডার ডেলিভারি হয়েছে';

  @override
  String get orderCancelled => 'অর্ডার বাতিল';

  @override
  String get noOrdersYet => 'এখনো কোনো অর্ডার নেই';

  @override
  String get startShoppingNow => 'এখনই কেনাকাটা শুরু করুন';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get editProfile => 'প্রোফাইল সম্পাদনা করুন';

  @override
  String get fullName => 'পুরো নাম';

  @override
  String get email => 'ইমেইল';

  @override
  String get phoneNumber => 'ফোন নম্বর';

  @override
  String get saveChanges => 'পরিবর্তন সংরক্ষণ করুন';

  @override
  String get logout => 'লগআউট';

  @override
  String get logoutConfirm => 'আপনি কি সত্যিই লগআউট করতে চান?';

  @override
  String get wallet => 'ওয়ালেট';

  @override
  String get addMoney => 'টাকা যোগ করুন';

  @override
  String get walletStatement => 'ওয়ালেট স্টেটমেন্ট';

  @override
  String get topUp => 'টপ আপ';

  @override
  String get balance => 'ব্যালেন্স';

  @override
  String get transactions => 'লেনদেন';

  @override
  String get noTransactions => 'এখনো কোনো লেনদেন নেই';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get noNotifications => 'কোনো বিজ্ঞপ্তি নেই';

  @override
  String get markAllRead => 'সব পঠিত চিহ্নিত করুন';

  @override
  String get helpSupport => 'সাহায্য ও সহায়তা';

  @override
  String get aboutUs => 'আমাদের সম্পর্কে';

  @override
  String get contactUs => 'যোগাযোগ করুন';

  @override
  String get faq => 'সাধারণ প্রশ্ন';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get termsConditions => 'শর্তাবলী';

  @override
  String get riderDashboard => 'ড্যাশবোর্ড';

  @override
  String get assignedOrders => 'নির্ধারিত অর্ডার';

  @override
  String get earnings => 'আয়';

  @override
  String get deliveryHistory => 'ডেলিভারি ইতিহাস';

  @override
  String get availableOrders => 'উপলব্ধ অর্ডার';

  @override
  String get acceptOrder => 'অর্ডার গ্রহণ করুন';

  @override
  String get rejectOrder => 'অর্ডার প্রত্যাখ্যান করুন';

  @override
  String get startDelivery => 'ডেলিভারি শুরু করুন';

  @override
  String get markDelivered => 'ডেলিভারি হিসেবে চিহ্নিত করুন';

  @override
  String get totalEarnings => 'মোট আয়';

  @override
  String get todayEarnings => 'আজকের আয়';

  @override
  String get subscription => 'সাবস্ক্রিপশন';

  @override
  String get mySubscription => 'আমার সাবস্ক্রিপশন';

  @override
  String get subscribeNow => 'এখনই সাবস্ক্রাইব করুন';

  @override
  String get activePlan => 'সক্রিয় পরিকল্পনা';

  @override
  String get renewPlan => 'পরিকল্পনা নবায়ন করুন';

  @override
  String get cancelSubscription => 'সাবস্ক্রিপশন বাতিল করুন';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get cancel => 'বাতিল';

  @override
  String get save => 'সংরক্ষণ করুন';

  @override
  String get delete => 'মুছুন';

  @override
  String get back => 'ফিরে যান';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get submit => 'জমা দিন';

  @override
  String get confirm => 'নিশ্চিত করুন';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get search => 'খুঁজুন';

  @override
  String get filter => 'ফিল্টার';

  @override
  String get sort => 'সাজান';

  @override
  String get more => 'আরও';

  @override
  String get reviews => 'রিভিউ';

  @override
  String get rating => 'রেটিং';

  @override
  String get price => 'মূল্য';

  @override
  String get free => 'বিনামূল্যে';

  @override
  String get off => 'ছাড়';

  @override
  String get homeLabel => 'বাড়ি';

  @override
  String get office => 'অফিস';

  @override
  String get other => 'অন্যান্য';

  @override
  String get currentLocation => 'বর্তমান অবস্থান';

  @override
  String get noInternetConnection => 'ইন্টারনেট সংযোগ নেই';

  @override
  String get somethingWentWrong => 'কিছু একটা ভুল হয়েছে';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get sessionExpired => 'সেশন শেষ হয়ে গেছে। আবার লগইন করুন।';

  @override
  String get locationPermissionDenied => 'লোকেশন অনুমতি প্রত্যাখ্যাত';

  @override
  String get enableLocationServices => 'অনুগ্রহ করে লোকেশন সেবা সক্রিয় করুন';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get chooseLanguage => 'আপনার পছন্দের ভাষা বেছে নিন';

  @override
  String get languageChanged => 'ভাষা সফলভাবে পরিবর্তিত হয়েছে';

  @override
  String get language => 'ভাষা';
}
