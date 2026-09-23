import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../data/mock_reviews.dart';
import '../../../models/product.dart';
import '../../../models/product_review.dart';

class ProductReviewsWidget extends StatefulWidget {
  final Product product;

  const ProductReviewsWidget({super.key, required this.product});

  @override
  State<ProductReviewsWidget> createState() => _ProductReviewsWidgetState();
}

class _ProductReviewsWidgetState extends State<ProductReviewsWidget> {
  late List<ProductReview> _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = MockReviews.getReviewsForProduct(widget.product.id);
  }

  void _openWriteReviewModal() {
    double selectedStars = 5.0;
    final titleController = TextEditingController();
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Write a Review', style: AppTypography.headingMedium),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Text(
                  widget.product.name,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14),

                // Star Selector
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      final starVal = index + 1.0;
                      return IconButton(
                        icon: Icon(
                          starVal <= selectedStars
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: AppColors.ratingStar,
                          size: 32,
                        ),
                        onPressed: () {
                          setModalState(() {
                            selectedStars = starVal;
                          });
                        },
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  controller: titleController,
                  labelText: 'Headline / Summary',
                  hintText: 'e.g., Super fresh and fast delivery!',
                ),
                const SizedBox(height: 12),

                CustomTextField(
                  controller: commentController,
                  labelText: 'Your Experience',
                  hintText: 'Share your feedback on quality, packaging, and freshness...',
                  maxLines: 3,
                ),
                const SizedBox(height: 18),

                CustomButton(
                  text: 'Submit Review',
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    if (titleController.text.trim().isEmpty ||
                        commentController.text.trim().isEmpty) {
                      ToastUtils.showError(context, 'Please fill in both headline and review');
                      return;
                    }

                    final newReview = ProductReview(
                      id: 'rev-user-${DateTime.now().millisecondsSinceEpoch}',
                      productId: widget.product.id,
                      userName: 'You (Verified Buyer)',
                      userAvatarInitials: 'YO',
                      rating: selectedStars,
                      date: 'Just now',
                      title: titleController.text.trim(),
                      comment: commentController.text.trim(),
                      isVerifiedPurchase: true,
                      helpfulCount: 0,
                    );

                    setState(() {
                      _reviews.insert(0, newReview);
                    });

                    Navigator.pop(context);
                    ToastUtils.showSuccess(context, 'Thank you! Your verified review has been published.');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ratings & Reviews', style: AppTypography.headingSmall),
            TextButton.icon(
              icon: const Icon(Icons.rate_review_outlined, size: 16),
              label: const Text('Write Review'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w800),
              ),
              onPressed: _openWriteReviewModal,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Rating Overview Box with Distribution Bars
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              // Big Score
              Column(
                children: [
                  Text(
                    widget.product.rating.toStringAsFixed(1),
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return const Icon(Icons.star_rounded,
                          size: 16, color: AppColors.ratingStar);
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.product.reviewCount + _reviews.length - 3} verified ratings',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),

              // Breakdown Bars
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar('5★', 0.82),
                    _buildRatingBar('4★', 0.12),
                    _buildRatingBar('3★', 0.04),
                    _buildRatingBar('2★', 0.01),
                    _buildRatingBar('1★', 0.01),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // List of Customer Reviews
        ..._reviews.map((rev) => _buildReviewTile(rev)),
      ],
    );
  }

  Widget _buildRatingBar(String label, double ratio) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 6,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.ratingStar),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTile(ProductReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primarySubtle,
                    child: Text(
                      review.userAvatarInitials,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (review.isVerifiedPurchase)
                        Row(
                          children: [
                            const Icon(Icons.verified_rounded,
                                size: 12, color: AppColors.successDark),
                            const SizedBox(width: 3),
                            Text(
                              'Verified Purchaser',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.successDark,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              Text(
                review.date,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Rating Stars & Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.successDark,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Text(
                      review.rating.toStringAsFixed(0),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.star_rounded, size: 11, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  review.title,
                  style: AppTypography.labelMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Text(
            review.comment,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),

          // Helpful count button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    review.helpfulCount += 1;
                  });
                },
                child: Row(
                  children: [
                    const Icon(Icons.thumb_up_alt_outlined,
                        size: 13, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      'Helpful (${review.helpfulCount})',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
