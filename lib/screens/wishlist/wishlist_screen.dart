import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/floating_cart_bar.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProvider>();
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.read<CartProvider>();

    final wishlistedProducts = wishlistProvider.getWishlistedProducts(productProvider.allProducts);

    if (wishlistedProducts.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('My Wishlist', style: AppTypography.headingLarge),
        ),
        body: EmptyStateView(
          icon: Icons.favorite_border_rounded,
          iconColor: AppColors.error,
          title: 'Your wishlist is waiting',
          description: 'Save your favorite products and essentials here for easy ordering anytime.',
          buttonText: 'Explore Products',
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
            Text('My Wishlist', style: AppTypography.headingMedium),
            Text(
              '${wishlistedProducts.length} saved ${wishlistedProducts.length == 1 ? 'item' : 'items'}',
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
              for (final p in wishlistedProducts) {
                cartProvider.addItem(p);
              }
              ToastUtils.showSuccess(context, 'All wishlist items added to cart!');
              Navigator.pushNamed(context, AppRoutes.cart);
            },
            child: Text(
              'ADD ALL TO CART',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 90),
            itemCount: wishlistedProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              return ProductCard(
                product: wishlistedProducts[index],
                width: double.infinity,
              );
            },
          ),
          const FloatingCartBar(bottomMargin: 16),
        ],
      ),
    );
  }
}
