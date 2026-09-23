import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  final Set<String> _wishlistProductIds = {};
  static const String _wishlistPrefKey = 'quickbasket_wishlist_ids';

  WishlistProvider() {
    _loadWishlistFromPrefs();
  }

  Set<String> get wishlistProductIds => {..._wishlistProductIds};
  int get itemCount => _wishlistProductIds.length;
  bool get isEmpty => _wishlistProductIds.isEmpty;

  bool isWishlisted(String productId) {
    return _wishlistProductIds.contains(productId);
  }

  void toggleWishlist(String productId) {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }
    _saveWishlistToPrefs();
    notifyListeners();
  }

  void addToWishlist(String productId) {
    if (!_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.add(productId);
      _saveWishlistToPrefs();
      notifyListeners();
    }
  }

  void removeFromWishlist(String productId) {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
      _saveWishlistToPrefs();
      notifyListeners();
    }
  }

  void clearWishlist() {
    _wishlistProductIds.clear();
    _saveWishlistToPrefs();
    notifyListeners();
  }

  List<Product> getWishlistedProducts(List<Product> allProducts) {
    return allProducts.where((p) => _wishlistProductIds.contains(p.id)).toList();
  }

  Future<void> _saveWishlistToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_wishlistPrefKey, _wishlistProductIds.toList());
    } catch (e) {
      debugPrint('Error saving wishlist: $e');
    }
  }

  Future<void> _loadWishlistFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_wishlistPrefKey);
      if (list != null && list.isNotEmpty) {
        _wishlistProductIds.clear();
        _wishlistProductIds.addAll(list);
        notifyListeners();
      } else {
        // Initial sample items for rich feel
        _wishlistProductIds.addAll(['fv-01', 'fv-06', 'db-01', 'sn-05', 'bev-04', 'pc-01', 'hc-02', 'if-01']);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
    }
  }
}
