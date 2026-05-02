import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/network/api_client.dart';
import '../../../data/models/food_models.dart';
import '../../../data/services/db_service.dart';
import '../../../core/constants/app_colors.dart';
import 'payment_method_page.dart';
import '../../profile/view/address_form_page.dart';
import '../../../routes/app_routes.dart';

class ShippingAddressPage extends ConsumerStatefulWidget {
  const ShippingAddressPage({super.key});

  @override
  ConsumerState<ShippingAddressPage> createState() =>
      _ShippingAddressPageState();
}

class _ShippingAddressPageState extends ConsumerState<ShippingAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullAddressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();

  String _selectedLabel = 'Home';
  UserAddress? _editingAddress;
  double? _latitude;
  double? _longitude;

  final List<Map<String, dynamic>> _labels = [
    {'name': 'Home', 'icon': Icons.home_rounded},
    {'name': 'Office', 'icon': Icons.work_rounded},
    {'name': 'Other', 'icon': Icons.location_on_rounded},
  ];

  bool _isDefault = true;
  bool _isSaving = false;
  bool _showAddForm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        CartProviderScope.of(context).loadAddresses();
      }
    });
  }

  @override
  void dispose() {
    _fullAddressCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _pincodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    final cart = CartProviderScope.of(context);
    
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final newAddress = UserAddress(
        id: _editingAddress?.id ?? '',
        title: _selectedLabel,
        street: _fullAddressCtrl.text.trim(),
        details: '${_cityCtrl.text.trim()}, ${_stateCtrl.text.trim()} ${_pincodeCtrl.text.trim()}',
        fullName: cart.userProfile.name, // Use profile directly
        email: cart.userProfile.email,   // Use profile directly
        isDefault: _isDefault,
        latitude: _latitude,
        longitude: _longitude,
      );

      if (_editingAddress == null) {
        await cart.addAddress(newAddress);
      } else {
        await cart.updateAddress(newAddress);
      }

      if (mounted) {
        setState(() {
          _showAddForm = false;
          _isSaving = false;
          _editingAddress = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Address saved and selected!'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartProviderScope.of(context);
    final addresses = cart.addresses;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black, size: 20),
          onPressed: () {
            if (_showAddForm && addresses.isNotEmpty) {
              setState(() => _showAddForm = false);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _showAddForm ? 'Add New Address' : 'Shipping Address',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: const _CheckoutStepper(currentStep: 1),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: animation.drive(Tween<Offset>(
                          begin: const Offset(0.05, 0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeOutCubic))),
                  child: child,
                ),
              ),
              child: cart.isAddressesLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.accentGreen))
                  : _showAddForm
                      ? _buildAddAddressView()
                      : _buildAddressListView(cart),
            ),
          ),
          if (!_showAddForm && addresses.isNotEmpty) _buildBottomAction(cart),
        ],
      ),
    );
  }

  Widget _buildAddressListView(CartProvider cart) {
    final addresses = cart.addresses;

    return SingleChildScrollView(
      key: const ValueKey('address_list'),
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Delivery Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              if (addresses.isNotEmpty)
                IconButton(
                  onPressed: () => cart.loadAddresses(),
                  icon: const Icon(Icons.refresh_rounded, color: Colors.grey, size: 20),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (addresses.isEmpty)
            _buildEmptyState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final addr = addresses[index];
                final isSelected = cart.selectedAddressIndex == index;
                return _buildAddressCard(addr, isSelected, () {
                  cart.selectAddress(index);
                });
              },
            ),
          const SizedBox(height: 24),
          _buildAddAddressButton(),
          const SizedBox(height: 100), // Space for bottom action
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_off_rounded,
                color: AppColors.accentGreen, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            'No saved addresses',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Please add an address to continue with your order.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(
      UserAddress addr, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accentGreen : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: 300.ms,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentGreen.withValues(alpha: 0.1)
                      : const Color(0xFFF1F4F8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  addr.title.toLowerCase() == 'home'
                      ? Icons.home_rounded
                      : addr.title.toLowerCase() == 'office'
                          ? Icons.work_rounded
                          : Icons.location_on_rounded,
                  color:
                      isSelected ? AppColors.accentGreen : Colors.grey.shade600,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          addr.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF1B2D1F),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            'SELECTED',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: AppColors.accentGreen,
                            ),
                          ),
                        ),
                      ],
                      if (addr.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F4F8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'DEFAULT',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    addr.street,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    addr.details,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isSelected ? AppColors.accentGreen : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.locationPicker,
                      arguments: {'initialAddress': addr},
                    );
                    if (result != null && mounted) {
                      CartProviderScope.of(context).loadAddresses();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.edit_location_alt_rounded,
                        color: AppColors.accentGreen.withValues(alpha: 0.8),
                        size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0),
    );
  }

  Widget _buildAddAddressButton() {
    return InkWell(
      onTap: () async {
        final result = await Navigator.pushNamed(context, AppRoutes.locationPicker);
        if (result != null && mounted) {
           // Address is already saved by the LocationPicker's bottom sheet
           CartProviderScope.of(context).loadAddresses();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.accentGreen.withValues(alpha: 0.3),
            style: BorderStyle.solid,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location_alt_rounded,
                color: AppColors.accentGreen, size: 24),
            const SizedBox(width: 12),
            Text(
              'Add New Delivery Address',
              style: TextStyle(
                color: AppColors.accentGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressView() {
    return SingleChildScrollView(
      key: const ValueKey('add_form'),
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                final result = await Navigator.pushNamed(context, '/location-picker');
                if (result != null && result is Map && mounted) {
                  setState(() {
                    _fullAddressCtrl.text = result['street'] ?? '';
                    _cityCtrl.text = result['city'] ?? '';
                    _stateCtrl.text = result['state'] ?? '';
                    _pincodeCtrl.text = result['pincode'] ?? '';
                    _latitude = result['latitude'];
                    _longitude = result['longitude'];
                    // Ensure a tag is ALWAYS selected (fallback to Home)
                    if (_selectedLabel.isEmpty) _selectedLabel = 'Home';
                  });
                  // FAST-TRACK: Automatically save and return to list after map pick
                  _saveAddress();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.accentGreen,
                      radius: 20,
                      child: const Icon(Icons.map_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pick from Map', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                          Text('Set your location for accurate delivery', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppColors.accentGreen),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Address Label',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 12),
            Row(
              children: _labels.map((lbl) {
                bool isSelected = _selectedLabel == lbl['name'];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedLabel = lbl['name']),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.accentGreen : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.accentGreen
                                      .withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                        border: Border.all(
                            color: isSelected
                                ? AppColors.accentGreen
                                : Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(lbl['icon'],
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              size: 26),
                          const SizedBox(height: 6),
                          Text(
                            lbl['name'],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            _buildInputField(
              controller: _fullAddressCtrl,
              label: 'Full Address',
              hint: 'Flat no, House no, Street name',
              icon: Icons.map_rounded,
              validator: (v) => v!.isEmpty ? 'Please enter your address' : null,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: _cityCtrl,
                    label: 'City',
                    hint: 'e.g. Lucknow',
                    icon: Icons.location_city_rounded,
                    validator: (v) => v!.isEmpty ? 'Field required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    controller: _pincodeCtrl,
                    label: 'Pincode',
                    hint: '123456',
                    icon: Icons.pin_drop_rounded,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v!.isEmpty) return 'Required';
                      if (!RegExp(r'^\d{6}$').hasMatch(v)) {
                        return 'Invalid (6 digits)';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _stateCtrl,
              label: 'State',
              hint: 'e.g. Uttar Pradesh',
              icon: Icons.holiday_village_rounded,
              validator: (v) => v!.isEmpty ? 'Please enter state' : null,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Set as default address',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                  Switch.adaptive(
                    value: _isDefault,
                    activeTrackColor:
                        AppColors.accentGreen.withValues(alpha: 0.5),
                    activeThumbColor: AppColors.accentGreen,
                    onChanged: (val) => setState(() => _isDefault = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        _editingAddress == null ? 'Save & Continue' : 'Update Address',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2D1F))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          validator: validator,
          cursorColor: AppColors.accentGreen,
          decoration: InputDecoration(
            counterText: '',
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.accentGreen, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(CartProvider cart) {
    final bool canProceed = cart.isDeliverable && !cart.isCalculatingDelivery;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cart.isCalculatingDelivery)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.blue)),
                    SizedBox(width: 10),
                    Text('Checking serviceability...',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          if (!cart.isDeliverable && !cart.isCalculatingDelivery && cart.selectedAddress != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Not Serviceable', 
                            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text(
                            cart.deliveryMessage.isEmpty ? 'This location is outside our delivery range.' : cart.deliveryMessage,
                            style: TextStyle(color: Colors.red.shade900, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: !canProceed ? null : () {
                final selected = cart.selectedAddress;
                if (selected == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a delivery address first.'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PaymentMethodPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: const Text(
                'Proceed to Payment',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutStepper extends StatelessWidget {
  final int currentStep;
  const _CheckoutStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStep(0, 'CART', true),
        _buildLine(true),
        _buildStep(1, 'ADDRESS', currentStep >= 1),
        _buildLine(currentStep >= 2),
        _buildStep(2, 'PAYMENT', currentStep >= 2),
      ],
    );
  }

  Widget _buildStep(int step, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isActive ? AppColors.accentGreen : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isActive
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text('${step + 1}',
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.accentGreen : Colors.grey.shade400,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      color: isActive ? AppColors.accentGreen : Colors.grey.shade200,
    );
  }
}
