import 'package:flutter/material.dart';
import '../../../data/services/db_service.dart';
import 'order_success_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'Credit Card';
  bool _saveCard = true;
  bool _isProcessing = false;

  Future<void> _processPayment(CartProvider cart) async {
    setState(() => _isProcessing = true);

    // Show a processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF2E7D32)),
              const SizedBox(height: 24),
              Text(
                'Processing $_selectedMethod...',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please do not press back or close the app.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate Payment Gateway Network Call (e.g. Razorpay/Stripe)
    await Future.delayed(const Duration(seconds: 3));

    // Close the dialog
    if (mounted) Navigator.pop(context);

    // Finalize Order
    cart.clearCart();
    if (mounted) {
      // Use pushReplacement so the user can't go back to the payment page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrderSuccessPage()),
      );
    }

    if (mounted) setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProviderScope.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),
            const SizedBox(height: 32),

            // Payment Methods
            Row(
              children: [
                _buildMethodSelector(
                  'UPI',
                  Icons.mobile_screen_share_rounded,
                  Colors.indigo,
                ),
                const SizedBox(width: 12),
                _buildMethodSelector(
                  'Credit Card',
                  Icons.credit_card,
                  Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMethodSelector(
                  'Cash on Delivery',
                  Icons.money,
                  Colors.green,
                ),
                const SizedBox(width: 12),
                _buildMethodSelector(
                  'Online Payment', 
                  Icons.account_balance, 
                  Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (_selectedMethod == 'Credit Card') ...[
              // Card Preview
              _buildCardPreview(),
              const SizedBox(height: 24),

              // Form Fields
              _buildIconTextField(Icons.person_outline, 'Name on the card'),
              const SizedBox(height: 12),
              _buildIconTextField(Icons.credit_card_outlined, 'Card number'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildIconTextField(
                      Icons.calendar_today_outlined,
                      'Month / Year',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildIconTextField(Icons.lock_outline, 'CVV'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Toggle
              Row(
                children: [
                  Switch(
                    value: _saveCard,
                    onChanged: (v) => setState(() => _saveCard = v),
                    activeThumbColor: const Color(0xFF2E7D32),
                    activeTrackColor: const Color(0xFFCFFAFE),
                  ),
                  const Text(
                    'Save this card',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ] else ...[
              _buildAlternateMethodInfo(),
            ],

            const SizedBox(height: 32),

            // Order Summary
            _buildOrderSummary(cart),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () => _processPayment(cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Pay ₹${cart.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlternateMethodInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCFFAFE), width: 1),
      ),
      child: Column(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF2E7D32), size: 40),
          const SizedBox(height: 16),
          Text(
            _selectedMethod == 'Online Payment'
                ? 'Secure Online Payment'
                : 'Secure Payment via $_selectedMethod',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          if (_selectedMethod == 'UPI')
            Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildUpiAppIcon('GPay', Colors.blue, 'G'),
                    _buildUpiAppIcon('PhonePe', Colors.deepPurple, 'P'),
                    _buildUpiAppIcon('Paytm', Colors.lightBlue, 'Pt'),
                    _buildUpiAppIcon('BHIM', Colors.orange, 'B'),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter UPI ID (e.g. name@upi)',
                    prefixIcon: const Icon(Icons.account_balance_wallet, size: 22),
                    filled: true,
                    fillColor: const Color(0xFFF7F8FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            )
          else if (_selectedMethod == 'Cash on Delivery')
            const Text(
              'You can pay with cash or UPI when the delivery arrives.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            )
          else if (_selectedMethod == 'Online Payment')
            Column(
              children: [
                const Text(
                  'Enter your bank details to proceed with the payment securely.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Account Holder Name',
                    prefixIcon: const Icon(Icons.person_outline, size: 22),
                    filled: true,
                    fillColor: const Color(0xFFF7F8FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Bank Name (e.g. HDFC, SBI)',
                    prefixIcon: const Icon(Icons.account_balance, size: 22),
                    filled: true,
                    fillColor: const Color(0xFFF7F8FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Account Number',
                    prefixIcon: const Icon(Icons.numbers, size: 22),
                    filled: true,
                    fillColor: const Color(0xFFF7F8FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'IFSC Code',
                    prefixIcon: const Icon(Icons.pin, size: 22),
                    filled: true,
                    fillColor: const Color(0xFFF7F8FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            )
          else
            const Text(
              'You will be redirected to complete your payment securely.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal', '₹${cart.subtotal.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Shipping',
            '₹${cart.shippingCharges.toStringAsFixed(0)}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF1F4F8)),
          ),
          _buildSummaryRow(
            'Total Amount',
            '₹${cart.total.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? const Color(0xFF1A1A1A) : Colors.grey,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            color: isTotal ? const Color(0xFF2E7D32) : const Color(0xFF1A1A1A),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(1, 'DELIVERY', true),
        _buildStepLine(true),
        _buildStep(2, 'ADDRESS', true),
        _buildStepLine(true),
        _buildStep(3, 'PAYMENT', true, isActive: true),
      ],
    );
  }

  Widget _buildStep(
    int num,
    String label,
    bool isCompleted, {
    bool isActive = false,
  }) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFF2E7D32)
                : Colors.grey.withValues(alpha:  0.2),
            shape: BoxShape.circle,
          ),
          child: isCompleted && !isActive
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : Center(
                  child: Text(
                    '$num',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isCompleted ? const Color(0xFFA1A1A1) : Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isCompleted) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
      color: isCompleted
          ? const Color(0xFF2E7D32)
          : Colors.grey.withValues(alpha:  0.2),
    );
  }

  Widget _buildMethodSelector(String label, IconData icon, Color color) {
    bool isSelected = _selectedMethod == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2E7D32).withValues(alpha:  0.5)
                  : Colors.grey.shade100,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF2E7D32)
                    : color.withValues(alpha:  0.6),
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha:  0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(-15, 0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha:  0.8),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.more_vert, color: Colors.white),
            ],
          ),
          const Spacer(),
          const Text(
            'XXXX XXXX XXXX 8790',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha:  0.6),
                      fontSize: 10,
                    ),
                  ),
                  const Text(
                    'RUSSELL AUSTIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha:  0.6),
                      fontSize: 10,
                    ),
                  ),
                  const Text(
                    '01 / 22',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconTextField(IconData icon, String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 22),
      ),
    );
  }

  Widget _buildUpiAppIcon(String name, Color color, String letter) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Selecting the UPI app will visually highlight it or we just process payment directly
            _processPayment(CartProviderScope.of(context));
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                letter,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildBankDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}




