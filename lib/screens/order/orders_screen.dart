import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../providers/cart_provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final cartProvider = context.read<CartProvider>();
    final orders = orderProvider.orders;

    if (orders.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('My Orders', style: AppTypography.headingLarge),
        ),
        body: EmptyStateView(
          icon: Icons.receipt_long_outlined,
          title: 'No orders yet',
          description: 'Your first order is just a few taps away. Explore daily essentials now!',
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
        title: Text('My Orders', style: AppTypography.headingLarge),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final order = orders[index];
          final isDelivered = order.status == OrderStatus.delivered;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Order ID, Status, Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id}',
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Formatters.formatDateTime(order.createdAt),
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDelivered ? AppColors.successSubtle : AppColors.primarySubtle,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        order.statusDisplay,
                        style: AppTypography.labelSmall.copyWith(
                          color: isDelivered ? AppColors.successDark : AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),

                // Items preview
                Text(
                  '${order.totalItemCount} items: ${order.items.map((e) => e.product.name).take(3).join(', ')}${order.items.length > 3 ? '...' : ''}',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),

                // Price & Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Formatters.formatCurrency(order.finalTotal),
                      style: AppTypography.headingSmall.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    Row(
                      children: [
                        // View Details
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.orderDetail,
                              arguments: order,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(0, 34),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 8),
                        // Buy Again
                        ElevatedButton(
                          onPressed: () {
                            for (final item in order.items) {
                              cartProvider.addItem(item.product);
                            }
                            ToastUtils.showSuccess(context, 'Items added to your cart');
                            Navigator.pushNamed(context, AppRoutes.cart);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            minimumSize: const Size(0, 34),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Buy Again', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
