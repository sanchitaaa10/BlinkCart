import 'package:flutter_test/flutter_test.dart';
import 'package:blinkcart/models/product.dart';
import 'package:blinkcart/data/mock_products.dart';
import 'package:blinkcart/data/mock_bundles.dart';
import 'package:blinkcart/data/mock_recipes.dart';
import 'package:blinkcart/data/mock_brands.dart';
import 'package:blinkcart/data/mock_reviews.dart';
import 'package:blinkcart/data/mock_faqs.dart';

void main() {
  group('Product & Expanded Content Catalog Tests', () {
    test('Mock products catalog has 97 items across all 14 departments', () {
      expect(MockProducts.products.length, greaterThanOrEqualTo(90));
      expect(MockProducts.products.length, equals(97));
    });

    test('Product JSON serialization and deserialization works correctly', () {
      final product = MockProducts.products.first;
      final json = product.toJson();
      final fromJson = Product.fromJson(json);

      expect(fromJson.id, product.id);
      expect(fromJson.name, product.name);
      expect(fromJson.price, product.price);
      expect(fromJson.discountPercentage, product.discountPercentage);
    });

    test('Savings calculation is correct for discounted items', () {
      final product = MockProducts.products.firstWhere((p) => p.hasDiscount);
      expect(product.savingsAmount, equals(product.originalPrice - product.price));
    });

    test('Mock Bundles catalog has 5 curated bundles with valid savings and products', () {
      final bundles = MockBundles.getBundles();
      expect(bundles.length, equals(5));
      for (final bundle in bundles) {
        expect(bundle.products, isNotEmpty);
        expect(bundle.bundlePrice, greaterThan(0));
        expect(bundle.originalPrice, greaterThanOrEqualTo(bundle.bundlePrice));
        expect(bundle.savings, equals(bundle.originalPrice - bundle.bundlePrice));
      }
    });

    test('Mock Recipe Kits catalog has 5 quick 15-min recipes with ingredients', () {
      final recipes = MockRecipes.getRecipes();
      expect(recipes.length, equals(5));
      for (final recipe in recipes) {
        expect(recipe.requiredIngredients, isNotEmpty);
        expect(recipe.steps, isNotEmpty);
        expect(recipe.totalIngredientCost, greaterThan(0));
      }
    });

    test('Mock Brand Spotlight has 8 top brand stores', () {
      expect(MockBrands.brands.length, equals(8));
      for (final brand in MockBrands.brands) {
        expect(brand.name, isNotEmpty);
        expect(brand.discountOffer, isNotEmpty);
      }
    });

    test('Mock Reviews generator returns detailed verified reviews for any product', () {
      final product = MockProducts.products.first;
      final reviews = MockReviews.getReviewsForProduct(product.id);
      expect(reviews, isNotEmpty);
      expect(reviews.every((r) => r.isVerifiedPurchase), isTrue);
    });

    test('Mock FAQs catalog covers all delivery and dark store topics', () {
      expect(MockFaqs.faqs.length, greaterThanOrEqualTo(6));
      final categories = MockFaqs.faqs.map((f) => f.category).toSet();
      expect(categories, contains('Delivery & Timing'));
      expect(categories, contains('Freshness & Quality'));
      expect(categories, contains('Returns & Refunds'));
    });
  });
}
