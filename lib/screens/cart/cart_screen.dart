import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/product_artwork.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/quantity_selector.dart';
import 'widgets/coupon_bottom_sheet.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _selectedInstruction = 'Leave at door';

  final List<String> _deliveryInstructions = [
    'Leave at door',
    'Don\'t ring bell',
    'Avoid calling',
    'Leave with guard',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.itemsList;

    if (cart.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Your Cart', style: AppTypography.headingLarge),
        ),
        body: EmptyStateView(
          icon: Icons.shopping_basket_outlined,
          title: 'Your cart is empty',
          description: 'Looks like you haven\'t added anything yet.\nExplore our fresh products and lightning 10-minute delivery!',
          buttonText: 'Start Shopping',
          onButtonPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Cart', style: AppTypography.headingMedium),
            Text(
              '${cart.totalItemCount} ${cart.totalItemCount == 1 ? 'item' : 'items'} in basket',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              cart.clearCart();
            },
            child: Text(
              'Clear',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Express Delivery Time Announcement Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primarySubtle,
                    const Color(0xFFF3E5F5).withValues(alpha: 0.4),
                  ],
                ),
                border: const Border(
                  bottom: BorderSide(color: AppColors.borderLight),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Delivery in 10–20 minutes to Kharghar',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),

            // Free Delivery Progress Bar
            if (cart.itemTotal < CartProvider.freeDeliveryThreshold) ...[
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_shipping_outlined, size: 18, color: AppColors.accent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Add items worth ${Formatters.formatCurrency(CartProvider.freeDeliveryThreshold - cart.itemTotal)} more for FREE Delivery',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (cart.itemTotal / CartProvider.freeDeliveryThreshold).clamp(0.0, 1.0),
                        backgroundColor: AppColors.borderLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                        minHeight: 7,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Savings Celebration Card (If Saving)
            if (cart.totalSavings > 0)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00A859), Color(0xFF00C853)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00A859).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.celebration_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SAVINGS CELEBRATION',
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w900,
                              fontSize: 9,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'You\'re saving ${Formatters.formatCurrency(cart.totalSavings)} on this order!',
                            style: AppTypography.labelLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Cart Items List
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(14),
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(height: 22, color: AppColors.borderLight),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final product = item.product;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Mini Product Artwork
                      ProductArtwork(
                        category: product.category,
                        productName: product.name,
                        height: 58,
                        width: 58,
                        borderRadius: 10,
                      ),
                      const SizedBox(width: 12),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.labelLarge.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              product.unit,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  Formatters.formatCurrency(product.price),
                                  style: AppTypography.labelLarge.copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                                if (product.hasDiscount) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    Formatters.formatCurrency(product.originalPrice),
                                    style: AppTypography.priceOriginal.copyWith(fontSize: 11),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Stepper
                      QuantitySelector(
                        quantity: item.quantity,
                        height: 32,
                        width: 78,
                        onAdd: () => cart.addItem(product),
                        onIncrease: () => cart.increaseQuantity(product.id),
                        onDecrease: () => cart.decreaseQuantity(product.id),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Coupons & Offers Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppColors.accentSubtle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.discount_outlined, color: AppColors.accent, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: cart.appliedCoupon != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Coupon "${cart.appliedCoupon!.code}" applied',
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.successDark,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'You save ${Formatters.formatCurrency(cart.couponDiscount)} on this order',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Apply Coupon Code',
                                style: AppTypography.labelLarge.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Save more with FIRST100, SAVE50, etc.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const CouponBottomSheet(),
                      );
                    },
                    child: Text(
                      cart.appliedCoupon != null ? 'CHANGE' : 'VIEW OFFERS',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tip Delivery Partner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.favorite_rounded, color: AppColors.error, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Tip your delivery partner',
                        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '100% of the tip goes directly to your delivery partner.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [0.0, 10.0, 20.0, 30.0].map((tip) {
                      final isSelected = cart.tipAmount == tip;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(tip == 0.0 ? 'No Tip' : '₹${tip.toInt()}'),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.background,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11.5,
                          ),
                          onSelected: (_) {
                            cart.setTip(tip);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Delivery Instructions
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Instructions',
                    style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _deliveryInstructions.map((inst) {
                      final isSelected = _selectedInstruction == inst;
                      return ChoiceChip(
                        label: Text(inst),
                        selected: isSelected,
                        selectedColor: AppColors.primarySubtle,
                        backgroundColor: AppColors.background,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedInstruction = selected ? inst : '';
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Bill Summary
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bill Summary', style: AppTypography.headingSmall),
                  const SizedBox(height: 12),
                  _buildBillRow('Item Total', Formatters.formatCurrency(cart.itemTotal)),
                  _buildBillRow(
                    'Delivery Fee',
                    cart.deliveryFee == 0 ? 'FREE' : Formatters.formatCurrency(cart.deliveryFee),
                    isGreen: cart.deliveryFee == 0,
                  ),
                  _buildBillRow('Handling Fee', Formatters.formatCurrency(CartProvider.handlingFee)),
                  if (cart.couponDiscount > 0)
                    _buildBillRow(
                      'Coupon Discount',
                      '-${Formatters.formatCurrency(cart.couponDiscount)}',
                      isGreen: true,
                    ),
                  if (cart.tipAmount > 0)
                    _buildBillRow('Delivery Tip', Formatters.formatCurrency(cart.tipAmount)),
                  const Divider(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'To Pay',
                        style: AppTypography.headingMedium.copyWith(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        Formatters.formatCurrency(cart.finalTotal),
                        style: AppTypography.displayMedium.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Price Total Column
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    Formatters.formatCurrency(cart.finalTotal),
                    style: AppTypography.displayMedium.copyWith(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // Proceed to Checkout CTA
              Expanded(
                child: CustomButton(
                  text: 'Proceed to Checkout',
                  icon: Icons.arrow_forward_rounded,
                  backgroundColor: AppColors.primary,
                  height: AppDimensions.buttonHeightLg,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pushNamed(context, AppRoutes.checkout);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(
            value,
            style: AppTypography.labelLarge.copyWith(
              color: isGreen ? AppColors.successDark : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
