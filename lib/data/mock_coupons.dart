import '../models/coupon.dart';

class MockCoupons {
  static final List<Coupon> coupons = [
    Coupon(
      code: 'FIRST100',
      title: 'Flat ₹100 OFF',
      description: '₹100 discount on your first BlinkCart order',
      discountAmount: 100.0,
      minOrderAmount: 499.0,
      expiryDate: DateTime.now().add(const Duration(days: 30)),
    ),
    Coupon(
      code: 'SAVE50',
      title: 'Flat ₹50 OFF',
      description: '₹50 savings on daily essentials and groceries',
      discountAmount: 50.0,
      minOrderAmount: 399.0,
      expiryDate: DateTime.now().add(const Duration(days: 15)),
    ),
    Coupon(
      code: 'QUICK20',
      title: '20% OFF up to ₹100',
      description: 'Enjoy 20% discount on entire cart',
      discountPercentage: 20.0,
      minOrderAmount: 249.0,
      maxDiscountAmount: 100.0,
      expiryDate: DateTime.now().add(const Duration(days: 10)),
    ),
    Coupon(
      code: 'WEEKEND',
      title: 'Flat ₹75 OFF',
      description: 'Special weekend treat for orders above ₹599',
      discountAmount: 75.0,
      minOrderAmount: 599.0,
      expiryDate: DateTime.now().add(const Duration(days: 7)),
    ),
  ];
}
