import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_typography.dart';
import '../core/utils/formatters.dart';
import '../core/routes/app_routes.dart';
import '../core/widgets/product_artwork.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import 'quantity_selector.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double width;
  final bool isHorizontal;

  const ProductCard({
    super.key,
    required this.product,
    this.width = 158,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();
    final isWishlisted = wishlistProvider.isWishlisted(product.id);
    final quantity = cartProvider.getProductQuantity(product.id);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productDetail,
          arguments: product,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Image Box with Wishlist & Discount Badge
            Stack(
              children: [
                ProductArtwork(
                  category: product.category,
                  productName: product.name,
                  height: 98,
                  borderRadius: 12,
                ),
                // Gradient Discount Badge
                if (product.hasDiscount)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00A859), Color(0xFF00C853)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00A859).withValues(alpha: 0.35),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        '${product.discountPercentage}% OFF',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 9,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                // Wishlist Heart Button
                Positioned(
                  top: 5,
                  right: 5,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        wishlistProvider.toggleWishlist(product.id);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 15,
                          color: isWishlisted ? AppColors.error : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),

            // Delivery speed pill & Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 10 MINS tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.primarySubtle,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded, size: 10, color: AppColors.primary),
                      const SizedBox(width: 1),
                      Text(
                        '10 MINS',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 8.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 12, color: AppColors.ratingStar),
                    const SizedBox(width: 1),
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Product Name
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyLarge.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                height: 1.25,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),

            // Unit
            Text(
              product.unit,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10.5,
              ),
            ),
            const SizedBox(height: 6),

            // Price & Add Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Price section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Formatters.formatCurrency(product.price),
                      style: AppTypography.priceMain.copyWith(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (product.hasDiscount)
                      Text(
                        Formatters.formatCurrency(product.originalPrice),
                        style: AppTypography.priceOriginal.copyWith(fontSize: 10.5),
                      ),
                  ],
                ),
                // Animated Quantity Selector
                QuantitySelector(
                  quantity: quantity,
                  height: 30,
                  width: 70,
                  isCompact: true,
                  onAdd: () => cartProvider.addItem(product),
                  onIncrease: () => cartProvider.increaseQuantity(product.id),
                  onDecrease: () => cartProvider.decreaseQuantity(product.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
