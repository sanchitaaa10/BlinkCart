import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/coupon_provider.dart';

class CouponBottomSheet extends StatefulWidget {
  const CouponBottomSheet({super.key});

  @override
  State<CouponBottomSheet> createState() => _CouponBottomSheetState();
}

class _CouponBottomSheetState extends State<CouponBottomSheet> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final couponProvider = context.watch<CouponProvider>();
    final cartProvider = context.watch<CartProvider>();
    final coupons = couponProvider.availableCoupons;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Text('Apply Coupon Code', style: AppTypography.headingLarge),
              const SizedBox(height: 16),

              // Code Input & Apply Button Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _codeController,
                        textCapitalization: TextCapitalization.characters,
                        style: AppTypography.labelLarge.copyWith(letterSpacing: 1.0),
                        decoration: const InputDecoration(
                          hintText: 'ENTER CODE',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: 'APPLY',
                    width: 90,
                    height: 48,
                    onPressed: () {
                      final code = _codeController.text.trim();
                      if (code.isEmpty) return;
                      final match = couponProvider.getCouponByCode(code);
                      if (match == null) {
                        ToastUtils.showError(context, 'Invalid coupon code');
                      } else {
                        final success = cartProvider.applyCoupon(match);
                        if (success) {
                          ToastUtils.showSuccess(context, 'Coupon "${match.code}" applied!');
                          Navigator.pop(context);
                        } else {
                          ToastUtils.showError(
                            context,
                            'Add items worth ₹${(match.minOrderAmount - cartProvider.itemTotal).toInt()} more to apply this coupon',
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text('Available Offers', style: AppTypography.headingSmall),
              const SizedBox(height: 12),

              // Coupons List
              ...coupons.map((c) {
                final isApplied = cartProvider.appliedCoupon?.code == c.code;
                final isEligible = cartProvider.itemTotal >= c.minOrderAmount;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isApplied ? AppColors.primarySubtle.withValues(alpha: 0.5) : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isApplied ? AppColors.primary : AppColors.border,
                      width: isApplied ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              c.code,
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          if (isApplied)
                            TextButton(
                              onPressed: () {
                                cartProvider.removeCoupon();
                                ToastUtils.showInfo(context, 'Coupon removed');
                              },
                              child: Text(
                                'REMOVE',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            )
                          else
                            TextButton(
                              onPressed: () {
                                final success = cartProvider.applyCoupon(c);
                                if (success) {
                                  ToastUtils.showSuccess(context, 'Coupon "${c.code}" applied!');
                                  Navigator.pop(context);
                                } else {
                                  ToastUtils.showError(
                                    context,
                                    'Add items worth ₹${(c.minOrderAmount - cartProvider.itemTotal).toInt()} more to use this coupon',
                                  );
                                }
                              },
                              child: Text(
                                isEligible ? 'APPLY' : 'LOCKED',
                                style: AppTypography.labelSmall.copyWith(
                                  color: isEligible ? AppColors.primary : AppColors.textTertiary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        c.title,
                        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        c.description,
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
