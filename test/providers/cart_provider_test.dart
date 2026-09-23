import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blinkcart/providers/cart_provider.dart';
import 'package:blinkcart/data/mock_products.dart';
import 'package:blinkcart/models/coupon.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CartProvider Tests', () {
    late CartProvider cartProvider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      cartProvider = CartProvider();
    });

    test('Initial cart is empty', () {
      expect(cartProvider.isEmpty, isTrue);
      expect(cartProvider.totalItemCount, equals(0));
      expect(cartProvider.itemTotal, equals(0.0));
    });

    test('Add item increments count and computes total', () {
      final product = MockProducts.products[0];
      cartProvider.addItem(product);

      expect(cartProvider.totalItemCount, equals(1));
      expect(cartProvider.getProductQuantity(product.id), equals(1));
      expect(cartProvider.itemTotal, equals(product.price));

      cartProvider.increaseQuantity(product.id);
      expect(cartProvider.getProductQuantity(product.id), equals(2));
      expect(cartProvider.itemTotal, equals(product.price * 2));
    });

    test('Decrease quantity removes item when reaching 0', () {
      final product = MockProducts.products[0];
      cartProvider.addItem(product);
      expect(cartProvider.getProductQuantity(product.id), equals(1));

      cartProvider.decreaseQuantity(product.id);
      expect(cartProvider.getProductQuantity(product.id), equals(0));
      expect(cartProvider.isEmpty, isTrue);
    });

    test('Coupons apply discounts correctly', () {
      final product = MockProducts.products[0]; // Bananas ₹49
      for (int i = 0; i < 10; i++) {
        cartProvider.addItem(product); // ₹490 total
      }

      final coupon = Coupon(
        code: 'TEST50',
        title: '₹50 OFF',
        description: 'Test coupon',
        discountAmount: 50.0,
        minOrderAmount: 200.0,
        expiryDate: DateTime.now().add(const Duration(days: 5)),
      );

      final applied = cartProvider.applyCoupon(coupon);
      expect(applied, isTrue);
      expect(cartProvider.couponDiscount, equals(50.0));
      expect(cartProvider.finalTotal, equals(490.0 - 50.0 + cartProvider.deliveryFee + CartProvider.handlingFee));
    });
  });
}
