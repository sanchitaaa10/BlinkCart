import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/toast_utils.dart';
import '../../providers/order_provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final liveOrder = orderProvider.getOrderById(order.id) ?? order;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Track Order #${liveOrder.id}', style: AppTypography.headingMedium),
            Row(
              children: [
                const Icon(Icons.bolt_rounded, size: 14, color: AppColors.accent),
                Text(
                  'Estimated Delivery: ${liveOrder.estimatedDeliveryMinutes} mins',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.primary),
            onPressed: () {
              ToastUtils.showInfo(context, 'BlinkCart 24/7 Support: Connected');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Illustrated Mock Live Route Map with Glowing Gradient
            Container(
              height: 190,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFEDE7F6),
                    Color(0xFFE1F5FE),
                    Color(0xFFE8F5E9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Stylized Map Grid Lines
                  CustomPaint(
                    size: const Size(double.infinity, 190),
                    painter: _MapRoutePainter(),
                  ),
                  // Dark store pin
                  Positioned(
                    left: 40,
                    top: 50,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: AppColors.glowShadow(AppColors.primary, blur: 8, opacity: 0.3),
                          ),
                          child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 18),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4),
                            ],
                          ),
                          child: Text(
                            'Dark Store',
                            style: AppTypography.labelSmall.copyWith(fontSize: 9.5, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Rider Moving Pin
                  Positioned(
                    left: 165,
                    top: 60,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            gradient: AppColors.flashGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.45),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 22),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4),
                            ],
                          ),
                          child: Text(
                            'Rahul (${liveOrder.estimatedDeliveryMinutes}m away)',
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 9.5,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Customer Destination Pin
                  Positioned(
                    right: 40,
                    top: 50,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            gradient: AppColors.savingsGradient,
                            shape: BoxShape.circle,
                            boxShadow: AppColors.glowShadow(AppColors.success, blur: 8, opacity: 0.3),
                          ),
                          child: const Icon(Icons.home_rounded, color: Colors.white, size: 18),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4),
                            ],
                          ),
                          child: Text(
                            'Your Home',
                            style: AppTypography.labelSmall.copyWith(fontSize: 9.5, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // OTP Badge
            Container(
              margin: const EdgeInsets.only(left: 14, right: 14, top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE68A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.vpn_key_rounded,
                      size: 20,
                      color: Color(0xFFB45309),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DELIVERY OTP: 4921',
                          style: AppTypography.labelLarge.copyWith(
                            color: const Color(0xFFB45309),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          'Share only with your delivery partner upon package handover.',
                          style: AppTypography.bodySmall.copyWith(
                            color: const Color(0xFF92400E),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Delivery Partner Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.delivery_dining_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Partner',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          liveOrder.deliveryPartnerName,
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: AppColors.ratingStar),
                            const SizedBox(width: 2),
                            Text(
                              liveOrder.deliveryPartnerRating.toString(),
                              style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '• Vaccinated & Masked',
                              style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.successDark),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Call & Message Buttons
                  IconButton.filledTonal(
                    icon: const Icon(Icons.call_rounded, size: 18, color: AppColors.primary),
                    onPressed: () {
                      ToastUtils.showInfo(context, 'Calling ${liveOrder.deliveryPartnerName} (${liveOrder.deliveryPartnerPhone})...');
                    },
                  ),
                  const SizedBox(width: 6),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.message_rounded, size: 18, color: AppColors.primary),
                    onPressed: () {
                      ToastUtils.showInfo(context, 'Chat opened with delivery partner');
                    },
                  ),
                ],
              ),
            ),

            // Live Timeline Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live Order Status', style: AppTypography.headingSmall),
                  const SizedBox(height: 20),
                  _buildTimelineStep(
                    title: 'Order Placed',
                    subtitle: 'We have received your order',
                    isCompleted: _isStepDone(liveOrder.status, 0),
                    isCurrent: liveOrder.status == OrderStatus.placed,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Order Confirmed',
                    subtitle: 'Store acknowledged and items queued',
                    isCompleted: _isStepDone(liveOrder.status, 1),
                    isCurrent: liveOrder.status == OrderStatus.confirmed,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Picking Your Items',
                    subtitle: 'Fresh items picked and hygienically packed',
                    isCompleted: _isStepDone(liveOrder.status, 2),
                    isCurrent: liveOrder.status == OrderStatus.picking,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Out for Delivery',
                    subtitle: 'Rider is on the way to ${liveOrder.deliveryAddress.streetArea}',
                    isCompleted: _isStepDone(liveOrder.status, 3),
                    isCurrent: liveOrder.status == OrderStatus.outForDelivery,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Delivered',
                    subtitle: 'Order delivered to your doorstep',
                    isCompleted: _isStepDone(liveOrder.status, 4),
                    isCurrent: liveOrder.status == OrderStatus.delivered,
                    isLast: true,
                  ),
                ],
              ),
            ),

            // Ordered Items Summary
            Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Items in this order', style: AppTypography.headingSmall),
                      Text('${liveOrder.totalItemCount} items', style: AppTypography.bodySmall),
                    ],
                  ),
                  const Divider(height: 20),
                  ...liveOrder.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x  ${item.product.name}',
                              style: AppTypography.bodyMedium,
                            ),
                          ),
                          Text(
                            '₹${item.totalPrice.toInt()}',
                            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  bool _isStepDone(OrderStatus status, int stepIndex) {
    const order = [
      OrderStatus.placed,
      OrderStatus.confirmed,
      OrderStatus.picking,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];
    final currentIndex = order.indexOf(status);
    return currentIndex >= stepIndex;
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    final color = isCompleted
        ? AppColors.success
        : (isCurrent ? AppColors.primary : AppColors.border);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indicator circle + vertical line
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.success : (isCurrent ? AppColors.primary : Colors.white),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
                boxShadow: isCurrent ? AppColors.glowShadow(AppColors.primary, blur: 6) : null,
              ),
              child: isCompleted
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : (isCurrent
                      ? const Center(
                          child: SizedBox(
                            width: 8,
                            height: 8,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                        )
                      : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 38,
                color: isCompleted ? AppColors.success : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 14),
        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: (isCompleted || isCurrent) ? FontWeight.w900 : FontWeight.w500,
                  color: (isCompleted || isCurrent) ? AppColors.textPrimary : AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.7)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(40, 70)
      ..quadraticBezierTo(size.width * 0.35, 125, size.width * 0.55, 75)
      ..quadraticBezierTo(size.width * 0.75, 35, size.width - 40, 70);

    canvas.drawPath(path, roadPaint);
    canvas.drawPath(path, dashPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
