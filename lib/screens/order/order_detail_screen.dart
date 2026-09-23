import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/cart_provider.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order #${order.id}', style: AppTypography.headingLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.successSubtle,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.statusDisplay,
                          style: AppTypography.headingSmall.copyWith(
                            color: AppColors.successDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          Formatters.formatDateTime(order.createdAt),
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (order.status != OrderStatus.delivered)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.orderTracking,
                          arguments: order,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: const Size(0, 32),
                      ),
                      child: const Text('Track', style: TextStyle(fontSize: 11, color: Colors.white)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Delivery Partner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delivered by', style: AppTypography.bodySmall),
                        Text(
                          order.deliveryPartnerName,
                          style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: AppColors.ratingStar),
                      const SizedBox(width: 2),
                      Text(
                        order.deliveryPartnerRating.toString(),
                        style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Items List
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Items Ordered (${order.totalItemCount})', style: AppTypography.headingSmall),
                  const Divider(height: 20),
                  ...order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${item.quantity}x',
                              style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  item.product.unit,
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            Formatters.formatCurrency(item.totalPrice),
                            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Delivery Address
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text('Delivery Address', style: AppTypography.headingSmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${order.deliveryAddress.tagLabel} - ${order.deliveryAddress.fullName}',
                    style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    order.deliveryAddress.formattedAddress,
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Bill & Payment
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Details', style: AppTypography.headingSmall),
                  const SizedBox(height: 12),
                  _buildDetailRow('Payment Mode', order.paymentMethod),
                  _buildDetailRow('Item Total', Formatters.formatCurrency(order.itemTotal)),
                  if (order.discountAmount > 0)
                    _buildDetailRow('Discount', '-${Formatters.formatCurrency(order.discountAmount)}', isGreen: true),
                  _buildDetailRow('Delivery Fee', order.deliveryFee == 0 ? 'FREE' : Formatters.formatCurrency(order.deliveryFee)),
                  _buildDetailRow('Handling Fee', Formatters.formatCurrency(order.handlingFee)),
                  if (order.tipAmount > 0)
                    _buildDetailRow('Tip', Formatters.formatCurrency(order.tipAmount)),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Paid', style: AppTypography.headingMedium.copyWith(fontWeight: FontWeight.w800)),
                      Text(
                        Formatters.formatCurrency(order.finalTotal),
                        style: AppTypography.displayMedium.copyWith(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reorder Button
            CustomButton(
              text: 'Repeat this Order',
              icon: Icons.replay_rounded,
              backgroundColor: AppColors.primary,
              onPressed: () {
                for (final item in order.items) {
                  cart.addItem(item.product);
                }
                ToastUtils.showSuccess(context, 'Items added to your cart');
                Navigator.pushNamed(context, AppRoutes.cart);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(
            value,
            style: AppTypography.labelLarge.copyWith(
              color: isGreen ? AppColors.successDark : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
