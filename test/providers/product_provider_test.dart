import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blinkcart/providers/product_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProductProvider Tests', () {
    late ProductProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = ProductProvider();
    });

    test('Loads categories and products properly', () {
      expect(provider.categories.length, equals(14));
      expect(provider.allProducts.length, greaterThanOrEqualTo(40));
    });

    test('Search products by keyword returns matching results', () {
      final results = provider.searchProducts('milk');
      expect(results, isNotEmpty);
      expect(results.any((p) => p.name.toLowerCase().contains('milk')), isTrue);
    });

    test('Category filtering works', () {
      final fruits = provider.getProductsByCategory('Fruits & Vegetables');
      expect(fruits, isNotEmpty);
      expect(fruits.every((p) => p.category.contains('Fruits & Vegetables')), isTrue);
    });
  });
}
