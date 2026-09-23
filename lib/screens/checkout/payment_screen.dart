import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../providers/cart_provider.dart';
import '../../providers/address_provider.dart';
import '../../providers/order_provider.dart';

class PaymentScreen extends StatefulWidget {
  final String initialPaymentMethod;

  const PaymentScreen({
    super.key,
    this.initialPaymentMethod = 'UPI (Google Pay)',
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String _selectedMethod;
  bool _isProcessing = false;

  final TextEditingController _cardNumberController = TextEditingController(text: '4532 •••• •••• 8892');
  final TextEditingController _cardHolderController = TextEditingController(text: 'Sanchita S');
  final TextEditingController _cardExpiryController = TextEditingController(text: '08/29');
  final TextEditingController _cardCvvController = TextEditingController(text: '342');
  final TextEditingController _upiIdController = TextEditingController(text: 'sanchita@oksbi');

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.initialPaymentMethod;
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(milliseconds: 1600));

    if (!mounted) return;

    final cart = context.read<CartProvider>();
    final address = context.read<AddressProvider>().selectedAddress;
    final orderProvider = context.read<OrderProvider>();

    final createdOrder = orderProvider.createOrder(
      items: cart.itemsList,
      itemTotal: cart.itemTotal,
      discountAmount: cart.couponDiscount,
      deliveryFee: cart.deliveryFee,
      handlingFee: CartProvider.handlingFee,
      tipAmount: cart.tipAmount,
      finalTotal: cart.finalTotal,
      couponCode: cart.appliedCoupon?.code ?? '',
      deliveryAddress: address,
      paymentMethod: _selectedMethod,
    );

    cart.clearCart();

    setState(() {
      _isProcessing = false;
    });

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.orderSuccess,
      (route) => route.isFirst,
      arguments: createdOrder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Select Payment Method', style: AppTypography.headingLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount to Pay Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Payable Amount',
                        style: AppTypography.labelMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.formatCurrency(cart.finalTotal),
                        style: AppTypography.displayLarge.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.shield_outlined, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '100% Secure',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // UPI Apps Section
            Text('UPI Payments', style: AppTypography.headingSmall),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _buildPaymentOptionTile(
                    title: 'Google Pay',
                    subtitle: 'Fast and secure UPI payment',
                    icon: Icons.g_mobiledata_rounded,
                    iconColor: const Color(0xFF1EA362),
                    methodKey: 'UPI (Google Pay)',
                  ),
                  const Divider(height: 1),
                  _buildPaymentOptionTile(
                    title: 'PhonePe',
                    subtitle: 'Pay directly via UPI',
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: const Color(0xFF5F259F),
                    methodKey: 'UPI (PhonePe)',
                  ),
                  const Divider(height: 1),
                  _buildPaymentOptionTile(
                    title: 'Paytm UPI',
                    subtitle: 'Pay using linked bank account',
                    icon: Icons.payment_rounded,
                    iconColor: const Color(0xFF00BAF2),
                    methodKey: 'UPI (Paytm)',
                  ),
                  const Divider(height: 1),
                  _buildPaymentOptionTile(
                    title: 'Other UPI ID',
                    subtitle: 'Enter VPA / UPI ID',
                    icon: Icons.bolt_rounded,
                    iconColor: AppColors.primary,
                    methodKey: 'UPI (Custom)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cards Section
            Text('Credit / Debit Cards', style: AppTypography.headingSmall),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _buildPaymentOptionTile(
                    title: 'Credit / Debit Card',
                    subtitle: 'Visa, MasterCard, RuPay & more',
                    icon: Icons.credit_card_rounded,
                    iconColor: const Color(0xFF1E3A8A),
                    methodKey: 'Credit / Debit Card',
                  ),
                  if (_selectedMethod == 'Credit / Debit Card')
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _cardNumberController,
                            labelText: 'Card Number',
                            prefixIcon: const Icon(Icons.credit_card),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _cardExpiryController,
                                  labelText: 'Expiry (MM/YY)',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  controller: _cardCvvController,
                                  labelText: 'CVV',
                                  obscureText: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _cardHolderController,
                            labelText: 'Cardholder Name',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Other Methods
            Text('More Payment Options', style: AppTypography.headingSmall),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                children: [
                  _buildPaymentOptionTile(
                    title: 'BlinkCart Wallet',
                    subtitle: 'Available balance: ₹420',
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.primary,
                    methodKey: 'BlinkCart Wallet',
                  ),
                  const Divider(height: 1),
                  _buildPaymentOptionTile(
                    title: 'Cash on Delivery (COD)',
                    subtitle: 'Pay cash or QR at your doorstep',
                    icon: Icons.payments_outlined,
                    iconColor: const Color(0xFF059669),
                    methodKey: 'Cash on Delivery',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.borderLight)),
        ),
        child: SafeArea(
          child: CustomButton(
            text: _isProcessing ? 'Processing Secure Payment...' : 'Pay ${Formatters.formatCurrency(cart.finalTotal)}',
            isLoading: _isProcessing,
            backgroundColor: AppColors.primary,
            height: AppDimensions.buttonHeightLg,
            onPressed: _isProcessing ? null : _processPayment,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOptionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String methodKey,
  }) {
    final isSelected = _selectedMethod == methodKey;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = methodKey;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
