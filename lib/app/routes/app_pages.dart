import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../modules/splash/splash_page.dart';
import '../modules/auth/deals_page.dart';
import '../modules/auth/login_page.dart';
import '../modules/auth/register_page.dart';
import '../modules/auth/forgot_password_page.dart';
import '../modules/auth/otp_verification_page.dart';
import '../modules/home/view/main_page.dart';
import '../modules/home/view/search_page.dart';
import '../modules/categories/view/vegetables_page.dart';
import '../modules/cart/view/cart_page.dart';
import '../modules/cart/view/shipping_address_page.dart';
import '../modules/cart/view/order_success_page.dart';
import '../modules/orders/view/orders_page.dart'; // Fixed name
import '../modules/profile/view/profile_page.dart';
import '../modules/rider/view/rider_main_page.dart';
import '../modules/rider/view/rider_home_page.dart'; // Import RiderHomePage
import '../modules/rider/view/rider_history_page.dart';
import '../modules/wallet/view/wallet_page.dart'; // Fixed name
import '../modules/wallet/view/wallet_statement_screen.dart';
import '../modules/orders/view/track_order_page.dart';
import '../modules/rider/view/rider_order_details_page.dart';
import '../modules/location/view/location_picker_screen.dart';
import '../modules/cart/view/payment_page.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.splash: (context) => const SplashPage(),
        AppRoutes.initialRoute: (context) => const RegisterPage(),
        AppRoutes.deals: (context) => const DealsPage(),
        AppRoutes.welcome: (context) => const LoginPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.signup: (context) => const RegisterPage(),
        AppRoutes.otp: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return OtpVerificationPage(
            phoneNumber: args?['phoneNumber'] ?? '',
            otp: args?['otp'],
          );
        },
        AppRoutes.forgotPassword: (context) => const ForgotPasswordPage(),
        AppRoutes.home: (context) => const MainPage(),
        AppRoutes.search: (context) => const SearchPage(),
        AppRoutes.waterAccessories: (context) => const VegetablesPage(),
        AppRoutes.cart: (context) => const CartPage(),
        AppRoutes.shippingAddress: (context) => const ShippingAddressPage(),
        AppRoutes.orderSuccess: (context) => const OrderSuccessPage(),
        AppRoutes.orderHistory: (context) => const OrdersPage(), // Fixed
        AppRoutes.profile: (context) => const ProfilePage(),
        AppRoutes.riderHome: (context) => const RiderMainPage(),
        AppRoutes.riderOrders: (context) => const RiderHomePage(), // Point to dashboard
        AppRoutes.riderHistory: (context) => const RiderHistoryPage(),
        AppRoutes.wallet: (context) => const WalletPage(), // Fixed
        AppRoutes.walletStatement: (context) => const WalletStatementScreen(),
        AppRoutes.trackOrder: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return TrackOrderPage(
            orderId: args?['orderId'] ?? '',
            deliveryAddress: args?['address'],
            status: args?['status'],
          );
        },
        AppRoutes.riderOrderDetails: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return RiderOrderDetailsPage(order: args?['order'] ?? {});
        },
        AppRoutes.locationPicker: (context) => const LocationPickerScreen(),
        AppRoutes.payment: (context) => const PaymentPage(),
      };
}
