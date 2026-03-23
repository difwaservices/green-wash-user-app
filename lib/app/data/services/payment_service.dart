import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';

class PaymentService {
  final ApiClient _apiClient;
  late Razorpay _razorpay;

  PaymentService(this._apiClient) {
    _razorpay = Razorpay();
  }

  void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  Future<void> openCheckout({
    required double amount,
    required String contact,
    required String email,
  }) async {
    try {
      final keyId = dotenv.env['RAZORPAY_KEY_ID'] ?? 'rzp_test_S7lSvWtu89c6zD';
      print("Starting openCheckout...");
      print("Razorpay Key ID being used: $keyId");
      print("Amount: $amount, Contact: '$contact', Email: '$email'");

      if (contact.isEmpty && email.isEmpty) {
        print("WARNING: Both contact and email are empty. Razorpay may require at least one.");
      }

      print("Calling backend to create Razorpay Order ID...");
      final orderResponse = await _apiClient.post(
        '${ApiClient.paymentBaseUrl}/create-order',
        data: {'amount': amount},
        requiresAuth: true,
      );

      print("orderResponse data: $orderResponse");

      String? orderId;
      if (orderResponse is Map) {
        // Broad extraction logic for various backend response formats
        if (orderResponse.containsKey('order') && orderResponse['order'] is Map) {
          orderId = orderResponse['order']['id']?.toString();
        } else if (orderResponse.containsKey('id')) {
          orderId = orderResponse['id']?.toString();
        } else if (orderResponse.containsKey('data') && orderResponse['data'] is Map) {
          orderId = orderResponse['data']['id']?.toString();
        } else if (orderResponse.containsKey('razorpayOrderId')) {
          orderId = orderResponse['razorpayOrderId']?.toString();
        }
      }

      print("Extracted orderId: $orderId");

      if (orderId == null || orderId.isEmpty) {
        throw Exception("Server returned success but no valid Razorpay Order ID found. Response: $orderResponse");
      }

      // 2. Open Razorpay Checkout
      var options = {
        'key': keyId,
        'amount': (amount * 100).toInt(),
        'name': 'Difwa Water',
        'order_id': orderId,
        'description': 'Wallet Top-up',
        'prefill': {
          if (contact.isNotEmpty) 'contact': contact,
          if (email.isNotEmpty) 'email': email,
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      print("Opening Razorpay with options: $options");
      _razorpay.open(options);
      print("Razorpay open() called successfully.");
    } catch (e, stacktrace) {
      print("=====================================");
      print("ERROR IN PAYMENT SERVICE: ${e.toString()}");
      print("STACKTRACE: $stacktrace");
      print("=====================================");
      rethrow;
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(
    ref.watch(apiClientProvider),
  );
});
