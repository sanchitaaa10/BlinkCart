class Coupon {
  final String code;
  final String title;
  final String description;
  final double discountAmount;
  final double discountPercentage;
  final double minOrderAmount;
  final double maxDiscountAmount;
  final DateTime expiryDate;

  const Coupon({
    required this.code,
    required this.title,
    required this.description,
    this.discountAmount = 0,
    this.discountPercentage = 0,
    required this.minOrderAmount,
    this.maxDiscountAmount = 500,
    required this.expiryDate,
  });

  double calculateDiscount(double orderTotal) {
    if (orderTotal < minOrderAmount) return 0;
    if (discountAmount > 0) {
      return discountAmount;
    }
    if (discountPercentage > 0) {
      final calculated = (orderTotal * discountPercentage) / 100;
      return calculated > maxDiscountAmount ? maxDiscountAmount : calculated;
    }
    return 0;
  }
}
