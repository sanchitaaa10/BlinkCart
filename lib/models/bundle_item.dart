import 'product.dart';

class BundleItem {
  final String id;
  final String title;
  final String subtitle;
  final String badgeText;
  final String imageUrl;
  final double bundlePrice;
  final double originalPrice;
  final List<Product> products;

  const BundleItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.imageUrl,
    required this.bundlePrice,
    required this.originalPrice,
    required this.products,
  });

  double get savings => originalPrice - bundlePrice;
  int get savingsPercentage => (((originalPrice - bundlePrice) / originalPrice) * 100).round();
  int get itemCount => products.length;
}
