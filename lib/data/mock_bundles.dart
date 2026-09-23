import '../models/bundle_item.dart';
import '../models/product.dart';
import 'mock_products.dart';

class MockBundles {
  static List<BundleItem> getBundles() {
    Product getProduct(String id) =>
        MockProducts.products.firstWhere((p) => p.id == id,
            orElse: () => MockProducts.products.first);

    return [
      BundleItem(
        id: 'bundle-brunch',
        title: 'Sunday Morning Breakfast Feast',
        subtitle: 'Farm Eggs + Whole Wheat Bread + Amul Butter + Orange Juice + Oats',
        badgeText: 'SAVE ₹80',
        imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=600&q=80',
        bundlePrice: 249.0,
        originalPrice: 329.0,
        products: [
          getProduct('db-03'), // Farm Eggs 6s
          getProduct('bk-01'), // Whole Wheat Bread
          getProduct('db-02'), // Amul Butter
          getProduct('bev-02'), // Orange Juice
        ],
      ),
      BundleItem(
        id: 'bundle-chai',
        title: 'Chai & Evening Crunch Combo',
        subtitle: 'Haldiram Aloo Bhujia + Oreo Cookies + KitKat + Salted Chips',
        badgeText: 'SAVE ₹30',
        imageUrl: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?auto=format&fit=crop&w=600&q=80',
        bundlePrice: 110.0,
        originalPrice: 140.0,
        products: [
          getProduct('sn-04'), // Aloo Bhujia
          getProduct('sn-06'), // Oreo
          getProduct('sn-07'), // KitKat
          getProduct('sn-01'), // Lay's Salted
        ],
      ),
      BundleItem(
        id: 'bundle-pasta',
        title: 'Gourmet Italian Pasta Night',
        subtitle: 'Barilla Penne Pasta + Extra Virgin Olive Oil + Fresh Garlic + Mushrooms',
        badgeText: 'SAVE ₹180',
        imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3d5d6281734?auto=format&fit=crop&w=600&q=80',
        bundlePrice: 799.0,
        originalPrice: 979.0,
        products: [
          getProduct('inf-07'), // Barilla Penne Pasta
          getProduct('stp-08'), // Extra Virgin Olive Oil
          getProduct('fv-10'), // Button Mushrooms
          getProduct('fv-02'), // Fresh Tomatoes
        ],
      ),
      BundleItem(
        id: 'bundle-midnight',
        title: 'Midnight Munchies Cravings Box',
        subtitle: 'Doritos Cheese + Coke Zero + Cadbury Silk + Pringles',
        badgeText: 'SAVE ₹60',
        imageUrl: 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?auto=format&fit=crop&w=600&q=80',
        bundlePrice: 315.0,
        originalPrice: 375.0,
        products: [
          getProduct('sn-02'), // Doritos
          getProduct('bev-01'), // Coke Zero
          getProduct('sn-05'), // Cadbury Silk
          getProduct('sn-03'), // Pringles
        ],
      ),
      BundleItem(
        id: 'bundle-hygiene',
        title: 'Complete Home Sparkle Hygiene Pack',
        subtitle: 'Surf Excel Matic + Vim Gel + Dettol Handwash + Harpic + Colin',
        badgeText: 'SAVE ₹120',
        imageUrl: 'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?auto=format&fit=crop&w=600&q=80',
        bundlePrice: 605.0,
        originalPrice: 725.0,
        products: [
          getProduct('cln-01'), // Surf Excel
          getProduct('cln-02'), // Vim Gel
          getProduct('pc-01'), // Dettol Handwash
          getProduct('cln-03'), // Harpic
          getProduct('cln-04'), // Colin Spray
        ],
      ),
    ];
  }
}
