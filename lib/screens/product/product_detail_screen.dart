import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/product_artwork.dart';
import '../../core/widgets/rating_badge.dart';
import '../../core/widgets/custom_button.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/quantity_selector.dart';
import '../../widgets/product_card.dart';
import 'widgets/product_reviews_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();
    final productProvider = context.watch<ProductProvider>();

    final quantity = cartProvider.getProductQuantity(product.id);
    final isWishlisted = wishlistProvider.isWishlisted(product.id);
    final recommended = productProvider.getRecommendedProducts(product);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isWishlisted ? AppColors.error : AppColors.textPrimary,
            ),
            onPressed: () {
              wishlistProvider.toggleWishlist(product.id);
              ToastUtils.showInfo(
                context,
                isWishlisted ? 'Removed from Wishlist' : 'Added to Wishlist',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ToastUtils.showInfo(context, 'Link copied to clipboard');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Large Image Artwork Showcase with Ambient Aura
            Container(
              height: 250,
              width: double.infinity,
              color: AppColors.background,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ProductArtwork(
                    category: product.category,
                    productName: product.name,
                    height: 250,
                    width: double.infinity,
                    borderRadius: 0,
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00A859), Color(0xFF00C853)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00A859).withValues(alpha: 0.35),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${product.discountPercentage}% OFF',
                          style: AppTypography.labelMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand & Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.brand.toUpperCase(),
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      RatingBadge(
                        rating: product.rating,
                        reviewCount: product.reviewCount,
                        size: 13,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Product Title
                  Text(
                    product.name,
                    style: AppTypography.displayMedium.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Unit
                  Text(
                    product.unit,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Price Row with Savings Tag
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        Formatters.formatCurrency(product.price),
                        style: AppTypography.displayLarge.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          Formatters.formatCurrency(product.originalPrice),
                          style: AppTypography.priceOriginal.copyWith(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.successSubtle,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Save ${Formatters.formatCurrency(product.savingsAmount)}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.successDark,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Delivery Time Guarantee Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primarySubtle,
                          const Color(0xFFF3E5F5).withValues(alpha: 0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delivery in 10–20 minutes',
                                style: AppTypography.labelLarge.copyWith(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Delivered fresh from your local dark store in Kharghar',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 3 Key Quality Trust Cards
                  Row(
                    children: [
                      _buildTrustCard(Icons.eco_rounded, AppColors.success, '100% Fresh', 'Guaranteed Quality'),
                      const SizedBox(width: 8),
                      _buildTrustCard(Icons.bolt_rounded, AppColors.accent, 'Instant Dispatch', 'Packed in 2 mins'),
                      const SizedBox(width: 8),
                      _buildTrustCard(Icons.ac_unit_rounded, AppColors.primary, 'Cold Chain', 'Temp controlled'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text('Description', style: AppTypography.headingSmall),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Product Highlights
                  if (product.highlights.isNotEmpty) ...[
                    Text('Highlights', style: AppTypography.headingSmall),
                    const SizedBox(height: 8),
                    ...product.highlights.map((h) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2, right: 8),
                                child: Icon(Icons.check_circle_rounded, size: 15, color: AppColors.success),
                              ),
                              Expanded(
                                child: Text(
                                  h,
                                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 16),
                  ],

                  // Specifications Table
                  if (product.specifications.isNotEmpty) ...[
                    Text('Specifications', style: AppTypography.headingSmall),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: product.specifications.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: Text(
                                    entry.key,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Recommended / Frequently Bought Together
                  if (recommended.isNotEmpty) ...[
                    Text('You Might Also Like', style: AppTypography.headingSmall),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommended.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: recommended[index],
                            width: 154,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Verified Customer Ratings & Reviews Breakdown
                  ProductReviewsWidget(product: product),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const SizedBox(height: 80),
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
              // Quantity stepper or ADD
              if (quantity > 0)
                QuantitySelector(
                  quantity: quantity,
                  height: 48,
                  width: 110,
                  isCompact: false,
                  onAdd: () => cartProvider.addItem(product),
                  onIncrease: () => cartProvider.increaseQuantity(product.id),
                  onDecrease: () => cartProvider.decreaseQuantity(product.id),
                )
              else
                Expanded(
                  child: CustomButton(
                    text: 'Add to Cart',
                    icon: Icons.shopping_bag_outlined,
                    isOutlined: true,
                    onPressed: () {
                      cartProvider.addItem(product);
                      ToastUtils.showSuccess(context, '${product.name} added to cart');
                    },
                  ),
                ),
              const SizedBox(width: 12),
              // Buy Now CTA
              Expanded(
                child: CustomButton(
                  text: 'View Cart',
                  icon: Icons.arrow_forward_rounded,
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    if (quantity == 0) {
                      cartProvider.addItem(product);
                    }
                    Navigator.pushNamed(context, AppRoutes.cart);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustCard(IconData icon, Color iconColor, String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textTertiary, fontSize: 9.5),
            ),
          ],
        ),
      ),
    );
  }
}
