import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/coupon.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  Coupon? _appliedCoupon;
  double _tipAmount = 0.0;
  static const double freeDeliveryThreshold = 199.0;
  static const double standardDeliveryFee = 25.0;
  static const double handlingFee = 5.0;

  static const String _cartPrefKey = 'quickbasket_cart_items';

  CartProvider() {
    _loadCartFromPrefs();
  }

  Map<String, CartItem> get items => {..._items};
  List<CartItem> get itemsList => _items.values.toList();
  Coupon? get appliedCoupon => _appliedCoupon;
  double get tipAmount => _tipAmount;

  int get uniqueItemCount => _items.length;
  int get totalItemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  int getProductQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  double get itemTotal => _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get originalTotal => _items.values.fold(0.0, (sum, item) => sum + item.originalTotalPrice);
  double get productDiscountSavings => originalTotal - itemTotal;

  double get deliveryFee {
    if (_items.isEmpty) return 0.0;
    return itemTotal >= freeDeliveryThreshold ? 0.0 : standardDeliveryFee;
  }

  double get couponDiscount {
    if (_appliedCoupon == null || _items.isEmpty) return 0.0;
    return _appliedCoupon!.calculateDiscount(itemTotal);
  }

  double get finalTotal {
    if (_items.isEmpty) return 0.0;
    final total = itemTotal - couponDiscount + deliveryFee + handlingFee + _tipAmount;
    return total > 0 ? total : 0.0;
  }

  double get totalSavings {
    final deliverySavings = (itemTotal >= freeDeliveryThreshold && _items.isNotEmpty) ? standardDeliveryFee : 0.0;
    return productDiscountSavings + couponDiscount + deliverySavings;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity += 1;
      _saveCartToPrefs();
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
      if (_items.isEmpty) {
        _appliedCoupon = null;
      }
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    if (_items.isEmpty) {
      _appliedCoupon = null;
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  void setTip(double amount) {
    _tipAmount = amount;
    notifyListeners();
  }

  bool applyCoupon(Coupon coupon) {
    if (itemTotal >= coupon.minOrderAmount) {
      _appliedCoupon = coupon;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _appliedCoupon = null;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _appliedCoupon = null;
    _tipAmount = 0.0;
    _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> _saveCartToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> serialized =
          _items.values.map((item) => item.toJson()).toList();
      await prefs.setString(_cartPrefKey, jsonEncode(serialized));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  Future<void> _loadCartFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_cartPrefKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
        _items.clear();
        for (final item in decoded) {
          final cartItem = CartItem.fromJson(item as Map<String, dynamic>);
          _items[cartItem.product.id] = cartItem;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }
}
