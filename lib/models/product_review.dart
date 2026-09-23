class ProductReview {
  final String id;
  final String productId;
  final String userName;
  final String userAvatarInitials;
  final double rating;
  final String date;
  final String title;
  final String comment;
  final bool isVerifiedPurchase;
  int helpfulCount;

  ProductReview({
    required this.id,
    required this.productId,
    required this.userName,
    required this.userAvatarInitials,
    required this.rating,
    required this.date,
    required this.title,
    required this.comment,
    this.isVerifiedPurchase = true,
    this.helpfulCount = 0,
  });
}
