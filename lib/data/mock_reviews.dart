import '../models/product_review.dart';

class MockReviews {
  static List<ProductReview> getReviewsForProduct(String productId) {
    return [
      ProductReview(
        id: 'rev-$productId-1',
        productId: productId,
        userName: 'Pooja Sharma',
        userAvatarInitials: 'PS',
        rating: 5.0,
        date: '2 days ago',
        title: 'Super fresh and delivered in 11 minutes!',
        comment: 'I ordered this in the morning and it arrived chilled and securely packed. Quality is top-notch, definitely ordering again on BlinkCart.',
        isVerifiedPurchase: true,
        helpfulCount: 24,
      ),
      ProductReview(
        id: 'rev-$productId-2',
        productId: productId,
        userName: 'Rohan Mehta',
        userAvatarInitials: 'RM',
        rating: 5.0,
        date: '4 days ago',
        title: 'Great packaging and authentic product',
        comment: 'Very satisfied with the seal and freshness date. Sourced directly and arrived in perfect shape.',
        isVerifiedPurchase: true,
        helpfulCount: 15,
      ),
      ProductReview(
        id: 'rev-$productId-3',
        productId: productId,
        userName: 'Ananya Deshmukh',
        userAvatarInitials: 'AD',
        rating: 4.0,
        date: '1 week ago',
        title: 'Good value for money',
        comment: 'Nice quality product at a reasonable price compared to regular stores. The 10-min delivery is super convenient.',
        isVerifiedPurchase: true,
        helpfulCount: 9,
      ),
    ];
  }
}
